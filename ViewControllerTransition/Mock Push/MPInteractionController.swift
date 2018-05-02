//
//  MPInteractionController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

// UIPercentDrivenInteractiveTransition 是系统提供的 UIViewControllerInteractiveTransitioning 的一种实现
class MPInteractionController: UIPercentDrivenInteractiveTransition {
    
    let gesture: UIScreenEdgePanGestureRecognizer
    var contextData: UIViewControllerContextTransitioning?
    
    init(gesture: UIScreenEdgePanGestureRecognizer) {
        self.gesture = gesture
        super.init()
        
        self.gesture.addTarget(self, action: #selector(gestureAction(gesture:)))
    }
    
    deinit {
        gesture.removeTarget(self, action: #selector(gestureAction(gesture:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // 开始之后, 如果不 update(_ percentComplete: CGFloat), 会自动走完转场过程
        super.startInteractiveTransition(transitionContext)
        // 后面要用到
        contextData = transitionContext
    }
    
    @objc func gestureAction(gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .began {
            // ..
        }
        else if gesture.state == .changed {
            let percent = percentForGesture(gesture: gesture)
            update(percent)
        }
        else if gesture.state == .ended {
            let percent = percentForGesture(gesture: gesture)
            if percent >= 0.5 {
                finish()
            } else {
                cancel()
            }
        }
    }
    
    func percentForGesture(gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        if let contextData = contextData {
            let containerView = contextData.containerView
            let location = gesture.location(in: containerView)
            let width = containerView.bounds.width
            let percent = location.x / width
            return percent
        }
        return 0
    }
    
    
}
