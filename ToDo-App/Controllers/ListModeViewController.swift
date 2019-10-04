//
//  ListModelViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 05.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase

class ListModeViewController: UIViewController {
    
    @IBOutlet weak var undoneTasksTableVIew: UITableView!
    
    let transition = Slider()
    var addNewNoteButton = UIButton()
    var doneTasksButton = UIButton()
    
    var user: User!
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var undoneTasks = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNewNoteButton = UIButton(type: .custom)
        self.addNewNoteButton.setTitleColor(UIColor.blue, for: .normal)
        self.addNewNoteButton.addTarget(self, action: #selector(addNewNoteButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(addNewNoteButton)
        
        self.doneTasksButton = UIButton(type: .custom)
        self.doneTasksButton.setTitleColor(UIColor.blue, for: .normal)
        self.doneTasksButton.addTarget(self, action: #selector(doneTasksButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(doneTasksButton)
        
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        startObservingDatabase()
    }
    
    override func viewWillLayoutSubviews() {
        self.setUpAddNewNoteButton()
        self.setUpDoneTasksButton()
    }
    
    /** Action Handler for button **/
    
    @IBAction func addNewNoteButtonClick(_ sender: UIButton){
        guard let newTaskViewController = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as? NewTaskViewControler else { return }
        newTaskViewController.modalPresentationStyle = .overCurrentContext
        newTaskViewController.transitioningDelegate = self
        present(newTaskViewController, animated: true)
    }
    
    @IBAction func doneTasksButtonClick(_ sender: UIButton){
        guard let doneTasksViewController = storyboard?.instantiateViewController(withIdentifier: "DoneTasksViewController") as? DoneTasksViewController else { return }
        doneTasksViewController.modalPresentationStyle = .pageSheet
        present(doneTasksViewController, animated: true)
    }
    
    
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        handleLogout()
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "SignOut", sender: nil)
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }
    
    @objc func touchWasDetected(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    func setUpDoneTasksButton() {
        doneTasksButton.layer.cornerRadius = doneTasksButton.layer.frame.size.width/2
        doneTasksButton.backgroundColor = UIColor.lightGray
        doneTasksButton.clipsToBounds = true
        doneTasksButton.setTitle("√", for: .normal)
        //doneTasksButton(UIImage(named:"your-image"), for: .normal)
        doneTasksButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //doneTasksButton.leadingAnchor.constraint(equalTo: undoneTasksTableVIew.safeAreaLayoutGuide.leadingAnchor, constant: 250),
            doneTasksButton.trailingAnchor.constraint(equalTo: undoneTasksTableVIew.safeAreaLayoutGuide.trailingAnchor, constant: -145),
            doneTasksButton.bottomAnchor.constraint(equalTo: undoneTasksTableVIew.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            doneTasksButton.widthAnchor.constraint(equalToConstant: 50), doneTasksButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    func setUpAddNewNoteButton() {
        addNewNoteButton.layer.cornerRadius = addNewNoteButton.layer.frame.size.width/2
        addNewNoteButton.backgroundColor = UIColor.lightGray
        addNewNoteButton.clipsToBounds = true
        addNewNoteButton.setTitle("+", for: .normal)
        //addNewNoteButton(UIImage(named:"your-image"), for: .normal)
        addNewNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNewNoteButton.leadingAnchor.constraint(equalTo: undoneTasksTableVIew.safeAreaLayoutGuide.leadingAnchor, constant: 145),
            //addNewNoteButton.leadingAnchor.constraint(equalTo: undoneTasksTableVIew.safeAreaLayoutGuide.trailingAnchor, constant: -170),
            addNewNoteButton.bottomAnchor.constraint(equalTo: undoneTasksTableVIew.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            addNewNoteButton.widthAnchor.constraint(equalToConstant: 50), addNewNoteButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
            var newUndoneTasks = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                if item.isDone == false {
                    newUndoneTasks.append(item)
                }
            }
            self.undoneTasks = newUndoneTasks
            self.undoneTasksTableVIew.reloadData()
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    }
}

extension ListModeViewController: UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
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
        
        if let name = self.undoneTasks[indexPath.row].name {
            popover.name = name
        }
        if let dateTime = self.undoneTasks[indexPath.row].dateTime {
            popover.dateTime = dateTime
        }
        if let description = self.undoneTasks[indexPath.row].noteDescription {
            popover.noteDescription = description
        }
        if let attachedImage = self.undoneTasks[indexPath.row].attachPhotoUrl {
            popover.attachedImageUrl = attachedImage
        }
        if let noteUrl = self.undoneTasks[indexPath.row].ref {
            popover.ref = noteUrl
        }
        
        self.present(popover, animated: true)
        if let pop = popover.popoverPresentationController {
            popover.isModalInPopover = true
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
    }
       
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO: Delete todo
            let item = self.undoneTasks[indexPath.row]
            item.ref?.removeValue()
            
            let imageRef = Storage.storage().reference().child("note_attach_image").child("\(item.attachPhotoName!).png")
            print(item.attachPhotoUrl!)
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
            let item = self.undoneTasks[indexPath.row]
            let post = [ "isDone": true ]
            item.ref!.updateChildValues(post as [AnyHashable : Any])
        }
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
    
extension ListModeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.undoneTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell

        let item = self.undoneTasks[indexPath.row]
        cell.noteNameLabel.text = item.name
        cell.noteDateTimeLabel.text = item.dateTime
        return cell
    }
}

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
