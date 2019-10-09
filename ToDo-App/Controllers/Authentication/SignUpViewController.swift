//
//  SignUpViewController.swift
//  ToDo-app
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, AuthDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    AuthManager.share.authDelegate = self
  }
  
  //MARK: - Action Handler for signUpButton
  
  @IBAction func didTapSignUp(_ sender: UIButton) {
    if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      return
    }
    AuthManager.share.signUp(email: emailTextField.text!, password: passwordTextField.text!)
  }
  
  //MARK: - Action Handler for backToLoginButton
  
  @IBAction func didTapBackToLogin(_ sender: UIButton) {
    self.dismiss(animated: true, completion: {})
  }
  
  //MARK: - Function thats handling alerts
  
  func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "ToDo-App", message: message, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  //MARK: - Function that perfom segue to main menu 
  
  func signInSegue() {
    performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
  }
}
