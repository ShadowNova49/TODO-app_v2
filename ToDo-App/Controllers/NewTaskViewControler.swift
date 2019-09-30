//
//  NewTaskViewControler.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 05.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class NewTaskViewControler: UIViewController {

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var attachingImageView: UIImageView!
    
    @IBOutlet var slideMenu: UIView!
    
    var user: User!
    var ref: DatabaseReference!
    
    var dateTime: String?
    
    var attachPhotoUrl: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        timeTextField.inputView = timePicker
        timePicker.datePickerMode = .time
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        
        let tapToHideMenu = UITapGestureRecognizer(target: self, action: #selector(touchWasDetected(_:)))
        self.view.addGestureRecognizer(tapToHideMenu)
    }
    
    @IBAction func didTapAttachPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didTapDeleteAttachedPhoto (_ sender: UIButton) {
        attachPhotoUrl = nil
        attachingImageView.image = nil
    }
    
    @IBAction func didTapAddItem(_ sender: UIButton) {
        
        if (noteNameTextField.text!.isEmpty) {
            return
        }
        
        if (!dateTextField.text!.isEmpty){
            dateTime = dateTextField.text! + " " + timeTextField.text!
        }
        
        let storageRef = Storage.storage().reference().child("note_attach_image").child("\(NSUUID().uuidString).png")
        
        if let uploadData = self.attachPhotoUrl?.pngData() {
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    guard let url = url else { return }
                    let noteItem = Item(name: self.noteNameTextField.text, noteDescription: self.descriptionTextField.text, dateTime: self.dateTime, attachPhotoUrl: url.absoluteString)
                    let noteRef = self.ref.child("users").child(self.user.uid).child("notes").child(UUID().uuidString)
                    noteRef.setValue(noteItem.toAnyObject())

                })
            })
        } else {
            let noteItem = Item(name: self.noteNameTextField.text, noteDescription: self.descriptionTextField.text, dateTime: self.dateTime, attachPhotoUrl: nil)
            let noteRef = self.ref.child("users").child(self.user.uid).child("notes").child(UUID().uuidString)
            noteRef.setValue(noteItem.toAnyObject())
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func touchWasDetected(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
        if !slideMenu.frame.contains(touchPoint) {
            dismiss(animated: true, completion: nil)
        } else {
            view.endEditing(true)
        }
    }
    
    @objc func dateChanged(){
        getFormateFromPicker(format: "date")
    }
    
    @objc func timeChanged(){
        getFormateFromPicker(format: "time")
    }
    
    func getFormateFromPicker(format: String){
        let formatter = DateFormatter()
        
        switch format {
        case "date":
            formatter.dateFormat = "dd - MMM - yyyy"
            dateTextField.text = formatter.string(from: datePicker.date)
            
        case "time":
            formatter.dateFormat = "hh:mm a"
            timeTextField.text = formatter.string(from: timePicker.date)
            
        default:
            return
        }
    }
}
