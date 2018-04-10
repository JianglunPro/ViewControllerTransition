//
//  MPSecondViewController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class MPSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加屏幕边缘手势
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(gestureAction(sender:)))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)
    }
    
    @objc func gestureAction(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            
            // 将手势通过 trasition delegate '共享'给 interaction controller
            let transitioner = transitioningDelegate as! MPTransitioningDelegate
            transitioner.gesture = sender
            
            dismiss()
        }
    }

    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }

}
