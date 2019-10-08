//
//  AuthManager.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 07.10.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthDelegate {
  func showAlert(_ message: String ) // authenticationFailed
  func signInSegue() //authenticationSucceeded
}

class AuthManager {
  static var share = AuthManager()
  var delegate: AuthDelegate!
  
  func signIn(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
      guard let _ = user else {
        if let error = error {
          if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .userNotFound:
              self.delegate.showAlert("User account not found. Try registering")
            case .wrongPassword:
              self.delegate.showAlert("Incorrect username/password combination")
            default:
              self.delegate.showAlert("Error: \(error.localizedDescription)")
            }
          }
          return
        }
        assertionFailure("user and error are nil")
        return
      }
      self.delegate.signInSegue()
    })
  }

  func signUp(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
      if let error = error {
        if let errCode = AuthErrorCode(rawValue: error._code) {
          switch errCode {
          case .invalidEmail:
            self.delegate.showAlert("Enter a valid email.")
          case .emailAlreadyInUse:
            self.delegate.showAlert("Email already in use.")
          default:
            self.delegate.showAlert("Error: \(error.localizedDescription)")
          }
        }
        return
      }
      self.delegate.signInSegue()
    })
  }
  
  func requestPasswordReset(email: String) {
    Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
      if let error = error {
        if let errCode = AuthErrorCode(rawValue: error._code) {
          switch errCode {
          case .userNotFound:
            DispatchQueue.main.async {
              self.delegate.showAlert("User account not found. Try registering")
            }
          default:
            DispatchQueue.main.async {
              self.delegate.showAlert("Error: \(error.localizedDescription)")
            }
          }
        }
        return
      } else {
        DispatchQueue.main.async {
          self.delegate.showAlert("You'll receive an email shortly to reset your password.")
        }
      }
    })
  }
}
