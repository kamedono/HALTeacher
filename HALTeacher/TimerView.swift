//
//  TimerView.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/18.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

@IBDesignable
class TimerView: UIView, TimerDelegate {
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
    
    /**
    タイマー終了時
    */
    override func willMoveToWindow(newWindow: UIWindow?) {
        if(Timer.timerInstance.timerCount == 0){
            self.timerLabel.text = "Finish!"
        }
        else {
            self.timerLabel.text = Timer.timerInstance.timerCount.description
        }
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
        let nib = UINib(nibName: "Timer", bundle: bundle)
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
        self.timerLabel.text = time
    }
    
}