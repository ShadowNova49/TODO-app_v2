//
//  TaskDetailsViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

    import UIKit

    class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var noteAttachedImage: UIImageView!
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteDateTimeTextField: UITextField!
    @IBOutlet weak var noteDescriptionTextField: UITextView!

    var name: String?
    var dateTime: String?
    var noteDescription: String?
    var attachedImageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteNameTextField.text = name
        self.noteDateTimeTextField.text = dateTime
        self.noteDescriptionTextField.text = noteDescription
        
        
        if let attachedImageUrl = attachedImageUrl {
            noteAttachedImage.loadImageUsingCacheWithUrlString(attachedImageUrl)
        }
    }

    @IBAction func doneButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowListMode", sender: nil)
    }
}
