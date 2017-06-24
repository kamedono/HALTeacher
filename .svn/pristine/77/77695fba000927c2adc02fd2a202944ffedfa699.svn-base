//
//  QuizCourceTableViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/08/07.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class QuestionCourceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XmlModuleDelegate, TeacherMoodleAccessDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    //indicator宣言
    var indicator :UIActivityIndicatorView!
    
    //ダウンロード中のalertView
    var downloadingAlertView :UIAlertController!
    
    // 選択したセルの番号
    var selectIndexPath: Int = 0
    
    var xmlModule: XmlModule!
    
    var teacherMoodleAccess: TeacherMoodleAccess!
    
    @IBOutlet weak var courceTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teacherMoodleAccess = TeacherMoodleAccess()
        self.teacherMoodleAccess.delegate = self
        
        self.courceTable.dataSource = self
        self.courceTable.delegate = self
        
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoodleInfo.moodleInfoInstance.selectCource.quizInfoList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: QuestionCourceCell = tableView.dequeueReusableCellWithIdentifier("QuestionCourceCell", forIndexPath: indexPath) as! QuestionCourceCell
        cell.setCourceText(MoodleInfo.moodleInfoInstance.selectCource.quizInfoList[indexPath.row].quizName)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectIndexPath = indexPath.row
        QuestionBox.questionBoxInstance.questionTitle = MoodleInfo.moodleInfoInstance.selectCource.quizInfoList[indexPath.row].quizName
        // アラートビューを表示させる（一瞬で画面移動するから来れなくていいかも）
        showAlertView(indexPath.row)
    }
    
    
    
    /**
    ダウンロードしますか画面の作成
    */
    func showAlertView(indexPath :Int) {
        //indicatorの初期化
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        var alertView = UIAlertController(title: "\"\(MoodleInfo.moodleInfoInstance.selectCource.quizInfoList[indexPath].quizName)\"のダウンロードを\n行います", message:"ダウンロードしますか？", preferredStyle: .Alert)
        
        var okAction = UIAlertAction(title: "ダウンロード", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            // ログイン処理
            self.teacherMoodleAccess.moodleLogin(UserInfo.userInfoInstance.userID!, password: UserInfo.userInfoInstance.password!)
            
            //前のalertviewの削除（意味ないかも）
            alertView.dismissViewControllerAnimated(true, completion: nil)
            //AlertController作成
            self.downloadingAlertView = UIAlertController(title: "ダウンロード中", message: "\n\n", preferredStyle: .Alert)
            //indicatorの位置決め
            self.indicator.center = CGPointMake(alertView.view.frame.size.width/2 ,self.downloadingAlertView.view.frame.size.height/10)
            
            //indicatorを回す
            self.indicator.startAnimating()
            
            //AlertControllerにindicatorを追加させる
            self.downloadingAlertView.view.addSubview(self.indicator)
            
            //Viewを見せる
            self.presentViewController(self.downloadingAlertView, animated: true, completion: nil)
        }
        
        var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        // Add the actions
        alertView.addAction(okAction)
        alertView.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    

    /**
    失敗時のアラート
    */
    func failedAlert() {
        //AlertController作成
        var moodleAccessAlertView = UIAlertController(title: "ダウンロードに失敗しました。", message: "再度試してください。", preferredStyle: .Alert)
        
        //OKボタンを押した時
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        // Add the actions
        moodleAccessAlertView.addAction(okAction)
        
        //Viewを見せる
        self.presentViewController(moodleAccessAlertView, animated: true, completion: nil)
        
    }
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    
    
    // ----Delegate宣言----
    
    /**
    XMLのパースが終了した時のデリゲート
    */
    func finishRead() {
        //一つのキューに処理をまとめて書かないとダメっぽい
        dispatch_async(dispatch_get_main_queue(), {
            self.downloadingAlertView.dismissViewControllerAnimated(true, completion: {
                self.performSegueWithIdentifier("goSelectQuestionTableSegue", sender: self)
            })
        })
        let qs = QuestionBox.questionBoxInstance.questions
        
        CoreCentralManager.coreCentralInstance.sendWritingRequest(
            CoreCentralManager.coreCentralInstance.quizReadyUUID,
            sendData: MoodleInfo.moodleInfoInstance.moodleURL + MoodleInfo.moodleInfoInstance.selectCource.quizInfoList[self.selectIndexPath].quizURL)
        self.xmlModule = nil
        
        // ログアウト処理
        self.teacherMoodleAccess.logout()
    }
    
    /**
    ダウンロードを失敗した時のデリゲート
    */
    func downloadFailed() {
        self.downloadingAlertView.dismissViewControllerAnimated(true, completion: nil)
        self.failedAlert()
        
    }
    
    /**
    ログインした時の結果を返すデリゲート
    */
    func loginResult(result: Bool){
        if result {
            // インスタンス化
            self.xmlModule = XmlModule()
            // デリゲート宣言
            self.xmlModule.delegate = self
            //ダウンロード・パース処理
            self.xmlModule.createQuestion(MoodleInfo.moodleInfoInstance.moodleURL + MoodleInfo.moodleInfoInstance.selectCource.quizInfoList[self.selectIndexPath].quizURL)
        }
        else {
            self.downloadingAlertView.dismissViewControllerAnimated(true, completion: nil)
            self.failedAlert()
        }
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}
