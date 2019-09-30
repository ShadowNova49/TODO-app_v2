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
    
    @IBOutlet var noteDetailsView: UIView!
    @IBOutlet var noteNameTextField: UITextField!
    @IBOutlet var noteDateTimeTextField: UITextField!
    @IBOutlet var noteDescriptionTextField: UITextView!
    @IBOutlet var noteAttachedImage: UIImageView! {
        didSet {
            noteAttachedImage.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.imageTap))
            noteAttachedImage.addGestureRecognizer(tapGesture)
        }
    }
    
    let transition = Slider()
    var roundButton = UIButton()
    
    var user: User!
    static var items = [Item]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    @IBAction func doneButton(_ sender: UIButton) {
        self.noteDetailsView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            roundButton.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor, constant: 175),
            //roundButton.trailingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.trailingAnchor, constant: -170),
            roundButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
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
    
    func startObservingDatabase () {
        
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }
            
            ListModeViewController.items = newItems
            self.tableView.reloadData()
            
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListModeViewController.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let item = ListModeViewController.items[indexPath.row]
        cell.noteNameLabel.text = item.name
        cell.noteDateTimeLabel.text = item.dateTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ListModeViewController.items[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addSubview(noteDetailsView)
        noteDetailsView.center = self.view.center
        
        if let name = ListModeViewController.items[indexPath.row].name {
            noteNameTextField.text = name
        }
        
        if let noteDescription = ListModeViewController.items[indexPath.row].noteDescription {
            noteDescriptionTextField.text = noteDescription
        }
        
        if let dateTime = ListModeViewController.items[indexPath.row].dateTime {
            noteDateTimeTextField.text = dateTime
        }
        
        if let attachedImageUrl = ListModeViewController.items[indexPath.row].attachPhotoUrl {
            noteAttachedImage.loadImageUsingCacheWithUrlString(attachedImageUrl)
        }
        
        //noteDetailsView.
        //self.selectedIndexPath = indexPath
        //self.performSegue(withIdentifier: "ShowDetails", sender: indexPath.row)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowDetails") {
            let viewController = segue.destination as! TaskDetailsViewController
            let indexPath = sender as? Int
            
            //print(indexPath!)
            //print(items[indexPath!])
            
            if let name = ListModeViewController.items[indexPath!].name {
                viewController.name = name
            }
            
            if let dateTime = ListModeViewController.items[indexPath!].dateTime {
                viewController.dateTime = dateTime
            }
            
            if let description = ListModeViewController.items[indexPath!].noteDescription {
                viewController.noteDescription = description
            }
            
            if let attachedImage = ListModeViewController.items[indexPath!].attachPhotoUrl {
                viewController.attachedImageUrl = attachedImage
            }
        }
    }
    */
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
