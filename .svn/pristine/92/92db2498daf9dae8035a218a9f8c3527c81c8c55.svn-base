//
//  TabViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/08/05.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, RightViewControllerDelegate {
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}