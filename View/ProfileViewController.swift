//
//  ProfileViewController.swift
//  Yammy
//
//  Created by rania on 11/04/2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let viewModel = SignUpViewModel()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        profileImageView.makeCircular()
        profileImageView.isUserInteractionEnabled = true
        loadUserData()
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 1. نجيب الصورة اللي اليوزر اختارها بعد التعديل (Edited Image)
        if let editedImage = info[.editedImage] as? UIImage {
            // 2. نعرض الصورة فوراً لليوزر عشان يحس إنها اتغيرت
            self.profileImageView.image = editedImage
            
            // 3. ننادي دالة الرفع (هنعملها دلوقتي)
            self.uploadProfileImage(image: editedImage)
        }
        
        // 4. نقفل شاشة الألبوم
        picker.dismiss(animated: true)
    }
    func uploadProfileImage(image: UIImage) {
        // 1. تحويل الصورة لبيانات (Data)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 2. مكان الحفظ في Firebase Storage
        let storageRef = Storage.storage().reference().child("profile_images/\(Auth.auth().currentUser?.uid ?? "user").jpg")
        
        // 3. الرفع
        storageRef.putData(imageData, metadata: nil) { [weak self] (metadata: StorageMetadata?, error: Error?) in
            if let error = error {
                print("Upload Error: \(error.localizedDescription)")
                return
            }
            
            // 4. جلب رابط الصورة بعد الرفع
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    self?.updateUserPhotoURL(url: downloadURL)
                }
            }
        }
    }

    func updateUserPhotoURL(url: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges { error in
            if error == nil {
                print("Profile Image Updated successfully!")
            }
        }
    }
    func loadUserData() {
        if let user = Auth.auth().currentUser {
            emailLabel.text = user.email
            nameLabel.text = user.displayName ?? "User Name"
            
            if let photoURL = user.photoURL {
                profileImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(systemName: "person.circle.fill"))
            }}
    }
    @IBAction func imageTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Profile Image", message: nil, preferredStyle: .actionSheet)
        
        // Gallery Option
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openPicker(source: .photoLibrary)
        }))
        
        // Camera Option (if available)
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
        
    }
    
    @IBAction func twitterTapped(_ sender: Any) {
       
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
            do {
                // 1. محاولة تسجيل الخروج من فايربيز
                try firebaseAuth.signOut()
                
                // 2. الرجوع لشاشة الـ Login (تأكدي من اسم الـ Storyboard ID)
                if let loginVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
                    loginVC.modalPresentationStyle = .fullScreen
                    present(loginVC, animated: true)
                }
                
                print("Logged out successfully")
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
    }
    
    @IBAction func editNameTapped(_ sender: Any) {
            // 1. إنشاء الـ Alert (باللغة الإنجليزية)
            let alert = UIAlertController(title: "Update Name", message: "Please enter your full name (at least two names)", preferredStyle: .alert)
            
            // 2. إضافة الـ TextField
            alert.addTextField { textField in
                textField.placeholder = "Full Name"
                textField.text = self.nameLabel.text // يعرض الاسم الحالي لسهولة التعديل
            }
            
            // 3. زرار الحفظ مع التعديلات الجديدة
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                if let newName = alert.textFields?.first?.text {
                    
                    // --- الاختبار هنا باستخدام دالتك في الـ ViewModel ---
                    if self?.viewModel.isNameValid(newName) == true {
                        
                        // 4. لو الاسم ثنائي: تحديث الاسم في الفايربيز
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = newName
                        changeRequest?.commitChanges { error in
                            if let error = error {
                                print("Firebase Error: \(error.localizedDescription)")
                            } else {
                                // تحديث الـ Label فوراً
                                DispatchQueue.main.async {
                                    self?.nameLabel.text = newName
                                }
                                print("Name updated successfully!")
                            }
                        }
                        
                    } else {
                        // 5. لو الاسم مش ثنائي: إظهار تنبيه بالخطأ (English)
                        self?.showErrorAlert(message: "Invalid name! Please enter at least two names.")
                    }
                }
            }
            
            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
        }

        // دالة مساعدة لإظهار التنبيه (توضع في الـ Extension)
        func showErrorAlert(message: String) {
            let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAlert, animated: true)
        }
    
    
}
