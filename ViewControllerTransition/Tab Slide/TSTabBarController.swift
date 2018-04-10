//
//  TSTabBarController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/6.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class TSTabBarController: UITabBarController {
    
    let tabDelegate = TSTabBarControllerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = tabDelegate
    }

}


class TSTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = TSAnimator()
        
        let viewControllers = tabBarController.viewControllers!
        if viewControllers.index(of: toVC)! > viewControllers.index(of: fromVC)! {
            animator.direction = .right
        } else {
            animator.direction = .left
        }
        
        return animator
    }
}

class TSAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TSAnimatorDirection {
        case right
        case left
    }
    
    var direction: TSAnimatorDirection = .right
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 从 transition context 获取相关信息
        let duration = transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from) ?? fromVc.view
        let toView: UIView = transitionContext.view(forKey: .to) ?? toVc.view
        
        let containerFrame = containerView.frame
        let _ = transitionContext.initialFrame(for: fromVc)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVc)
        var toViewStartFrame = transitionContext.initialFrame(for: toVc)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVc)
        /*
         iPhone 8 Plus
         fromViewStartFrame (0.0, 0.0, 414.0, 736.0)
         fromViewFinalFrame (0.0, 0.0, 0.0, 0.0)
         toViewStartFrame   (0.0, 0.0, 0.0, 0.0)
         toViewFinalFrame   (0.0, 0.0, 414.0, 736.0)
         */
        
        // 动画开始前的准备
        if direction == .right {
            toViewStartFrame = CGRect(x: containerFrame.width,
                                      y: 0,
                                      width: containerFrame.width,
                                      height: containerFrame.height)
            fromViewFinalFrame = CGRect(x: -containerFrame.width,
                                        y: 0,
                                        width: containerFrame.width,
                                        height: containerFrame.height)
            
        } else {
            toViewStartFrame = CGRect(x: -containerFrame.width,
                                      y: 0,
                                      width: containerFrame.width,
                                      height: containerFrame.height)
            fromViewFinalFrame = CGRect(x: containerFrame.width,
                                        y: 0,
                                        width: containerFrame.width,
                                        height: containerFrame.height)
        }
        
        toView.frame = toViewStartFrame
        containerView.addSubview(toView)

        
        // 动画
        UIView.animate(withDuration: duration, animations: {
            toView.frame = toViewFinalFrame
            fromView.frame = fromViewFinalFrame
        }, completion: { finished in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toView.removeFromSuperview()
            }
            // 通知 UIKit 转场结束
            transitionContext.completeTransition(success)
        })
    }
    
}
