//
//  File.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class ClickerTypeSelectViewController: UIViewController, TeacherMoodleAccessDelegate, RightViewControllerDelegate, CoreCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var freeClickerView: UIView!

    @IBOutlet weak var moodleClickerView: UIView!
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    //indicator宣言
    var indicator :UIActivityIndicatorView!
    
    //ダウンロード中のalertView
    var downloadingAlertView :UIAlertController!
    
    var teacherMoodleAccess: TeacherMoodleAccess!

    var clickerCount = 0
    
    var delegateCount = 0

    var typeBox :[String] = ["2", "3", "4", "5", "moodle"]

    var selectType = ""
    
    // バーをタッチした時の学生リストテーブル
    var settingTableView: UITableView!

    // テーブルの中身
    let buttonList = ["a ~ h", "あ ~ か", "① ~ ⑧"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //生成
        self.settingTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width/4, self.view.frame.height))
        
        //スタート位置にtableviewをセット
        self.settingTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)
        
        // Xibでの宣言
        var nib = UINib(nibName: "ClickerStudentTableViewCell", bundle: nil)
        
        // Cell名の登録をおこなう.
        self.settingTableView.registerNib(nib, forCellReuseIdentifier: "StudentCell")
        
        // DataSourceの設定をする.
        self.settingTableView.dataSource = self
        
        // Delegateを設定する.
        self.settingTableView.delegate = self
        
        self.view.addSubview(self.settingTableView)

        
        // 枠の作成
        self.freeClickerView.backgroundColor = UIColor.clearColor()
        self.freeClickerView.layer.borderColor = UIColor.navigationColor().CGColor
        self.freeClickerView.layer.borderWidth = 5

        self.moodleClickerView.backgroundColor = UIColor.clearColor()
        self.moodleClickerView.layer.borderColor = UIColor.navigationColor().CGColor
        self.moodleClickerView.layer.borderWidth = 5

        self.teacherMoodleAccess = TeacherMoodleAccess()
        self.teacherMoodleAccess.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
 
    }
    
    override func viewWillAppear(animated: Bool) {
        ClickerInfo.clickerInfoInstance.setEmpty()
        
        CoreCentralManager.coreCentralInstance.delegate = self
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    セグエ移動の値渡し
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goClickerBarGraphViewControllerSegue") {
            let clickerBarGraphViewController : ClickerBarGraphViewController = segue.destinationViewController as!  ClickerBarGraphViewController
            clickerBarGraphViewController.questionType = selectType
        }
    }
    
    
    /**
    選択したtypeのクリッカーを始めるためのアラート
    */
    func createAlertView(title:String, message:String){
        //AlertController作成
        var moodleLoginAlertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //アクセスボタンを押した時
        var accessAction = UIAlertAction(title: "始める", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //アクセス成功した時
            // 学生にクリッカー開始を通知
            ClickerInfo.clickerInfoInstance.setEmpty()
            ClickerInfo.clickerInfoInstance.answerNumber = self.selectType.toInt()
            CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.freeClickerUUID, sendData: ClickerInfo.clickerInfoInstance.answerNumber?.description)
            
            self.performSegueWithIdentifier("goClickerBarGraphViewControllerSegue", sender: nil)
        }
        
        //キャンセルボタンを押した時
        var chancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        // Add the actions
        moodleLoginAlertView.addAction(accessAction)
        moodleLoginAlertView.addAction(chancelAction)
        self.presentViewController(moodleLoginAlertView, animated: true, completion: nil)
    }
    

    /**
    ダウンロードしますか画面の作成
    */
    func showDownloadAlertView() {
        //indicatorの初期化
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        var alertView = UIAlertController(title: "クリッカー情報のダウンロードを行います", message:"ダウンロードしますか？", preferredStyle: .Alert)
        
        var okAction = UIAlertAction(title: "ダウンロード", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            // ログイン処理
            self.teacherMoodleAccess.moodleLogin(UserInfo.userInfoInstance.userID!, password: UserInfo.userInfoInstance.password!)
            
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
    
    
    @IBAction func pushTwoSelect(sender: AnyObject) {
        selectType = typeBox[0]
        ClickerInfo.clickerInfoInstance.answerNumber = 2
        self.createAlertView("2択問題を選択しました",message: "始めますか？")
    }
    
    @IBAction func pushThreeSelect(sender: AnyObject) {
        selectType = typeBox[1]
        ClickerInfo.clickerInfoInstance.answerNumber = 3
        self.createAlertView("3択問題を選択しました",message: "始めますか？")
    }
    
    @IBAction func pushFourSelect(sender: AnyObject) {
        selectType = typeBox[2]
        ClickerInfo.clickerInfoInstance.answerNumber = 4
        self.createAlertView("4択問題を選択しました",message: "始めますか？")
    }
    
    @IBAction func pushFiveSelect(sender: AnyObject) {
        selectType = typeBox[3]
        ClickerInfo.clickerInfoInstance.answerNumber = 5
        self.createAlertView("5択問題を選択しました",message: "始めますか？")
    }
    
    @IBAction func pushMoodleQuestion(sender: AnyObject) {
        selectType = typeBox[4]
        self.showDownloadAlertView()
        
    }
    
    @IBAction func settingButtonAction(sender: AnyObject) {
        // アニメーション！
        UIView.animateWithDuration(
            0.5,
            animations: {() -> Void in
                self.settingTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width-self.view.frame.width/4, 60)},
            completion: {(Bool) -> Void in
                println("addView")
        })
    }
    
    /**
    画面のどこかを触った時
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        UIView.animateWithDuration(0.2,
            animations: {() -> Void in
                self.settingTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)},
            completion: {(Bool) -> Void in
                println("DeleteView!")
        })
        
    }
    
    /**
    tableViewのヘッダー高さ
    */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    /**
    tableViewのヘッダー設定
    */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 時間がないのでClickerStudentTableViewCellを使います。ごめん。
        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as! ClickerStudentTableViewCell
        cell.studentName.text = "クリッカーの選択肢"
        cell.studentName.font = UIFont.systemFontOfSize(CGFloat(15))
        cell.backgroundColor = UIColor.hexStr("#D0D0D0", alpha: 1)
        return cell
    }
    
    /**
    cellの数
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buttonList.count
    }
    
    /**
    cellに値を格納
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! ClickerStudentTableViewCell
        cell.studentName.text = self.buttonList[indexPath.row]
        return cell
    }
    
    /**
    cellを押したとき
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MoodleInfo.moodleInfoInstance.selectButton = indexPath.row
    }
    
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }

    
    // ----Delegate宣言----
    
    
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
        let selectCource = MoodleInfo.moodleInfoInstance.selectCource
        if result {
            MoodleInfo.moodleInfoInstance.selectCource.clickerContentList = []
            for clickerContent in selectCource.clickerContentList {
                // Moodleからクリッカー情報を取得
                self.teacherMoodleAccess.getClickerDB(selectCource.courceNumber.toInt()!, url: clickerContent.clickerDBURL)
                self.clickerCount++
            }
        }
        else {
            self.downloadingAlertView.dismissViewControllerAnimated(true, completion: nil)
            self.failedAlert()
        }
    }
    
    /**
    クリッカー情報取得後
    */
    func getedClickerInfo() {
        self.delegateCount++
        if self.clickerCount == self.delegateCount {
            self.downloadingAlertView.dismissViewControllerAnimated(true, completion: nil)
            // ログアウト処理
            self.teacherMoodleAccess.logout()
            self.performSegueWithIdentifier("goSelectMoodleQuestionSegue", sender: nil)

        }
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}

