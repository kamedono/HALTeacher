//
//  SecondWindowTimer.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

protocol SecondTimerDelegate{
    func setLabel(str: String)
}

class SecondWindowTimer: NSObject{
    
    var timer: NSTimer!
    var max: Int = 0
    
    func start(max: Int){
        
        //１秒ごとにupDaterを起動する
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "upDater:", userInfo: nil, repeats: true)
        self.max = max
    }
    
    func upDater(timer: NSTimer){
        self.max -= 1
        if self.max <= 1{
            if timer.valid{
                timer.invalidate()
            }
        }
        self.delegate.setLabel(max.description)
        //        setLabel(self.max.description)
    }
    
    var delegate: SecondTimerDelegate!
    static var timerinstance = SecondWindowTimer()
    
}
