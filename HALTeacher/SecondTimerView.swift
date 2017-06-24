//
//  SecondTimerView.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/15.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

@IBDesignable
class SecondTimerView: UIView, SecondViewsTimerDelegate {
    @IBOutlet weak var timerLabel: UILabel!
    
    /**
    コードで初期化した場合
    */
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        comminInit()
    }
    
    /**
    xib,Storyboardで初期化した場合
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    // プロパティに追加
    @IBInspectable var titleText: String = "" {
        didSet {
            self.timerLabel.text = titleText
        }
    }
    
    /**
    xibからカスタムViewを読み込んで準備する
    */
    private func comminInit() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SecondTimer", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(0),
            metrics:nil,
            views: bindings))
    }
    
    /**
    タイマースタート
    */
    func startTimer(timerCounr:Int) {
        Timer.timerInstance.startTimer(timerCounr)
    }
    
    /**
    タイマーからのデリゲート、Labelにタイマー表示
    */
    func setTimerText(time: String, timeNum: Int) {
        
        if timeNum == 0 {
            self.timerLabel.text = time
        }
        
        var setMin = timeNum/60
        var setSec = timeNum%60
        
        
        //どちらも10未満のとき、00:00のときはFinishなので処理がかぶらないようにする
        if(setMin < 10 && setSec < 10 && Timer.timerInstance.timerCount != 0){
            self.timerLabel.text = "0" + (String)(setMin) + ":0" + (String)(setSec)
        }
        
        //10分未満とき頭に0を加える
        else if(setMin < 10 && setSec >= 10){
            self.timerLabel.text = "0" + (String)(setMin) + ":" + (String)(setSec)
        }
        
        //10秒未満のとき秒数の頭に0を加えるよ
        else if(setMin >= 10 && setSec < 10){
            self.timerLabel.text = (String)(setMin) + ":0" + (String)(setSec)
        }
        
        //どちらも10以上のとき
        else if(setMin >= 10 && setSec >= 10){
            self.timerLabel.text = (String)(setMin) + ":" + (String)(setSec)
        }
    }
}