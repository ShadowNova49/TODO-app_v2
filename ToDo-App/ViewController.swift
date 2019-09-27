//
//  ViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 18.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var roundButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        //self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)
    }
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"your-image"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -177.5),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    /** Action Handler for button **/
    
    @IBAction func ButtonClick(_ sender: UIButton){
        
        /** Do whatever you wanna do on button click**/
        
    }

}
