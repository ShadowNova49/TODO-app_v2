//
//  Slider.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 06.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class Slider: NSObject, UIViewControllerAnimatedTransitioning  {
    
    var isPresenting = false
    var dimmingView = UIView()
    //var transition = Slider()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    /*
    @objc func touchWasDetected(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: dimmingView)
        if dimmingView.frame.contains(touchPoint) {
            print("Work")
            self.dimmingView.alpha = 0.0
        
        }
    }
    */
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height
        
        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            
            //let tapToHideMenu = UITapGestureRecognizer(target: self, action: #selector(touchWasDetected(_:)))
            //self.dimmingView.addGestureRecognizer(tapToHideMenu)
            
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)
            
            // Init frame off the screen
            toViewController.view.frame = CGRect(x: 1.3*finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: -finalWidth, y: 0)
        }
        
        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        
        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
}


