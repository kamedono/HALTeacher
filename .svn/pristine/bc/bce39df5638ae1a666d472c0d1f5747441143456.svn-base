//
//  QSentViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/08.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class QSentViewController: UIViewController {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    @IBOutlet weak var sentNummber: UILabel!
    @IBOutlet weak var sentButton: UIButton!
    
    var queNum: Int = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        
        getScreen = UIScreen.screens()
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
        }
        
        //タイマー　0.01秒間隔でカウントUP
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("onUpdate:"), userInfo: nil, repeats: true)
        
        //ボタン押せない
        //sentButton.enabled = false
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var studentCount: Int = CoreCentralManager.coreCentralInstance.connectStudentList.count
    }
    
    override func viewWillAppear(animated: Bool) {
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton
        
    }
    
    
    //0.01秒間隔で1を足していく
    func onUpdate(timer: NSTimer){
        self.queNum += 1
        self.sentNummber.text = self.queNum.description
        if self.queNum >= 30{
            if self.timer.valid{
                sentButton.enabled = true
                self.timer.invalidate()
            }
        }
    }
    
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    //画面遷移　→　コントローラへ
    @IBAction func startButton(sender: AnyObject) {
        
        if getScreen.count > 1 {
            var secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondTimerViewController") as! SecondTimerViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondViewController)
        }
        
        self.performSegueWithIdentifier("sendControl", sender: self)
        //CoreDataの初期化
        var coreDataModule = CoreDataModule()

        //学生データの取得
        let students = CoreCentralManager.coreCentralInstance.connectStudentList.values.array

        //学生テーブルの初期化
        for (var i=0;i<CoreCentralManager.coreCentralInstance.connectStudentList.count;i++){
            coreDataModule.add_Student(students[i].userID, user_name: students[i].name)
            
            //問題テーブルの作成
            for(var j=0; j<QuestionBox.questionBoxInstance.questionID.count; j++){
                coreDataModule.add_question(QuestionBox.questionBoxInstance.questionID[j], user_id: "student[i].userID")
            }
        }
        
        println("musicStart!")
        BGMManager.bgmManagerInstance.playMusic()
        
        
        // 学生にスタートを通知
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.quizStartUUID, sendData: nil)
    }
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
