//
//  MPTransitioningDelegate.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class MPTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // 当通过手势 dismiss 的时候, 从 persenting Vc 传递过来
    var gesture: UIScreenEdgePanGestureRecognizer?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MPAnimator()
        animator.presenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MPAnimator()
        animator.presenting = false
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // 在这里就算存在手势, 也不能确保就是交互触发, 可能是上一个‘周期’的手势...
        // 所以这里的判断是无效的, 然而 MPInteractionController 29 行
        if let gesture = gesture {
            let interactionController = MPInteractionController(gesture: gesture)
            return interactionController
        } else {
            return nil
        }
    }
    
}
