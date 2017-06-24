//
//  TimerViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/06.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class QuizSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, RightViewControllerDelegate {

    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var musicSelectView: UIView!
    
    // タイマーのViewたち
    @IBOutlet weak var minitePickerView: UIPickerView!
    @IBOutlet weak var miniteLabel: UILabel!
    @IBOutlet weak var secondPickerView: UIPickerView!
    @IBOutlet weak var secondLabel: UILabel!
    
    // BGMのView
    @IBOutlet weak var musicSelectPickerView: UIPickerView!
    
    // 決定ボタン
    @IBOutlet weak var detailButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    // 分の項目
    let minuteNum: [Int] = [0,1,2,3,4,5,6,7,8,9,10,15,20,30,50]
    
    // 秒の項目
    let secondNum: [Int] = [0,5,10,15,30,45]

    // タイマーの設定時間
    var setMinute: Int = 3
    var setSecond: Int = 0
    var setTime: Int = 0
    
    // BGMの設定
    let defaultList: [String] = ["なし", "てってって", "ターミネータ", "レクイエム"]
    var musicList: [String]? {
        get { return defaults.stringArrayForKey("musicList") as? [String] ?? defaultList }
    }
    
    // 選択した曲
    var selectMusic: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TimerのViewに枠を付ける
        self.timerView.backgroundColor = UIColor.clearColor()
        self.timerView.layer.borderColor = UIColor.navigationColor().CGColor
        self.timerView.layer.borderWidth = 5

        minitePickerView.dataSource = self
        minitePickerView.delegate = self
        
        // 初期値設定 Todo
        self.minitePickerView.selectRow(3, inComponent: 0, animated: true)
        self.miniteLabel.text = "3分"
        
        secondPickerView.dataSource = self
        secondPickerView.delegate = self
        
        // BGMのViewに枠を付ける
        self.musicSelectView.backgroundColor = UIColor.clearColor()
        self.musicSelectView.layer.borderColor = UIColor.navigationColor().CGColor
        self.musicSelectView.layer.borderWidth = 5
        
        self.musicSelectPickerView.dataSource = self
        self.musicSelectPickerView.delegate = self
        
        //  BGMのぴっかーの初期設定
        for (index, musicName) in enumerate(defaultList) {
            if musicName == BGMManager.bgmManagerInstance.selectMusic {
                self.musicSelectPickerView.selectRow(index, inComponent: 0, animated: true)
                break
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self

    }
    
    
    //ピッカーの選択行数
    func numberOfComponentsInPickerView(pickerView1: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.minitePickerView){
            return minuteNum.count
        }
        else if pickerView == self.secondPickerView {
            return secondNum.count
        }
        else {
            return self.musicList!.count
        }
    }
    
    //ピッカーの項目初期化
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView == self.minitePickerView){
            return String(minuteNum[row])
        }
        else if pickerView == self.secondPickerView {
            return String(secondNum[row])
        }
        else {
            return self.musicList![row]
        }
    }
    
    //ピッカーの値をピッカー上のラベルに表示する
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == self.minitePickerView) {
            setMinute = minuteNum[row]
            self.miniteLabel.text = String(minuteNum[row]) + " 分"
        }
        else if pickerView == self.secondPickerView {
            setSecond = secondNum[row]
            self.secondLabel.text = String(secondNum[row]) + " 秒"
        }
        else {
            BGMManager.bgmManagerInstance.selectMusic = self.musicList![row]
        }
        // タイマーがゼロだったら
        if self.setSecond + self.setMinute == 0 {
            self.detailButton.enabled = false
        }
        else {
            self.detailButton.enabled = true
        }
    }
    
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    @IBAction func decidedButtonAction(sender: AnyObject) {
        //時間の計算（秒にする）
        setTime = setMinute*60 + setSecond
        println("設定時間:\(setTime)")

        //時間を保存
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(setTime, forKey: "timer")
        userDefaults.synchronize()
        
        //戻ってきた時のために初期化
        setTime = 0
        
        // 学生に選択した問題データを送信
        CoreCentralManager.coreCentralInstance.sendWritingRequest(
            CoreCentralManager.coreCentralInstance.quizSelectQuestionUUID,
            sendData: QuestionBox.questionBoxInstance.questionID)

        self.performSegueWithIdentifier("goCheckViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goCheckViewSegue") {
        }
    }

    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
    
}
