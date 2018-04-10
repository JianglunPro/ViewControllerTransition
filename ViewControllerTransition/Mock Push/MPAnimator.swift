//
//  MPAnimator.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class MPAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true  // transitioning delegate 来设置对应的值
    
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
            toViewStartFrame = CGRect(x: containerView.bounds.width,
                                      y: 0,
                                      width: containerView.bounds.width,
                                      height: containerView.bounds.height)
            toView.frame = toViewStartFrame
            containerView.addSubview(toView)
        }
        else {
            fromViewFinalFrame = CGRect(x: containerFrame.width,
                                        y: 0,
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
