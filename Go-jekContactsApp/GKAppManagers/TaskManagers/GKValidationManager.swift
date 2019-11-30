//
//  GKValidationManager.swift
//  Go-jekContactsApp
//



import Foundation
struct REGEX
{

    static let emailRegex =  "[A-Z0-9a-z]+[._%+-]*[A-Z0-9a-z]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let nameCharSet = "abcdefghijklmnopqrstuvwxyzåäöÅÄÖABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 "
}
struct GKValidationManager
{
    // Validate Email
    static func isValidEmail(_ enteredEmail:String) -> Bool
    {
        let emailFormat = REGEX.emailRegex
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
