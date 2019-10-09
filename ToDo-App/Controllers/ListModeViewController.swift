//
//  ListModelViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 05.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import ChameleonFramework

class ListModeViewController: UIViewController, TodoListObserver, SignOutDelegate {
  @IBOutlet weak var undoneTasksTableView: UITableView!
  
  let transition = Slider()
  var addNewNoteButton = UIButton()
  var doneTasksButton = UIButton()
  
  var requestedTasks: [Item] = [] {
    didSet {
      undoneTasksTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buttonsCreator()
    setupTableView()
  }
  
  override func viewWillLayoutSubviews() {
    self.setupAddNewNoteButton()
    self.setupDoneTasksButton()
  }
  
  //MARK: - Action Handler for addNewNoteButton
  
  @IBAction func addNewNoteButtonClick(_ sender: UIButton) {
    guard let newTaskViewController = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as? NewTaskViewControler
      else { return }
    newTaskViewController.modalPresentationStyle = .overCurrentContext
    newTaskViewController.transitioningDelegate = self
    present(newTaskViewController, animated: true)
  }
  
  //MARK: - Action Handler for doneTasksButton
  
  @IBAction func doneTasksButtonClick(_ sender: UIButton) {
    performSegue(withIdentifier: "DoneTasksNavigationController", sender: nil)
  }
  
  //MARK: - Action Handler for signOutButton
  
  @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
    AuthManager.share.signOut()
  }
  
  //MARK: - Function that perfom segue to sign in menu
  
  func signOutSegue() {
    performSegue(withIdentifier: "SignOut", sender: nil)
  }
  
  //MARK: - Function that help to dismiss keyboard while user interact with view
  
  @objc func touchWasDetected(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
 
  //MARK: - Function that help to prepare data for table view
  
  func setupTableView() {
    AuthManager.share.signOutDelegate = self
    TodoListManager.shared.delegate = self
    TodoListManager.shared.startObservingDatabase(for: .undoneTasks)
  }
  
  //MARK: - Function that create overlay buttons
  
  func buttonsCreator() {
    self.addNewNoteButton = UIButton(type: .custom)
    self.addNewNoteButton.setTitleColor(.blue, for: .normal)
    self.addNewNoteButton.addTarget(self, action: #selector(addNewNoteButtonClick(_:)), for: .touchUpInside)
    self.view.addSubview(addNewNoteButton)
    
    self.doneTasksButton = UIButton(type: .custom)
    self.doneTasksButton.setTitleColor(.blue, for: .normal)
    self.doneTasksButton.addTarget(self, action: #selector(doneTasksButtonClick(_:)), for: .touchUpInside)
    self.view.addSubview(doneTasksButton)
  }
  
  //MARK: - doneTasksButton layout setup method
  
  func setupDoneTasksButton() {
    doneTasksButton.layer.cornerRadius = doneTasksButton.layer.frame.size.width/2
    doneTasksButton.backgroundColor = .flatMint
    doneTasksButton.clipsToBounds = true
    doneTasksButton.setTitle("⩗", for: .normal)
    doneTasksButton.setTitleColor(.white, for: .normal)
    doneTasksButton.contentMode = .scaleAspectFit
    doneTasksButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      doneTasksButton.leadingAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.leadingAnchor, constant: undoneTasksTableView.frame.width/2 - 60),
      doneTasksButton.bottomAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      doneTasksButton.widthAnchor.constraint(equalToConstant: 50),
      doneTasksButton.heightAnchor.constraint(equalToConstant: 50)])
  }
  
  //MARK: - addNewNoteButton layout setup method
  
  func setupAddNewNoteButton() {
    addNewNoteButton.layer.cornerRadius = addNewNoteButton.layer.frame.size.width/2
    addNewNoteButton.backgroundColor = .flatMint
    addNewNoteButton.clipsToBounds = true
    addNewNoteButton.setTitle("+", for: .normal)
    addNewNoteButton.setTitleColor(.white, for: .normal)
    addNewNoteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addNewNoteButton.leadingAnchor.constraint(equalTo: doneTasksButton.leadingAnchor, constant: 70),
      addNewNoteButton.bottomAnchor.constraint(equalTo: undoneTasksTableView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      addNewNoteButton.widthAnchor.constraint(equalToConstant: 50),
      addNewNoteButton.heightAnchor.constraint(equalToConstant: 50)])
  }
}

// MARK: - UITableViewDelegate, UIPopoverPresentationControllerDelegate

extension ListModeViewController: UITableViewDelegate, UIPopoverPresentationControllerDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCellSourceView = tableView.cellForRow(at: indexPath)
    let yOffset = CGFloat(200)
    
    guard let popover = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController else { return }
    popover.modalPresentationStyle = .popover
    popover.popoverPresentationController?.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.93, alpha: 1.00)
    popover.popoverPresentationController?.delegate = self
    popover.popoverPresentationController?.sourceView = selectedCellSourceView
    popover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    popover.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y - yOffset, width: 0, height: 0)
    
    let undoneTasksArrayRef = self.requestedTasks[indexPath.row]
    if let name = undoneTasksArrayRef.name {
      popover.name = name
    }
    if let dateTime = undoneTasksArrayRef.dateTime {
      popover.dateTime = dateTime
    }
    if let description = undoneTasksArrayRef.noteDescription {
      popover.noteDescription = description
    }
    if let attachedImage = undoneTasksArrayRef.attachedImageUrl {
      popover.attachedImageUrl = attachedImage
    }
    if let taskUid = undoneTasksArrayRef.noteUid {
      popover.noteUid = taskUid
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
      // Delete todo
      let item = self.requestedTasks[indexPath.row]
      TodoListManager.shared.deleteTodo(with: item.noteUid!, and: item.attachedImageUid ?? nil)
    }
    action.backgroundColor = .flatRed

    return UISwipeActionsConfiguration(actions: [action])
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "✔") { (action, view, completion) in
      // Mark todo like done
      let noteRef = self.requestedTasks[indexPath.row].noteUid
      let data = [ "isDone": true ]
      TodoListManager.shared.updateExistingTodo(with: data as [AnyHashable : Any], and: noteRef!)
    }
    action.backgroundColor = .flatMint
    
    return UISwipeActionsConfiguration(actions: [action])
  }
}

// MARK: - UITableViewDataSource

extension ListModeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.requestedTasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reusebleIdentifier = "NoteCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: reusebleIdentifier, for: indexPath) as! TableViewNoteCell
    let item = self.requestedTasks[indexPath.row]
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
