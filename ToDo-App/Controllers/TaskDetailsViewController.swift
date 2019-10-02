//
//  TaskDetailsViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var noteAttachedImage: UIImageView! {
        didSet{
            noteAttachedImage.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.imageTap))
            noteAttachedImage.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDateTimeTextField: UITextField!
    @IBOutlet weak var noteDescriptionTextField: UITextView!
    
    var name: String?
    var dateTime: String?
    var noteDescription: String?
    var attachedImageUrl: String?
    var noteRef: String?
    
    var user: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteNameTextField.text = name
        self.noteDateTimeTextField.text = dateTime
        self.noteDescriptionTextField.text = noteDescription
        
        if let attachedImageUrl = attachedImageUrl {
            noteAttachedImage.kf.setImage(with: URL(string: attachedImageUrl))
        }
        
        user = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(self.user.uid).child("notes/")
        //let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(touchWasDetected(_:)))
        //self.noteDetailsView.addGestureRecognizer(tapToDismissKeyboard)
    }
    
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
    
    @IBAction func doneButton(_ sender: UIButton) {
        if noteNameTextField.text != name {
            let key = ref.key
            //print(key)
            let post = [
                "name": noteNameTextField.text]
            ref.child(key!).setValue(post)
        }
        dismiss(animated: true, completion: nil)
    }
}
