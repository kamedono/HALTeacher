//
//  Timer.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/07/26.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import Foundation

/**
タイマーのプロトコル
*/
@objc protocol TimerDelegate {
    optional func setTimerText(time: String, timeNum: Int)
}

@objc protocol SecondViewsTimerDelegate {
    optional func setTimerText(time: String, timeNum: Int)
}

@objc protocol FinishViewsTimerDelegate {
    optional func finish()
}


class Timer: NSObject {
    var delegate: TimerDelegate!
    
    var secondDelegate: SecondViewsTimerDelegate!

    var finishDelegate: FinishViewsTimerDelegate!
    
    //カウントダウン変数
    var timeCountDown: Int = 1
    
//    // カウントを行うためのカウント
//    var count = 100
    
    // Singletonインスタンス
    static var timerInstance = Timer()
    
    var timerCount: Int = 0
    var nsTimer: NSTimer?
    
    func setTimer(){
        
    }
    
    
    /**
    タイマー開始
    
    :param: time:制限時間
    */
    func startTimer(time:Int) {
        self.nsTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("upDateTimer:"), userInfo: nil, repeats: true)
        timerCount = time
    }
    
    /**
    タイマー停止
    */
    func stopTimer() {
        if nsTimer != nil {
            self.nsTimer!.invalidate()
        }
    }
    
    /**
    タイマー停止時のイベント
    */
    func stopIvent() {
        // 終了通知
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.quizFinishUUID, sendData: "timerFinish")
        
        self.delegate?.setTimerText?("タイマーが終了しました", timeNum: timerCount)
        self.secondDelegate?.setTimerText?("Finish!", timeNum: timerCount)
        self.finishDelegate?.finish?()
        
    }
    
    /**
    タイマーのカウントごとの処理
    */
    func upDateTimer(timer: NSTimer){
        //以下になってたから残り１秒残ってても終了するので直した
        if self.timerCount == 0 {
            if timer.valid{
                timer.invalidate()
                self.stopIvent()
            }
        }
        else {
            self.timerCount--
            self.delegate?.setTimerText?(String("\(self.timerCount)"), timeNum: timerCount)
            self.secondDelegate?.setTimerText?(String("\(self.timerCount)"), timeNum: timerCount)
        }
    }
}