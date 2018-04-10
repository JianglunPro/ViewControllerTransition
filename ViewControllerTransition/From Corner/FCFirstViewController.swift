//
//  FCFirstViewController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class FCFirstViewController: UIViewController {
    
    let transitioner = FCTransitioningDelegate()

    @IBAction func present() {
        let sb = UIStoryboard(name: "FromCorner", bundle: nil)
        let secondVc = sb.instantiateViewController(withIdentifier: "SecondViewController")
        secondVc.transitioningDelegate = transitioner
        present(secondVc, animated: true, completion: nil)
    }
    
    @IBAction func backToMenu() {
        dismiss(animated: true, completion: nil)
    }

}

class FCTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FCAnimator()
        animator.presenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FCAnimator()
        animator.presenting = false
        return animator
    }
    
}

class FCAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    
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
        var toViewStartFrame = transitionContext.initialFrame(for: toVc)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVc)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVc)
        
        // 动画开始前的准备
        if presenting {
            toViewStartFrame.origin.x = containerFrame.width
            toViewStartFrame.origin.y = containerFrame.height
            toView.frame = toViewStartFrame
            containerView.addSubview(toView)
        }
        else {
            fromViewFinalFrame = CGRect(x: containerFrame.width,
                                        y: containerFrame.height,
                                        width: toView.frame.width,
                                        height: toView.frame.height)
            
            toView.frame = toViewFinalFrame
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        // 动画
        UIView.animate(withDuration: duration, animations: {
            if self.presenting {
                toView.frame = toViewFinalFrame
            }
            else {
                fromView.frame = fromViewFinalFrame
            }
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

