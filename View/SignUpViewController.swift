import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    private let viewModel = SignUpViewModel()
    let myColor = UIColor(named: "PrimaryColor") ?? .green
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var creatAccontBotton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if email.isEmpty || password.isEmpty {
            print("Please fill in all fields")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Sign Up Error: \(error.localizedDescription)")
                return
            }

            print("Account created successfully!")

            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self?.nameTextField.text

            changeRequest?.commitChanges { error in
                if let error = error {
                    print("Error saving name: \(error.localizedDescription)")
                } else {
                    print("Name saved!")
                }
                
                self?.navigateToHome()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 300
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension SignUpViewController {
    
    private func setupUI() {
        setupPasswordToggle(for: passwordTextField)
        setupPasswordToggle(for: confirmPasswordTextField)
        
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .asciiCapableNumberPad
        
        [emailTextField, phoneTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0?.semanticContentAttribute = .forceLeftToRight
            $0?.textAlignment = .left
        }
        
        validateFields()
    }
    
    private func setupPasswordToggle(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
}

extension SignUpViewController {
    
    private func setupActions() {
        [nameTextField, phoneTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
    }
    
    @objc private func validateFields() {
        let isNameOk = viewModel.isNameValid(nameTextField.text)
        let isPhoneOk = viewModel.isPhoneValid(phoneTextField.text)
        let isEmailOk = viewModel.isEmailValid(emailTextField.text)
        let isPassOk = viewModel.isPasswordValid(passwordTextField.text)
        let isMatchOk = viewModel.isPasswordMatched(passwordTextField.text, confirmPasswordTextField.text)
        
        updateFieldBorder(nameTextField, isValid: isNameOk)
        updateFieldBorder(phoneTextField, isValid: isPhoneOk)
        updateFieldBorder(emailTextField, isValid: isEmailOk)
        updateFieldBorder(passwordTextField, isValid: isPassOk)
        updateFieldBorder(confirmPasswordTextField, isValid: isMatchOk)
        
        let isFormValid = isNameOk && isPhoneOk && isEmailOk && isPassOk && isMatchOk
        updateButtonState(isValid: isFormValid)
    }
    
    private func updateFieldBorder(_ textField: UITextField, isValid: Bool) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
    }
    
    private func updateButtonState(isValid: Bool) {
        creatAccontBotton.isEnabled = isValid
        if isValid {
            creatAccontBotton.backgroundColor = UIColor(named: "PrimaryColor")
            creatAccontBotton.alpha = 1.0
            creatAccontBotton.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        } else {
            creatAccontBotton.backgroundColor = myColor.withAlphaComponent(0.3)
            creatAccontBotton.setTitleColor(.darkGray, for: .normal)
            creatAccontBotton.alpha = 1.0
        }
    }
}

extension SignUpViewController {
    
    func navigateToHome() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "MainTabBar") {
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

