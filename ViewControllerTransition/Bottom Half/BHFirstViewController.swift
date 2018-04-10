//
//  BHFirstViewController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class BHFirstViewController: UIViewController {
    
    // 强引用
    let transitioner = BHTransitioningDelegate()

    @IBAction func present() {
        let sb = UIStoryboard(name: "BottomHalf", bundle: nil)
        let secondVc = sb.instantiateViewController(withIdentifier: "SecondViewController")
        
        secondVc.modalPresentationStyle = .custom
        secondVc.transitioningDelegate = transitioner
        
        present(secondVc, animated: true, completion: nil)
    }
    
    @IBAction func backToMenu() {
        dismiss(animated: true, completion: nil)
    }

}

