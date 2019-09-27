//
//  ListModelViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 05.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase

class ListModeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let transition = Slider()
    var roundButton = UIButton()
    
    var user: User!
    var items = [Item]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addResultButtonView()
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.blue, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)

        user = Auth.auth().currentUser
        ref = Database.database().reference()
        startObservingDatabase()
    }
    
    override func viewWillLayoutSubviews() {
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setTitle("+", for: .normal)
        //roundButton.setImage(UIImage(named:"your-image"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor, constant: 167),
            //roundButton.trailingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.trailingAnchor, constant: -170),
            roundButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            roundButton.widthAnchor.constraint(equalToConstant: 50), roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    /** Action Handler for button **/
    
    @IBAction func ButtonClick(_ sender: UIButton){
        guard let newTaskViewController = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as? NewTaskViewControler else { return }
        newTaskViewController.modalPresentationStyle = .overCurrentContext
        newTaskViewController.transitioningDelegate = self
        present(newTaskViewController, animated: true)
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
    
    func startObservingDatabase () {
        //databaseHandle = ref.child("notes").observe(.value, with:
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let item = items[indexPath.row]
        cell.noteNameLabel.text = item.name
        cell.noteDateTimeLabel.text = item.dateTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "ShowDetails", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowDetails") {
            let viewController = segue.destination as! TaskDetailsViewController
            let indexPath = sender as? Int
            
            //print(indexPath!)
            //print(items[indexPath!])
            
            if let name = items[indexPath!].name {
                viewController.name = name
            }
            
            if let dateTime = items[indexPath!].dateTime {
                viewController.dateTime = dateTime
            }
            
            if let description = items[indexPath!].noteDescription {
                viewController.noteDescription = description
            }
            
            if let attachedImage = items[indexPath!].attachPhotoUrl {
                viewController.attachedImageUrl = attachedImage
            }
        }
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
