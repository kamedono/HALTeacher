//
//  NominationQuizSettingViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/10/03.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class NominationQuizSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    @IBOutlet weak var musicSelectView: UIView!
    
    // BGMのView
    @IBOutlet weak var musicSelectPickerView: UIPickerView!
    
    // 決定ボタン
    @IBOutlet weak var detailButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // BGMの設定
    let defaultList: [String] = ["なし", "てってって", "ターミネータ", "レクイエム"]
    var musicList: [String]? {
        get { return defaults.stringArrayForKey("musicList") as? [String] ?? defaultList }
    }
    
    // 選択した曲
    var selectMusic: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.musicList!.count
    }
    
    //ピッカーの項目初期化
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.musicList![row]
    }
    
    //ピッカーの値をピッカー上のラベルに表示する
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BGMManager.bgmManagerInstance.selectMusic = self.musicList![row]
    }
    
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    @IBAction func decidedButtonAction(sender: AnyObject) {        
        // 学生に選択した問題データを送信
        CoreCentralManager.coreCentralInstance.sendWritingRequest(
            CoreCentralManager.coreCentralInstance.quizSelectQuestionUUID,
            sendData: QuestionBox.questionBoxInstance.questionID)
        
        self.performSegueWithIdentifier("goNominationStudentCheckViewControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goNominationStudentCheckViewControllerSegue") {
        }
    }

    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
   
}
