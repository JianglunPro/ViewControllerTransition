//
//  CDFirstViewController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class CDFirstViewController: UIViewController {
    
    // must be a strong refrence. becuase 'tansitionDelegate' property is a weak refrence
    let transition = CDTransitioningDelegate()

    @IBAction func present() {
        let sb = UIStoryboard(name: "CrossDissolve", bundle: nil)
        let secondVc = sb.instantiateViewController(withIdentifier: "SecondViewController")
        
        // ---------
        secondVc.transitioningDelegate = transition
        // ---------
        
        present(secondVc, animated: true, completion: nil)
    }
    
    @IBAction func backToMenu() {
        dismiss(animated: true, completion: nil)
    }

}

/*
 The transitioning delegate is the starting point for transition animations and custom presentations.
 It's job is to provide three objects:
 1.Animator
    manage the animation of 'fromView' and 'toView'
 2.Presentation controller
    customize presentaion, create add manage the animation of extra views(like a dimming view)
 3.Interactive animator
    manage the interaction
 */
class CDTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CDAnimator()
        animator.presenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CDAnimator()
        animator.presenting = false
        return animator
    }
    
}

class CDAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // use this property judging the transition is a present or a dismiss
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get imformation needed from 'Transition Context'
        let duration = transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from) ?? fromVc.view
        let toView: UIView = transitionContext.view(forKey: .to) ?? toVc.view
        
        let fromViewStartFrame = transitionContext.initialFrame(for: fromVc)
        let _ = transitionContext.finalFrame(for: fromVc)
        let _ = transitionContext.initialFrame(for: toVc)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVc)
        /*
         iPhone 8 Plus
         -- present --
         fromViewStartFrame (0.0, 0.0, 414.0, 736.0)
         fromViewFinalFrame (0.0, 0.0, 0.0, 0.0)
         toViewStartFrame   (0.0, 0.0, 0.0, 0.0)
         toViewFinalFrame   (0.0, 0.0, 414.0, 736.0)
         -- dismiss --
         fromViewStartFrame (0.0, 0.0, 414.0, 736.0)
         fromViewFinalFrame (0.0, 0.0, 414.0, 736.0)
         toViewStartFrame   (0.0, 0.0, 0.0, 0.0)
         toViewFinalFrame   (0.0, 0.0, 414.0, 736.0)
         */
        
        // prepare the state before animation
        if presenting {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }

        fromView.frame = fromViewStartFrame
        toView.frame = toViewFinalFrame
        fromView.alpha = 1.0
        toView.alpha = 0.0
        
        // animate
        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }, completion: { finished in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toView.removeFromSuperview()
            }
            // notify UIKit the transition is finished
            transitionContext.completeTransition(success)
        })
    }
    
}

