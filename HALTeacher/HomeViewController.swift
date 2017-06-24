//
//  HomeViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/18.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBAction func unwindToTitle(segue: UIStoryboardSegue) {}
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セカンドスクリーンについて
        getScreen = UIScreen.screens()
        
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
            
            var waitViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WaitViewController") as! WaitViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: waitViewController)
            
        }
        
        // ナビゲーションバーの色設定
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
        
        // windowKeyの取得？
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.window?.makeKeyAndVisible()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        performSegueWithIdentifier("goNavigationSegue", sender: nil)
    }
    
}