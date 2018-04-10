//
//  MPAnimator.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class BHAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        // 不知道为什么, 这里用 viewForKey 取不到值
        let fromView: UIView = transitionContext.view(forKey: .from) ?? fromVc.view
        let toView: UIView = transitionContext.view(forKey: .to) ?? toVc.view
        
        let _ = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVc)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVc)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVc)
        
        // 动画开始前的准备
        if presenting {
            toViewStartFrame = CGRect(x: 0,
                                      y: containerView.bounds.height,
                                      width: toViewFinalFrame.width,
                                      height: toViewFinalFrame.height)
            toView.frame = toViewStartFrame
            containerView.addSubview(toView)
        }
        else {
            fromViewFinalFrame = CGRect(x: 0,
                                        y: containerView.bounds.height,
                                        width: fromViewFinalFrame.width,
                                        height: fromViewFinalFrame.height)
            
            // 默认的 presentaionStyle 是 .fullScreen, 这种会在转场结束时, remove 掉 presentedView
            // 当我们使用 presentaionController 时, presentaionStyle 必须设置为 .custom, 这种不会 remove 掉 presentedView
            // 如果 insert 了, 会有问题
            // toView.frame = toViewFinalFrame
            // containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        // 动画
        UIView.animate(withDuration: duration, animations: {
            if self.presenting {
                toView.frame = toViewFinalFrame
                fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.95)
            }
            else {
                fromView.frame = fromViewFinalFrame
                toView.transform = CGAffineTransform.identity
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
