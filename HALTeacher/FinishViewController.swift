//
//  FinishTimerViewController.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/12.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController, RightViewControllerDelegate, FinishViewsTimerDelegate {
    
    @IBOutlet weak var timerView: TimerView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    // 終了するリスト
    enum FinishList {
        case timer
        case content
    }
    
    @IBAction func timerFinishButton(sender: UIButton) {
        self.createMoodleAccessAlertView("タイマー", finish: .timer)
    }
    
    @IBAction func testFinishButton(sender: UIButton) {
        self.createMoodleAccessAlertView("小テスト", finish: .content)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Timer.timerInstance.timerCount > 0 {
            self.finishButton.enabled = false
        }
        else {
            self.finishButton.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
//        var timerFinish: String = Timer.timerInstance.count.description
//        if Timer.timerInstance.count == 0 {
//            timerFinish = "Finish!"
//        }
//        self.timerView.setTimerText(timerFinish, timeNum: 1)
        
        if Timer.timerInstance.timerCount == 0 {
            self.finish()
        }

        
        Timer.timerInstance.delegate = self.timerView
        Timer.timerInstance.finishDelegate = self
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
        
    }
    
    /**
    確認alertの表示
    */
    func createMoodleAccessAlertView(title: String, finish: FinishList) {
        dispatch_async(dispatch_get_main_queue(), {
            // AlertController作成
            var checkAlertView = UIAlertController(title: title + "を終了します", message: "よろしいですか？", preferredStyle: .Alert)
            
            // OKボタンを押した時
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                switch(finish) {
                    // タイマーを終了する処理
                case .timer:
                    self.timerFinish()
                    
                    // 小テストを終了する処理
                case .content:
                    //MoodleViewを見せる
                    self.importMoodleAlertView()
                }
            }
            
            // Cancelボタンを押した時
            var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            // AlertControllerにActionを追加させる
            checkAlertView.addAction(okAction)
            checkAlertView.addAction(cancelAction)
            
            //Viewを見せる
            self.presentViewController(checkAlertView, animated: true, completion: nil)
        })
    }
    
    /**
    Moodle成績登録のAlertView
    */
    func importMoodleAlertView(){
        dispatch_async(dispatch_get_main_queue(), {
            // AlertController作成
            var checkAlertView = UIAlertController(title: "Moodle成績登録", message: "小テストの結果を\nMoodleに登録しますか?", preferredStyle: .Alert)
            
            // OKボタンを押した時
            var okAction = UIAlertAction(title: "登録", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                var importMoodleScore = ImportMoodleScore()
                var token = MoodleInfo.moodleInfoInstance.tokenID
                
                for(var i=0; i<StudentInfoBox.studentInfoBoxInstance.studentList.count; i++){
                    //学生の情報
                    let studentInfo = StudentInfoBox.studentInfoBoxInstance.studentList[i]
                    //コースのID
                    let courseID = MoodleInfo.moodleInfoInstance.selectCource.courceNumber.toInt()
                    //点数
                    var score = 0
                    if QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentInfo.UUID!] != nil {
                        score = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentInfo.UUID!]!.getScore()
                    }
                    println("得点\(score)")
                    //小テストの名前
                    let quizName = QuestionBox.questionBoxInstance.questionTitle
                    println("名前\(quizName)")
                    //成績登録の実行
                    importMoodleScore.uploadQuizScore(token, courseID: courseID!, studentID: studentInfo.number.toInt()!, quizName: quizName, grade: score)
                }
                println("成績登録完了")
                self.contentFinish()
            }
            
            // Cancelボタンを押した時
            var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.contentFinish()
            }
            // AlertControllerにActionを追加させる
            checkAlertView.addAction(okAction)
            checkAlertView.addAction(cancelAction)
            
            //Viewを見せる
            self.presentViewController(checkAlertView, animated: true, completion: nil)
        })
    }
    
    /**
    タイマーの終了処理
    */
    func timerFinish() {
        Timer.timerInstance.timerCount = 0
        Timer.timerInstance.stopTimer()
        Timer.timerInstance.stopIvent()
        self.finishButton.enabled = true
    }
    
    /**
    小テストの終了処理
    */
    func contentFinish() {
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.quizFinishUUID, sendData: "Exit")
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
        BGMManager.bgmManagerInstance.stopMusic()
        
        self.finishButton.enabled = true
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
    
    /**
    タイマー終了時のココ専用のデリゲート
    */
    func finish() {
        self.finishButton.enabled = true
    }

}