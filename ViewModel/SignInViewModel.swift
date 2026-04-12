//
//  SignInViewModel.swift
//  Yammy
//
//  Created by rania on 10/04/2026.
//


import Foundation

class SignInViewModel {
    
    func isEmailValid(_ email: String?) -> Bool {
            let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: email)
        }
        
    func isPasswordValid(_ pass: String?) -> Bool {
        guard let pass = pass, !pass.isEmpty else { return false }
        
        // 1. يمنع المسافات تماماً
        if pass.contains(" ") { return false }
        
        // 2. Regex: لازم على الأقل (حرف كبير + حرف صغير + رقم + 8 حروف كحد أدنى)
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let isStrong = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pass)
        
        return isStrong
    }
}
