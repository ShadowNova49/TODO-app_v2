//
//  DoneTasksViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class DoneTasksViewController: UIViewController {
  @IBOutlet weak var doneTasksTableView: UITableView!
  
  var user: User!
  var ref: DatabaseReference!
  private var databaseHandle: DatabaseHandle!
  
  var doneTasks: [Item] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    user = Auth.auth().currentUser
    ref = Database.database().reference()
    startObservingDatabase()
  }
  
  /** Function that receives a snapshot that contains the data at the specified location in the
   database at the time of the event in its value property. In this case th list of doneTasks **/
  
  func startObservingDatabase () {
    databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
      var newDoneTasks: [Item] = []
      
      for itemSnapShot in snapshot.children {
        let item = Item(snapshot: itemSnapShot as! DataSnapshot)
        if item.isDone == true {
          newDoneTasks.append(item)
        }
      }
      self.doneTasks = newDoneTasks
      self.doneTasksTableView.reloadData()
    })
  }
  
  deinit {
    ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    print("reference has been removed")
  }
  
  /** Function that help to dismiss keyboard while user interact with view **/
  
  @IBAction func dismissView (_ sender: UIBarButtonItem){
    dismiss(animated: true, completion: nil)
  }
}

extension DoneTasksViewController: UITableViewDelegate, UIPopoverPresentationControllerDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCellSourceView = tableView.cellForRow(at: indexPath)
    
    guard let popover = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController else { return }
    popover.modalPresentationStyle = .popover
    popover.popoverPresentationController?.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.93, alpha: 1.00)
    popover.popoverPresentationController?.delegate = self
    popover.popoverPresentationController?.sourceView = selectedCellSourceView
    popover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0) // .up
    popover.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y - 200, width: 0, height: 0)
    //popover.preferredContentSize = CGSize(width: 320, height: 420)
    
    if let name = self.doneTasks[indexPath.row].name {
      popover.name = name
    }
    if let dateTime = self.doneTasks[indexPath.row].dateTime {
      popover.dateTime = dateTime
    }
    if let description = self.doneTasks[indexPath.row].noteDescription {
      popover.noteDescription = description
    }
    if let attachedImage = self.doneTasks[indexPath.row].attachedImageUrl {
      popover.attachedImageUrl = attachedImage
    }
    if let noteUrl = self.doneTasks[indexPath.row].ref {
      popover.ref = noteUrl
    }
    
    self.present(popover, animated: true)
    if let pop = popover.popoverPresentationController {
      popover.isModalInPopover = true
      delay(on: 0.1) {
        pop.passthroughViews = nil
      }
    }
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  /** Function that helped popover to not desappear at once after a click  **/
  
  func delay(on time: Double, closure: @escaping ()->()) {
    let when = DispatchTime.now() + time
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
      // TODO: Delete todo
      let item = self.doneTasks[indexPath.row]
      item.ref?.removeValue()
      
      let imageRef = Storage.storage().reference().child("note_attach_image").child("\(item.attachedImageUid!).png")
      print(item.attachedImageUrl!)
      imageRef.delete {
        error in
        if let error = error {
          print(error)
        } else {
          print("File deleted successfully")
        }
      }
    }
    action.backgroundColor = .red
    
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
      let item = self.doneTasks[indexPath.row]
      let post = [ "isDone": false ]
      item.ref!.updateChildValues(post as [AnyHashable : Any])
    }
    action.backgroundColor = .green
    
    return UISwipeActionsConfiguration(actions: [action])
  }
}

extension DoneTasksViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.doneTasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! TableViewNoteCell
    let item = self.doneTasks[indexPath.row]
    cell.noteNameLabel.text = item.name
    cell.noteDateTimeLabel.text = item.dateTime
    return cell
  }
}
