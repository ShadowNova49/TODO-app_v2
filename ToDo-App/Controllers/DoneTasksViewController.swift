//
//  DoneTasksViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import ChameleonFramework
import DZNEmptyDataSet

class DoneTasksViewController: UIViewController, TodoListObserver {
  @IBOutlet weak var doneTasksTableView: UITableView!
  
  var requestedTasks: [Item] = [] {
    didSet {
      doneTasksTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    TodoListManager.shared.delegate = self
    TodoListManager.shared.startObservingDatabase(for: .doneTasks)
    
    doneTasksTableView.emptyDataSetSource = self
    doneTasksTableView.emptyDataSetDelegate = self
    doneTasksTableView.tableFooterView = UIView()
  }
  
  @IBAction func dismissView (_ sender: UIBarButtonItem){
    dismiss(animated: true, completion: nil)
  }
}

extension DoneTasksViewController: UITableViewDelegate, DZNEmptyDataSetDelegate, UIPopoverPresentationControllerDelegate {
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
    
    let doneTasksArrayRef = self.requestedTasks[indexPath.row]
    if let name = doneTasksArrayRef.name {
      popover.name = name
    }
    if let dateTime = doneTasksArrayRef.dateTime {
      popover.dateTime = dateTime
    }
    if let description = doneTasksArrayRef.noteDescription {
      popover.noteDescription = description
    }
    if let attachedImage = doneTasksArrayRef.attachedImageUrl {
      popover.attachedImageUrl = attachedImage
    }
    if let taskUid = doneTasksArrayRef.noteUid {
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
      TodoListManager.shared.deleteTodo(with: item.noteUid!, and: item.attachedImageUid)
    }
    action.backgroundColor = .flatRed
    
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "-⩗") { (action, view, completion) in
      // Mark todo like undone
      let noteRef = self.requestedTasks[indexPath.row].noteUid
      let data = [ "isDone": false ]
      TodoListManager.shared.updateExistingTodo(with: data as [AnyHashable : Any], and: noteRef!)
    }
    action.backgroundColor = .flatMint
    
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "Oops!"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "Apparently you do not have completed tasks yet."
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return UIImage(named: "empty_placeholder")
  }
}

extension DoneTasksViewController: UITableViewDataSource, DZNEmptyDataSetSource {
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
