//
//  NewTaskViewControler.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 05.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class NewTaskViewControler: UIViewController {
  @IBOutlet weak var timeTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var noteNameTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextView!
  @IBOutlet weak var attachedImageView: UIImageView!
  @IBOutlet weak var imageNameLabel: UILabel!
  @IBOutlet weak var imageSizeLabel: UILabel!
  @IBOutlet weak var cancelImageButton: UIButton!
  
  let datePicker = UIDatePicker()
  let timePicker = UIDatePicker()
  var dateTime: String?
  var attachedImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPickers()

    let tapToHideBoard = UITapGestureRecognizer(target: self, action: #selector(tapWasDetected(_:)))
    self.view.addGestureRecognizer(tapToHideBoard)
  }
  
  //MARK: - Action Handler for left swipe gesture that hide slide menu
  
  @IBAction func swipeToHideMenu(_ sender: UISwipeGestureRecognizer) {
    dismiss(animated: true, completion: nil)
  }
  
  //MARK: - Action Handler for attachedImageButton
  
  @IBAction func didTapAttachImage(_ sender: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  //MARK: - Action for deleting attached image view
  
  @IBAction func didTapDeleteAttachedImage (_ sender: UIButton) {
    attachedImage = nil
    attachedImageView.image = nil
    imageNameLabel.text = nil
    imageSizeLabel.text = nil
    cancelImageButton.isHidden = true
  }
  
  //MARK: - Action Handler for addImageButton
  
  @IBAction func didTapAddItem(_ sender: UIButton) {
    if (noteNameTextField.text!.isEmpty) {
      return
    }
    if (!dateTextField.text!.isEmpty){
      dateTime = dateTextField.text! + " " + timeTextField.text!
    }
    TodoListManager.shared.createNewTodo(noteName: noteNameTextField.text!, noteDescription: descriptionTextField.text, dateTime: dateTime, attachedImage: attachedImage)
        
    self.dismiss(animated: true, completion: nil)
  }
  
  //MARK: - Function that dismiss some board while user interact with view
  
  @objc func tapWasDetected(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  //MARK: - Fucntion that setup date and time pickers
  
  func setupPickers() {
    dateTextField.inputView = datePicker
    datePicker.datePickerMode = .date
    timeTextField.inputView = timePicker
    timePicker.datePickerMode = .time
    
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
  }
  
  @objc func dateChanged(){
    getFormatFromPicker(with: "date")
  }
  
  @objc func timeChanged(){
    getFormatFromPicker(with: "time")
  }
  
  //MARK: - Function that take date format depending on the field
  
  func getFormatFromPicker(with format: String){
    let formatter = DateFormatter()
    
    switch format {
    case "date":
      formatter.dateFormat = "dd-MMM-yyyy"
      dateTextField.text = formatter.string(from: datePicker.date)
      
    case "time":
      formatter.dateFormat = "hh:mm a"
      timeTextField.text = formatter.string(from: timePicker.date)
      
    default:
      return
    }
  }
}
