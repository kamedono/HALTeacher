//
//  AddTimerViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/14.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class AddTimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, RightViewControllerDelegate {
    @IBOutlet weak var addPicker: UIPickerView!
    @IBOutlet weak var addPicker1: UIPickerView!
    @IBOutlet weak var picLabel1: UILabel!
    @IBOutlet weak var picLabel2: UILabel!
    @IBOutlet weak var timerView: TimerView!

    var miniList = ["0","1","2","3","4","5","6","7","8","9","10","11"]
    var secList = ["0","5","10","15","30","45"]
    
    var mini: Int = 3
    var sec: Int = 0
    
    //ラベル変更フラグ
    var flag: Int = 0
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getScreen = UIScreen.screens()
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
        }
        
        
//        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem = backButtonItem

        
        //ナビゲーションバーが出ない様にする
//        navigationController?.hidesBarsOnSwipe = true
        
        
        //ピッカーを黒枠で囲む
        addPicker.layer.borderColor = UIColor.blackColor().CGColor;
        addPicker.layer.borderWidth = 1
        
        //ピッカーを黒枠で囲む
        addPicker1.layer.borderColor = UIColor.blackColor().CGColor;
        addPicker1.layer.borderWidth = 1
        
        addPicker.dataSource = self
        addPicker.delegate = self
        
        addPicker1.dataSource = self
        addPicker1.delegate = self
        
        //初期状態の指定(第一引数:行 第二引数:列 第三引数:bool)
        //だがしかし値は0のままだあああ、miniの初期値3にすればいいのではないだろうか...
        addPicker.selectRow(3, inComponent: 0, animated: true)
        
        
        
        //タイマー設定
        //制限時間の取得
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var timerCount: Int = userDefaults.integerForKey("timer")
        //Timerデリゲート設定
        Timer.timerInstance.delegate = self.timerView
        //タイマースタート
        Timer.timerInstance.startTimer(timerCount)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //項目を切り替えたときも描画が行われるのでその制御
    //var timerFlag: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        
//        var timerFinish: String = Timer.timerInstance.count.description
//        if Timer.timerInstance.count == 0 {
//            timerFinish = "Finish!"
//        }
//        self.timerView.setTimerText(timerFinish, timeNum: 1)
        
        // タイマーデリゲートを設定
        Timer.timerInstance.delegate = self.timerView

        self.timerView.setTimerText(Timer.timerInstance.timerCount.description, timeNum: 1)
        
        //現在表示しているセカンドビューの確認
        var secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondTimerViewController") as! SecondTimerViewController
        
        println("willApp")
        println(secondViewController.description)
        
        //グラフを出してたときだけこの処理したい
        if (getScreen.count > 1) {
            if(SecondWindow.secondWindowInstance.secondWindowState != "TimerView"){
            var secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondTimerViewController") as! SecondTimerViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondViewController)
            SecondWindow.secondWindowInstance.setSecondViewState("TimerView")
            println("ShowTimer!")
            }
        }
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self

    }
    
    func numberOfComponentsInPickerView(addPicker: UIPickerView) -> Int {
        return  1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.addPicker){
            return miniList.count
        }else{
            return secList.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView == self.addPicker){
            return miniList[row]
        }else{
            return secList[row]
        }
    }
    
    
    //ピッカーで選択した値をピッカー上のラベルに表示
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if(pickerView == self.addPicker){
            picLabel1.text = miniList[row] + " 分"
            self.mini = miniList[row].toInt()!
        }
        
        else{
            picLabel2.text = secList[row] + " 秒"
            self.sec = secList[row].toInt()!
        }
    }
    
    //一時停止ボタン
    @IBOutlet weak var timeChangeButton: UIButton!
    @IBAction func timePauseButton(sender: UIButton) {
        
        if(flag == 0) {
            println("TimePause!")
            
            //タイマーの減少を0にする
            Timer.timerInstance.timeCountDown = 0
            flag = 1
            self.timeChangeButton.setImage(UIImage(named: "TimePauseButton.png"), forState: UIControlState.Normal)
        }
        
        else {
            println("TimeReSturt!")
            Timer.timerInstance.timeCountDown = 1
            flag = 0
            self.timeChangeButton.setImage(UIImage(named: "TimeResumeButton.png"), forState: UIControlState.Normal)
        }
    }
    
    //Timer時間管理変数
    var timeManagement:Int = 0
    
    //変更ボタン
    @IBAction func timeChangeButton(sender: UIButton) {
        timeManagement = Timer.timerInstance.timerCount
        
        if(timeManagement >= 0 && timeManagement == 0) {
            
            Timer.timerInstance.timeCountDown = 0
            
            //Timerが終了しているときにアラートを出す
            let timeChangeAlert = UIAlertController(title: "タイマーが終了しているため\n時間を変更できません", message: "小テストを終了してください", preferredStyle: .Alert)
            let timeChangeAction = UIAlertAction(title: "OK!", style: .Default, handler: nil)
            timeChangeAlert.addAction(timeChangeAction)
            presentViewController(timeChangeAlert, animated: true, completion: nil)
            
            println("NoMoreTimeChange!")
            println(Timer.timerInstance.timerCount)
        }
        
        else {
            if(flag == 1) {
                //1秒補正
                Timer.timerInstance.timerCount = mini*60 + sec
                println("TimeChange!")
            }
            
            //Timerが停止されてない状態で変更が押されたときにアラートを出す
            else {
                let timeChangeAlert = UIAlertController(title: "タイマーを一時停止させてから\n時間を変更してください", message: "タイマーを一時停止させてください", preferredStyle: .Alert)
                let timeChangeAction = UIAlertAction(title: "OK!", style: .Default, handler: nil)
                timeChangeAlert.addAction(timeChangeAction)
                presentViewController(timeChangeAlert, animated: true, completion: nil)
            }
        }
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}
