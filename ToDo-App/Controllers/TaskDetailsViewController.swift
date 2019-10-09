//
//  TaskDetailsViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Kingfisher

class TaskDetailsViewController: UIViewController {
  @IBOutlet weak var noteNameTextField: UITextField!
  @IBOutlet weak var noteDateTimeTextField: UITextField!
  @IBOutlet weak var noteDescriptionTextField: UITextView!
  @IBOutlet weak var noteAttachedImage: UIImageView! {
    didSet{
      noteAttachedImage.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.imageTap))
      noteAttachedImage.addGestureRecognizer(tapGesture)
    }
  }
  
  var name: String?
  var dateTime: String?
  var noteDescription: String?
  var attachedImageUrl: String?
  
  //var ref: DatabaseReference!
  var noteUid: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.noteNameTextField.text = name
    self.noteDateTimeTextField.text = dateTime
    self.noteDescriptionTextField.text = noteDescription
    
    if let attachedImageUrl = attachedImageUrl {
      noteAttachedImage.kf.setImage(with: URL(string: attachedImageUrl))
    }
  }
  
  //MARK: - Function that perfom segue to full screen mode 
  
  @objc func imageTap() {
    if self.noteAttachedImage.image != nil {
      self.performSegue(withIdentifier: "ShowFullScreenImage", sender: self.noteAttachedImage.image)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "ShowFullScreenImage") {
      let viewController = segue.destination as! FullScreenImageViewController
      let image = sender as? UIImage
      
      if let noteImage = image {
        viewController.image = noteImage
      }
    }
  }
  
  //MARK: - Action Handler for doneButton 
  
  @IBAction func doneButton(_ sender: UIButton) {
    if noteNameTextField.text != name || noteDescriptionTextField.text != noteDescription {
      let data = [
        "name": noteNameTextField.text,
        "noteDescription": noteDescriptionTextField.text
      ]
      TodoListManager.shared.updateExistingTodo(with: data as [AnyHashable : Any], and: noteUid)
    }
    dismiss(animated: true, completion: nil)
  }
}
