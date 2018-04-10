//
//  MPFirstViewController.swift
//  ApplePie
//
//  Created by 姜伦 on 2018/4/5.
//  Copyright © 2018年 姜伦. All rights reserved.
//

import UIKit

class MPFirstViewController: UIViewController {
    
    let transitioner = MPTransitioningDelegate()

    @IBAction func present() {
        let sb = UIStoryboard(name: "MockPush", bundle: nil)
        let secondVc = sb.instantiateViewController(withIdentifier: "SecondViewController")
        secondVc.transitioningDelegate = transitioner
        present(secondVc, animated: true, completion: nil)
    }
    
    @IBAction func backToMenu() {
        dismiss(animated: true, completion: nil)
    }

}

