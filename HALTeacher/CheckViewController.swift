//
//  CheckViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/07.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController, RightViewControllerDelegate {
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!

    // Viewの宣言
    @IBOutlet weak var questionCountView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var selectMusicView: UIView!
    
    
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var selectMusicLabel: UILabel!

    private var count = 0
    var selectScreen: UIScreen!
    var getScreen: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Viewの設定！
        self.questionCountView.backgroundColor = UIColor.clearColor()
        self.questionCountView.layer.borderColor = UIColor.navigationColor().CGColor
        self.questionCountView.layer.borderWidth = 5
        self.typeView.backgroundColor = UIColor.clearColor()
        self.typeView.layer.borderColor = UIColor.navigationColor().CGColor
        self.typeView.layer.borderWidth = 5
        self.timerView.backgroundColor = UIColor.clearColor()
        self.timerView.layer.borderColor = UIColor.navigationColor().CGColor
        self.timerView.layer.borderWidth = 5
        self.selectMusicView.backgroundColor = UIColor.clearColor()
        self.selectMusicView.layer.borderColor = UIColor.navigationColor().CGColor
        self.selectMusicView.layer.borderWidth = 5

        // 選択した問題数を表示する
        let userDefaults = NSUserDefaults.standardUserDefaults()
        count = userDefaults.integerForKey("questionCount")
        questionCountLabel.text = String(count)

        // 時間制限の取得・表示
        var time = userDefaults.integerForKey("timer")
        minuteLabel.text = String(time/60)
        secondLabel.text = String(time%60)
        
        // 設定したBGMの表示
        self.selectMusicLabel.text = BGMManager.bgmManagerInstance.selectMusic!
        self.selectMusicLabel.adjustsFontSizeToFitWidth = true
        self.selectMusicLabel.lineBreakMode = NSLineBreakMode.ByClipping

        
        // セカンドビューの設定
        getScreen = UIScreen.screens()

        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
        }
    }

    override func viewWillAppear(animated: Bool) {
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }

    // クイズスタートボタン
    @IBAction func quizStartButtonAction(sender: AnyObject) {
        println(QuestionBox.questionBoxInstance.questionID)
        
        self.performSegueWithIdentifier("goTabBarSegue", sender: self)

        if getScreen.count > 1 {
            var secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondTimerViewController") as! SecondTimerViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondViewController)
        }
        
        //CoreDataの初期化
        var coreDataModule = CoreDataModule()
        
        //学生データの取得
        let students = CoreCentralManager.coreCentralInstance.connectStudentList.values.array
        
        //学生テーブルの初期化
        for (var i=0;i<CoreCentralManager.coreCentralInstance.connectStudentList.count;i++){
            coreDataModule.add_Student(students[i].userID, user_name: students[i].name)
            
            //問題テーブルの作成
            for(var j=0; j<QuestionBox.questionBoxInstance.questionID.count; j++){
                coreDataModule.add_question(QuestionBox.questionBoxInstance.questionID[j], user_id: students[i].userID)
            }
        }
        
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.quizStartUUID, sendData: nil)
        
        println("musicStart!")
        BGMManager.bgmManagerInstance.playMusic()

    }


    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}
