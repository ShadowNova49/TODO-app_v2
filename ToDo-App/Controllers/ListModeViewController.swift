//
//  ListModelViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 05.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ListModeViewController: UIViewController {
  @IBOutlet weak var undoneTasksTableView: UITableView!
  
  let transition = Slider()
  var addNewNoteButton = UIButton()
  var doneTasksButton = UIButton()
  
  var user: User!
  var ref: DatabaseReference!
  private var databaseHandle: DatabaseHandle!
  
  var undoneTasks: [Item] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.addNewNoteButton = UIButton(type: .custom)
    self.addNewNoteButton.setTitleColor(.blue, for: .normal)
    self.addNewNoteButton.addTarget(self, action: #selector(addNewNoteButtonClick(_:)), for: .touchUpInside)
    self.view.addSubview(addNewNoteButton)
    
    self.doneTasksButton = UIButton(type: .custom)
    self.doneTasksButton.setTitleColor(.blue, for: .normal)
    self.doneTasksButton.addTarget(self, action: #selector(doneTasksButtonClick(_:)), for: .touchUpInside)
    self.view.addSubview(doneTasksButton)
    
    user = Auth.auth().currentUser
    ref = Database.database().reference()
    startObservingDatabase()
  }
  
  override func viewWillLayoutSubviews() {
    self.setupAddNewNoteButton()
    self.setupDoneTasksButton()
  }
  
  /** Action Handler for addNewNoteButton **/
  
  @IBAction func addNewNoteButtonClick(_ sender: UIButton) {
    guard let newTaskViewController = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as? NewTaskViewControler else { return }
    newTaskViewController.modalPresentationStyle = .overCurrentContext
    newTaskViewController.transitioningDelegate = self
    present(newTaskViewController, animated: true)
  }
  
  /** Action Handler for doneTasksButton **/
  
  @IBAction func doneTasksButtonClick(_ sender: UIButton) {
    performSegue(withIdentifier: "DoneTasksNavigationController", sender: nil)
//    guard let doneTasksViewController = storyboard?.instantiateViewController(withIdentifier: "DoneTasksNavigationController") as? DoneTasksViewController else { return }
//    doneTasksViewController.modalPresentationStyle = .pageSheet
//    present(doneTasksViewController, animated: true)
  }
  
  /** Action Handler for signOutButton **/
  
  @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
      performSegue(withIdentifier: "SignOut", sender: nil)
    } catch let error {
      assertionFailure("Error signing out: \(error)")
    }
  }
  
  /** Function that help to dismiss keyboard while user interact with view **/
  
  @objc func touchWasDetected(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  /** doneTasksButton layout setup method **/
  
  func setupDoneTasksButton() {
    doneTasksButton.layer.cornerRadius = doneTasksButton.layer.frame.size.width/2
    doneTasksButton.backgroundColor = .flatMint
    doneTasksButton.clipsToBounds = true
    doneTasksButton.setTitle("⩗", for: .normal)
    doneTasksButton.setTitleColor(.white, for: .normal)
    //doneTasksButton.setBackgroundImage(UIImage(named: "icon0"), for: .normal)
    doneTasksButton.contentMode = .scaleAspectFit
    doneTasksButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      //doneTasksButton.trailingAnchor.constraint(equalTo: addNewNoteButton.trailingAnchor, constant: 50),
      doneTasksButton.leadingAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.leadingAnchor, constant: undoneTasksTableView.frame.width/2 - 60),
      doneTasksButton.bottomAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      doneTasksButton.widthAnchor.constraint(equalToConstant: 50), doneTasksButton.heightAnchor.constraint(equalToConstant: 50)])
  }
  
  /** addNewNoteButton layout setup method **/
  
  func setupAddNewNoteButton() {
    addNewNoteButton.layer.cornerRadius = addNewNoteButton.layer.frame.size.width/2
    addNewNoteButton.backgroundColor = .flatMint
    addNewNoteButton.clipsToBounds = true
    addNewNoteButton.setTitle("+", for: .normal)
    addNewNoteButton.setTitleColor(.white, for: .normal)
    //addNewNoteButton(UIImage(named:"your-image"), for: .normal)
    addNewNoteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      //addNewNoteButton.trailingAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.trailingAnchor, constant: -(undoneTasksTableView.frame.width/2 - 85)),
      addNewNoteButton.leadingAnchor.constraint(equalTo: doneTasksButton.leadingAnchor, constant: 70),
      addNewNoteButton.bottomAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      addNewNoteButton.widthAnchor.constraint(equalToConstant: 50), addNewNoteButton.heightAnchor.constraint(equalToConstant: 50)])
  }
  
  /** Function that receives a snapshot that contains the data at the specified location in the
   database at the time of the event in its value property. In this case th list of undoneTasks **/
  
  func startObservingDatabase () {
    databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
      var newUndoneTasks: [Item] = []
      
      for itemSnapShot in snapshot.children {
        let item = Item(snapshot: itemSnapShot as! DataSnapshot)
        if item.isDone == false {
          newUndoneTasks.append(item)
        }
      }
      self.undoneTasks = newUndoneTasks
      self.undoneTasksTableView.reloadData()
    })
  }
  
  deinit {
    ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    print("reference has been removed")
  }
}

// MARK: - UITableViewDelegate, UIPopoverPresentationControllerDelegate

extension ListModeViewController: UITableViewDelegate, UIPopoverPresentationControllerDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCellSourceView = tableView.cellForRow(at: indexPath)
    
    guard let popover = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController else { return }
    popover.modalPresentationStyle = .popover
    popover.popoverPresentationController?.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.93, alpha: 1.00)
    popover.popoverPresentationController?.delegate = self
    popover.popoverPresentationController?.sourceView = selectedCellSourceView
    popover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    popover.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y - 200, width: 0, height: 0)
    //popover.preferredContentSize = CGSize(width: 320, height: 420)
    
    if let name = self.undoneTasks[indexPath.row].name {
      popover.name = name
    }
    if let dateTime = self.undoneTasks[indexPath.row].dateTime {
      popover.dateTime = dateTime
    }
    if let description = self.undoneTasks[indexPath.row].noteDescription {
      popover.noteDescription = description
    }
    if let attachedImage = self.undoneTasks[indexPath.row].attachedImageUrl {
      popover.attachedImageUrl = attachedImage
    }
    if let noteUrl = self.undoneTasks[indexPath.row].ref {
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
      let item = self.undoneTasks[indexPath.row]
      item.ref?.removeValue()
      
      let imageRef = Storage.storage().reference().child("note_attach_image").child("\(item.attachedImageUid!).png")
      imageRef.delete {
        error in
        if let error = error {
          print(error)
        } else {
          print("File deleted successfully")
        }
      }
    }
    action.backgroundColor = .flatRed

    return UISwipeActionsConfiguration(actions: [action])
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "✔") { (action, view, completion) in
      // TODO: Mark todo like done
      let item = self.undoneTasks[indexPath.row]
      let post = [ "isDone": true ]
      item.ref!.updateChildValues(post as [AnyHashable : Any])
    }
    action.backgroundColor = .flatGreen
    
    return UISwipeActionsConfiguration(actions: [action])
  }
}

// MARK: - UITableViewDataSource

extension ListModeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.undoneTasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! TableViewNoteCell
    let item = self.undoneTasks[indexPath.row]
    cell.noteNameLabel.text = item.name
    cell.noteDateTimeLabel.text = item.dateTime
    return cell
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ListModeViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = true
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = false
    return transition
  }
}
