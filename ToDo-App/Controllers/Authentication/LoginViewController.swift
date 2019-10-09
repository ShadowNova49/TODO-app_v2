//
//  LoginViewController.swift
//  ToDo-app
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AuthDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    AuthManager.share.authDelegate = self
    AuthManager.share.userIsLogin()
  }
  
  //MARK: - Action Handler for signInButton
  
  @IBAction func didTapSignIn(_ sender: UIButton) {
    if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      return
    }
    AuthManager.share.signIn(email: emailTextField.text!, password: passwordTextField.text!)
  }

  //MARK: - Action Handler for requestPasswordResetButton
  
  @IBAction func didRequestPasswordReset(_ sender: UIButton) {
    let prompt = UIAlertController(title: "ToDo-App", message: "Email:", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
      let imputEmail = prompt.textFields![0].text
      if (imputEmail!.isEmpty) {
        return
      }
      AuthManager.share.requestPasswordReset(email: imputEmail!)
    }
    prompt.addTextField(configurationHandler: nil)
    prompt.addAction(okAction)
    present(prompt, animated: true, completion: nil)
  }
  
  //MARK: - Function that show alerts
  
  func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  //MARK: - Function that perfom segue to main menu 
  
  func signInSegue() {
    performSegue(withIdentifier: "SignInFromLogin", sender: nil)
  }
}
