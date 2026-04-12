import Foundation

class SignUpViewModel {
    
    // الأنماط (Regex)
    private let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private let phonePattern = "^01[0125][0-9]{8}$"
    private let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
    
    // دالة التنسيق الكبري
    func validateForm(name: String?, phone: String?, email: String?, pass: String?, confirm: String?) -> Bool {
        return isNameValid(name) &&
               isPhoneValid(phone) &&
               isEmailValid(email) &&
               isPasswordValid(pass) &&
               isPasswordMatched(pass, confirm)
    }
    
    // الدوال الفردية
    func isNameValid(_ name: String?) -> Bool {
        let words = name?.components(separatedBy: .whitespaces).filter { !$0.isEmpty } ?? []
        return words.count >= 2
    }
    
    func isPhoneValid(_ phone: String?) -> Bool {
        return isValid(text: phone, with: phonePattern)
    }
    
    func isEmailValid(_ email: String?) -> Bool {
        return isValid(text: email, with: emailPattern)
    }
    
    func isPasswordValid(_ pass: String?) -> Bool {
        return isValid(text: pass, with: passwordPattern)
    }
    
    func isPasswordMatched(_ pass: String?, _ confirm: String?) -> Bool {
        // تأكد أن الباسورد ليس فارغاً وأنه يطابق التأكيد
        guard let pass = pass, !pass.isEmpty else { return false }
        return pass == confirm
    }
    
    // --- دالة مساعدة عشان منكررش سطر الـ Predicate ---
    private func isValid(text: String?, with pattern: String) -> Bool {
        guard let text = text else { return false }
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: text)
    }
}
