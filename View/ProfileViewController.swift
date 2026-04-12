import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let viewModel = SignUpViewModel()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let side = min(profileImageView.frame.width, profileImageView.frame.height)
        if side > 0 {
            profileImageView.makeCircular()
        }
        profileImageView.isUserInteractionEnabled = true
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImageView.image = editedImage
            self.profileImageView.makeCircular()
            self.uploadProfileImage(image: editedImage)
        }
        picker.dismiss(animated: true)
    }

    func uploadProfileImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            self.showAlert(title: "Error", message: "Could not process image")
            return
        }
        
        let base64String = imageData.base64EncodedString()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).setData([
            "profileImageBase64": base64String
        ], merge: true) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save to Firestore: \(error.localizedDescription)")
            } else {
                self?.showAlert(title: "Success", message: "Profile image saved successfully!")
            }
        }
    }

    func loadUserData() {
        if UserDefaults.standard.bool(forKey: "isSocialLogin") {
            emailLabel.text = "social.demo@yammy.com"
            nameLabel.text = "Yammy Social User"
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = UIColor(named: "PrimaryColor")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else { return }
        let user = Auth.auth().currentUser
        
        emailLabel.text = user?.email
        nameLabel.text = user?.displayName ?? "User Name"
        
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        
        Firestore.firestore().collection("users").document(uid).addSnapshotListener { [weak self] (snapshot, error) in
            if let data = snapshot?.data(), let base64String = data["profileImageBase64"] as? String {
                if let imageData = Data(base64Encoded: base64String), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                    }
                }
            }
        }
    }

    @IBAction func imageTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Profile Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openPicker(source: .photoLibrary)
        }))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openPicker(source: .camera)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func openPicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    @IBAction func facebookTapped(_ sender: Any) {
        shareApp(via: "Facebook")
    }
    
    @IBAction func twitterTapped(_ sender: Any) {
        shareApp(via: "Twitter")
    }

    private func shareApp(via platform: String) {
        let appName = "Yammy 🍔"
        let message = "I'm using \(appName) to order delicious food! You should try it too 🎉"
        let shareURL = URL(string: "https://www.yammy-app.com") // Replace with your real app link
        
        var itemsToShare: [Any] = [message]
        if let url = shareURL {
            itemsToShare.append(url)
        }
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        // On iPad, the popover needs an anchor
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(activityVC, animated: true)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isSocialLogin")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true)
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    @IBAction func editNameTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Update Name", message: "Please enter your full name (at least two names)", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Full Name"
            textField.text = self.nameLabel.text
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let newName = alert.textFields?.first?.text {
                if self?.viewModel.isNameValid(newName) == true {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = newName
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            print("Firebase Error: \(error.localizedDescription)")
                        } else {
                            DispatchQueue.main.async {
                                self?.nameLabel.text = newName
                            }
                        }
                    }
                } else {
                    self?.showErrorAlert(message: "Invalid name! Please enter at least two names.")
                }
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func showErrorAlert(message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlert, animated: true)
    }
}
