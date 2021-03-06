//
//  StudentCheckViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/08/30.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class NominationStudentCheckViewController: UIViewController, RightViewControllerDelegate {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    @IBOutlet weak var questionCountView: UIView!
    @IBOutlet weak var answerCountView: UIView!
    @IBOutlet weak var selectMusicView: UIView!
    
    // 選択した学生数のラベル
    @IBOutlet weak var selectStudentCountLabel: UILabel!
    
    // 選択した音楽のラベル
    @IBOutlet weak var selectMusicLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionCountView.backgroundColor = UIColor.clearColor()
        self.questionCountView.layer.borderColor = UIColor.navigationColor().CGColor
        self.questionCountView.layer.borderWidth = 5
        self.answerCountView.backgroundColor = UIColor.clearColor()
        self.answerCountView.layer.borderColor = UIColor.navigationColor().CGColor
        self.answerCountView.layer.borderWidth = 5
        self.selectMusicView.backgroundColor = UIColor.clearColor()
        self.selectMusicView.layer.borderColor = UIColor.navigationColor().CGColor
        self.selectMusicView.layer.borderWidth = 5
        
        // 選択した学生数の表示
        self.selectStudentCountLabel.text = StudentInfoBox.studentInfoBoxInstance.selectStudentList.count.description
        
        // 設定したBGMの表示
        self.selectMusicLabel.text = BGMManager.bgmManagerInstance.selectMusic!
        self.selectMusicLabel.adjustsFontSizeToFitWidth = true
        self.selectMusicLabel.lineBreakMode = NSLineBreakMode.ByClipping
        
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
    
    /**
    制御ボタン
    */
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    /**
    スタートボタン
    */
    @IBAction func quizStartButtonAction(sender: AnyObject) {
        //        CoreCentralManager.coreCentralInstance.sendWritingRequest(
        //            CoreCentralManager.coreCentralInstance.quizSelectQuestionUUID,
        //            sendData: QuestionBox.questionBoxInstance.questionID)
        var studentUUIDList: [NSUUID] = []
        for studentInfo in StudentInfoBox.studentInfoBoxInstance.selectStudentList {
            studentUUIDList.append(studentInfo.UUID!)
        }
        
        // 学生に選択した問題データを送信
        CoreCentralManager.coreCentralInstance.sendWritingRequest(
            CoreCentralManager.coreCentralInstance.quizStartUUID,
            sendData: nil,
            studentUUIDList: studentUUIDList)
        
        BGMManager.bgmManagerInstance.playMusic()
        
        self.performSegueWithIdentifier("goNominationTabBarControllerSegue", sender: self)
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}

