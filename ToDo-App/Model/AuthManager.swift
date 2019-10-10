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
  func showAlert(_ message: String )
  func signInSegue()
}

protocol SignOutDelegate {
  func signOutSegue()
}

class AuthManager {
  static let share = AuthManager()
  var authDelegate: AuthDelegate!
  var signOutDelegate: SignOutDelegate!
  
  func signIn(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
      guard let _ = user else {
        if let error = error {
          if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .userNotFound:
              self.authDelegate.showAlert("User account not found. Try registering")
            case .wrongPassword:
              self.authDelegate.showAlert("Incorrect username/password combination")
            default:
              self.authDelegate.showAlert("Error: \(error.localizedDescription)")
            }
          }
          return
        }
        assertionFailure("user and error are nil")
        return
      }
      self.authDelegate.signInSegue()
    })
  }

  func signUp(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
      if let error = error {
        if let errCode = AuthErrorCode(rawValue: error._code) {
          switch errCode {
          case .invalidEmail:
            self.authDelegate.showAlert("Enter a valid email.")
          case .emailAlreadyInUse:
            self.authDelegate.showAlert("Email already in use.")
          default:
            self.authDelegate.showAlert("Error: \(error.localizedDescription)")
          }
        }
        return
      }
      self.authDelegate.signInSegue()
    })
  }
  
  func requestPasswordReset(email: String) {
    Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
      if let error = error {
        if let errCode = AuthErrorCode(rawValue: error._code) {
          switch errCode {
          case .userNotFound:
            DispatchQueue.main.async {
              self.authDelegate.showAlert("User account not found. Try registering")
           }
          default:
            DispatchQueue.main.async {
              self.authDelegate.showAlert("Error: \(error.localizedDescription)")
            }
          }
        }
        return
      } else {
        DispatchQueue.main.async {
          self.authDelegate.showAlert("You'll receive an email shortly to reset your password.")
        }
      }
    })
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      self.signOutDelegate.signOutSegue()
    } catch let error {
      assertionFailure("Error signing out: \(error)")
    }
  }
  
  
  func userIsLogin() {
    if let _ = Auth.auth().currentUser {
      self.authDelegate.signInSegue()
    }
  }
}
