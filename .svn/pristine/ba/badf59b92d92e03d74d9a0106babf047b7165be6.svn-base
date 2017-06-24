//
//  SecondTimerViewController.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import Foundation

class SecondTimerViewController: UIViewController, SecondViewsTimerDelegate{
    
    @IBOutlet weak var secondTimerView: SecondTimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイマー設定
        //制限時間の取得
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var timerCount: Int = userDefaults.integerForKey("timer")

        //Timerデリゲート設定
        Timer.timerInstance.secondDelegate = self.secondTimerView

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        var timerFinish: String = Timer.timerInstance.timerCount.description
        if Timer.timerInstance.timerCount == 0 {
            timerFinish = "Finish!"
        }
        self.secondTimerView.setTimerText(timerFinish, timeNum: Timer.timerInstance.timerCount)
   
        Timer.timerInstance.secondDelegate = self.secondTimerView
        
    }
    
}