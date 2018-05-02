//
//  CPNavigationController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/6.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class CPNavigationController: UINavigationController {
    
    let navDelegate = CPNavigationControllerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = navDelegate
    
        // setNavigationBarHidden(true, animated: false)
    
        // 添加手势
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(gestureAction(sender:)))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)
        
        navDelegate.gesture = edgeGesture
    }
    
    @objc func gestureAction(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            navDelegate.useGesture()
            popViewController(animated: true)
        }
    }

}

class CPNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    var gesture: UIScreenEdgePanGestureRecognizer!
    var usingGesture = false  // 用这个属性判断是否交互触发
    
    func useGesture() {
        usingGesture = true
        // 下策尔, 然暂无它法, 如知晓妙法, 还望告知
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.usingGesture = false
        }
    }
    
    // 和 presentation 用的是同一个 animation controller 和 interaction controller (同一个'类')
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CPAnimator()
        // 通过 operaion 获取信息
        if operation == .push {
            animator.pushing = true
        } else {
            animator.pushing = false
        }
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let animator = animationController as? CPAnimator {
            // 通过 animator 获取信息
            if !animator.pushing && usingGesture {
                let interactionController = CPInteractionController(gesture: gesture)
                return interactionController
            }
        }
        return nil
    }
}


class CPAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var pushing = true
    
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
         -- push --
         fromViewStartFrame (0.0, 0.0, 414.0, 736.0)
         fromViewFinalFrame (0.0, 0.0, 0.0, 0.0)
         toViewStartFrame   (0.0, 0.0, 0.0, 0.0)
         toViewFinalFrame   (0.0, 0.0, 414.0, 736.0)
         -- pop --
         fromViewStartFrame (0.0, 0.0, 414.0, 736.0)
         fromViewFinalFrame (0.0, 0.0, 0.0, 0.0)
         toViewStartFrame   (0.0, 0.0, 0.0, 0.0)
         toViewFinalFrame   (0.0, 0.0, 414.0, 736.0)
         */
        
        // 动画开始前的准备
        if pushing {
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
            
            toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        // 动画
        UIView.animate(withDuration: duration, animations: {
            if self.pushing {
                toView.frame = toViewFinalFrame
                fromView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            else {
                fromView.frame = fromViewFinalFrame
                toView.transform = CGAffineTransform.identity
            }
        }, completion: { finished in
            
            // 还原
            fromView.transform = CGAffineTransform.identity
            toView.transform = CGAffineTransform.identity
            
            let success = !transitionContext.transitionWasCancelled
            if !success {
                
                toView.removeFromSuperview()
            }
            // 通知 UIKit 转场结束
            transitionContext.completeTransition(success)
        })
    }
    
}

class CPInteractionController: UIPercentDrivenInteractiveTransition {
    
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
        // 在这里, 并不会像 presentaion 那样自动走完动画, (见 MPInteractionController)
        super.startInteractiveTransition(transitionContext)
        
        // Save the transitionContext for later.
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
