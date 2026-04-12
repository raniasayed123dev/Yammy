import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = SignInViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        setupUI()
    }
    
    // MARK: - Actions
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
        // 1. إنشاء نافذة التنبيه
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter your email to receive a reset link", preferredStyle: .alert)
        
        // 2. إضافة خانة للكتابة جوه التنبيه
        alert.addTextField { textField in
            textField.placeholder = "Email Address"
            textField.keyboardType = .emailAddress
        }
        
        // 3. زرار الإرسال
        let sendAction = UIAlertAction(title: "Send", style: .default) { _ in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                
                // أمر الفايربيز لإرسال الإيميل الحقيقي
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
        
        // 4. إظهار النافذة
        present(alert, animated: true)
        
    }
}
// MARK: - UI Logic & Validation
extension SignInViewController {
    
    func setupUI() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        [emailTextField, passwordTextField].forEach {
            $0?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
            $0?.semanticContentAttribute = .forceLeftToRight
            $0?.textAlignment = .left
            
            // 1. السطر ده بيمسح أي ستايل قديم من الـ Storyboard (بيحل مشكلة اللون الرمادي)
            $0?.borderStyle = .none
            
            // 2. بنوحد لون الخلفية عشان لو واحد أبيض وواحد رمادي في الـ Storyboard يتظبطوا
            $0?.backgroundColor = .white
            
            // 3. إعدادات الإطار اللي إحنا بنتحكم فيها
            $0?.layer.borderWidth = 1.0
            $0?.layer.cornerRadius = 8
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            
            // 4. (اختياري) لو عايزة الكلام ميبقاش لازق في الحيطة، ضيفي مسافة بسيطة من الشمال
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            $0?.leftView = paddingView
            $0?.leftViewMode = .always
        }
        
        validateFields() // الحالة الابتدائية
    }

    
    @objc private func validateFields() {
        let isEmailOk = viewModel.isEmailValid(emailTextField.text)
        let isPassOk = viewModel.isPasswordValid(passwordTextField.text)
        // استخدام دالة مساعدة لتلوين الإطارات (Clean Code)
        updateTextFieldBorder(emailTextField, isValid: isEmailOk)
        updateTextFieldBorder(passwordTextField, isValid: isPassOk)
        
        updateButtonState(isValid: isEmailOk && isPassOk)
    }
    
    private func updateTextFieldBorder(_ textField: UITextField, isValid: Bool) {
            let text = textField.text ?? ""
            
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 8 // عشان يبقى الشكل متناسق
            
            if text.isEmpty {
                textField.layer.borderColor = UIColor.lightGray.cgColor // رمادي لو فاضي
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

// MARK: - Navigation & Helpers
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
