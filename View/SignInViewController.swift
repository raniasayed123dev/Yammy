import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    private let viewModel = SignInViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        setupUI()
        setupSocialLoginGestures()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 250
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func signInBotton(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please fill in all fields")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            self?.navigateToHome()
        }
    }
    
    @IBAction func forgotPasswordBotton(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter your email to receive a reset link", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Email Address"
            textField.keyboardType = .emailAddress
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { _ in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("Reset link sent to: \(email)")
                    }
                }
            }
        }
        
        alert.addAction(sendAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

    private func setupSocialLoginGestures() {
        let facebookTap = UITapGestureRecognizer(target: self, action: #selector(facebookTapped))
        facebookImageView.addGestureRecognizer(facebookTap)
        facebookImageView.isUserInteractionEnabled = true

        let twitterTap = UITapGestureRecognizer(target: self, action: #selector(twitterTapped))
        twitterImageView.addGestureRecognizer(twitterTap)
        twitterImageView.isUserInteractionEnabled = true
    }

    @objc private func facebookTapped() {
        handleSocialLogin(platform: "Facebook")
    }

    @objc private func twitterTapped() {
        handleSocialLogin(platform: "Twitter")
    }

    private func handleSocialLogin(platform: String) {
        let alert = UIAlertController(title: "Sign in with \(platform)", 
                                    message: "Would you like to sign in using your \(platform) account?", 
                                    preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.view.showLoadingOverlay()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.view.hideLoadingOverlay()
                UserDefaults.standard.set(true, forKey: "isSocialLogin")
                self?.navigateToHome()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension SignInViewController {
    
    func setupUI() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.placeholder = "Enter your email address"
        passwordTextField.placeholder = "Write 8+ chars (Uppercase, lowercase, number))"
        
        [emailTextField, passwordTextField].forEach {
            $0?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
            $0?.semanticContentAttribute = .forceLeftToRight
            $0?.textAlignment = .left
            
            $0?.borderStyle = .none
            $0?.backgroundColor = .white
            
            $0?.layer.borderWidth = 1.0
            $0?.layer.cornerRadius = 8
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            $0?.leftView = paddingView
            $0?.leftViewMode = .always
        }
        
        setupPasswordToggle(for: passwordTextField)
        validateFields()
    }

    private func setupPasswordToggle(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        button.tintColor = .gray
        textField.rightView = button
        textField.rightViewMode = .always
    }

    @objc private func togglePasswordView(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let textField = sender.superview as? UITextField {
            textField.isSecureTextEntry.toggle()
        }
    }

    @objc private func validateFields() {
        let isEmailOk = viewModel.isEmailValid(emailTextField.text)
        let isPassOk = viewModel.isPasswordValid(passwordTextField.text)
        updateTextFieldBorder(emailTextField, isValid: isEmailOk)
        updateTextFieldBorder(passwordTextField, isValid: isPassOk)
        
        updateButtonState(isValid: isEmailOk && isPassOk)
    }
    
    private func updateTextFieldBorder(_ textField: UITextField, isValid: Bool) {
        let text = textField.text ?? ""
        
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        
        if text.isEmpty {
            textField.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            textField.layer.borderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        }
    }

    private func updateButtonState(isValid: Bool) {
        signinButton.isEnabled = isValid
        let myColor = UIColor(named: "PrimaryColor") ?? .green
        
        if isValid {
            signinButton.backgroundColor = myColor
            signinButton.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
            signinButton.alpha = 1.0
        } else {
            signinButton.backgroundColor = myColor.withAlphaComponent(0.3)
            signinButton.setTitleColor(.darkGray, for: .normal)
        }
    }
}

extension SignInViewController {
    
    func navigateToHome() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "MainTabBar") {
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
