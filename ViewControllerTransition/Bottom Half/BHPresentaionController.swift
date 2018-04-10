//
//  BHPresentaionController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class BHPresentaionController: UIPresentationController {

    let dimmingView = UIView()
    let presentationWrappingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        dimmingView.alpha = 0.0
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDimmingView)))
    }
    
    @objc func tapDimmingView() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerBounds = self.containerView!.bounds
        let presentedViewFrame = CGRect(x: 0,
                                        y: containerBounds.height / 2,
                                        width: containerBounds.width,
                                        height: containerBounds.height / 2)
        return presentedViewFrame
    }
    
    override func presentationTransitionWillBegin() {
        
        // Get critical information about the presentation.
        let containerView = self.containerView!
        let presentedVc = self.presentedViewController
        let transitionCoordinator = presentedVc.transitionCoordinator!
        
        // Insert the dimming view below everything else.
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        // animate
        transitionCoordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let presentedVc = self.presentedViewController
        let transitionCoordinator = presentedVc.transitionCoordinator!
        transitionCoordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
}
