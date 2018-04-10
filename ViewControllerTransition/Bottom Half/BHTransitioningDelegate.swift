//
//  BHTransitioningDelegate.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class BHTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = BHAnimator()
        animator.presenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = BHAnimator()
        animator.presenting = false
        return animator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // 初始化方法
        let presentaionController = BHPresentaionController(presentedViewController: presented, presenting: presenting)
        return presentaionController
    }
    
}
