//
//  File.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit


class ClickerBarGraphViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoreCentralManagerDelegate, DrawClickerBarGraphViewDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    //解答を送った学生人数
    @IBOutlet weak var selectedStudentLabel: UILabel!
    
    //クリッカーを受講している学生の人数
    @IBOutlet weak var totalStudentLabel: UILabel!
    
    // 結果表示のボタン
    @IBOutlet weak var resultViewButton: UIButton!
    
    // 結果非表示のボタン
    @IBOutlet weak var resultHiddenButton: UIButton!
    
    // クリッカー終了のボタン
    @IBOutlet weak var finishClickerButton: UIButton!
    
    // 受付終了ボタン
    @IBOutlet weak var finishClickerAcceptanceButton: UIButton!

    //Clickerのタイプ
    var questionType = ""
    //UIボタンの宣言
    var selectButton: UIButton!
    //各選択肢ラベル
    var markLabel: UILabel!
    //各選択肢ラベル
    var countLabel: UILabel!
    //四角の数
    var questionCount :Int!
    
    //ボタンのテキスト
    var buttonText :[String] = MoodleInfo.moodleInfoInstance.buttonText[MoodleInfo.moodleInfoInstance.selectButton]
    
    var screenWidth :CGFloat!
    var screenHeight :CGFloat!
    
    var drawClickerBarGraphView: DrawClickerBarGraphView!
    
    //選択肢のラベルの初期位置
    var selectLabelControl: Int!
    
    //選択肢のラベルの初期位置の調節用
    var selectLabelControlPlus: Int!
    
    var countLabelControl: Int!
    
    var countLabelControlPlus: Int!
    
    //デバッグ用ボタンの位置
    var buttonViewSet: Int!
    var buttonViewSetPlus: Int!
    
    // 画面サイズを取得 Windowの表示領域すべてのサイズ(point).
    let deviceBound : CGRect = UIScreen.mainScreen().bounds
    
    // バーをタッチした時の学生リストテーブル
    var studentListTableView: UITableView!
    
    // tableViewのCell数
    var studentNameList: [String] = []
    
    var selectMarkNumber = 0
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 戻る禁止
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //問題数格納
        questionCount = self.questionType.toInt()
        
        // 学生数
        self.totalStudentLabel.text = StudentInfoBox.studentInfoBoxInstance.studentList.count.description
        
        // 学生が解答した数（初期値なので０）
        self.selectedStudentLabel.text = ClickerInfo.clickerInfoInstance.studentAnswerList.count.description
        
        // クリッカー終了ボタンを隠す
        self.finishClickerButton.hidden = true
        
        self.resultHiddenButton.hidden = true
        
        // グラフ情報初期化
        let buttonTapCount = [Int](count: questionCount, repeatedValue: 0)
        ClickerInfo.clickerInfoInstance.buttonTapCount = buttonTapCount
        
        println("選んだ問題\(questionType)")
        
        drawClickerBarGraphView  = DrawClickerBarGraphView()
        
        //Viewの長さ・高さ
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        
        //ラベルの設定
        selectedStudentLabel.text = "0"
        //        totalStudentLabel.text = StudentBox.studentBoxInstanse.studentBox.count.description
        
        
        //選択肢の数によってボタンの位置を変える
        switch questionCount {
        case 2:
            selectLabelControl = 310
            selectLabelControlPlus = 355
            countLabelControl = 350
            countLabelControlPlus = 355
            buttonViewSet = 330
            buttonViewSetPlus = 355
            
        case 3:
            selectLabelControl = 250
            selectLabelControlPlus = 245
            countLabelControl = 285
            countLabelControlPlus = 245
            buttonViewSet = 260
            buttonViewSetPlus = 245
            
        case 4:
            selectLabelControl = 200
            selectLabelControlPlus = 197
            countLabelControl = 235
            countLabelControlPlus = 197
            buttonViewSet = 210
            buttonViewSetPlus = 197
            
        case 5:
            selectLabelControl = 160
            selectLabelControlPlus = 170
            countLabelControl = 195
            countLabelControlPlus = 170
            buttonViewSet = 175
            buttonViewSetPlus = 170
            
        case 6:
            selectLabelControl = 138
            selectLabelControlPlus = 145
            countLabelControl = 168
            countLabelControlPlus = 145
            buttonViewSet = 150
            buttonViewSetPlus = 150
            
        case 7:
            selectLabelControl = 108
            selectLabelControlPlus = 130
            countLabelControl = 138
            countLabelControlPlus = 130
            buttonViewSet = 120
            buttonViewSetPlus = 130
            
        case 8:
            selectLabelControl = 98
            selectLabelControlPlus = 115
            countLabelControl = 134
            countLabelControlPlus = 115
            buttonViewSet = 110
            buttonViewSetPlus = 115
            
            
        default:
            break
        }
        
        
        for (var i=0; i<questionCount; i++){
            //生成
            self.studentListTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width/4, self.view.frame.height))
            
            //スタート位置にtableviewをセット
            self.studentListTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)
            
            // Xibでの宣言
            var nib = UINib(nibName: "ClickerStudentTableViewCell", bundle: nil)
            
            // Cell名の登録をおこなう.
            self.studentListTableView.registerNib(nib, forCellReuseIdentifier: "StudentCell")
            
            // DataSourceの設定をする.
            self.studentListTableView.dataSource = self
            
            // Delegateを設定する.
            self.studentListTableView.delegate = self
            
            self.view.addSubview(self.studentListTableView)
            
            
            //各選択肢のラベル作成
            markLabel = UILabel()
            markLabel.frame = CGRectMake(0,0,50,40)
            
            markLabel.layer.position = CGPoint(x: selectLabelControl+(i*selectLabelControlPlus), y: 700)
            
            markLabel.text = buttonText[i]
            markLabel.font = UIFont.systemFontOfSize(30)
            //            markLabel.tag = i+10
            
            
            //選択した数
            countLabel = UILabel()
            countLabel.frame = CGRectMake(0, 0, 50, 40)
            
            countLabel.layer.position = CGPoint(x: countLabelControl+(i*countLabelControlPlus), y: 700)
            countLabel.text = ClickerInfo.clickerInfoInstance.buttonTapCount[i].description
            countLabel.text = "0"
            countLabel.font = UIFont.systemFontOfSize(30)
            countLabel.tag = i+100
            
            self.view.addSubview(countLabel)
            self.view.addSubview(markLabel)
            
            // セカンドスクリーンについて
            getScreen = UIScreen.screens()
            
            // 接続中の画面が2つある場合、2番目を表示.
            if getScreen.count > 1 {
                selectScreen = UIScreen.screens()[1] as! UIScreen
                
                var secondClickerBarGraphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("secondClickerBarGraphView") as! SecondClickerBarGraphViewController
                secondClickerBarGraphViewController.questionCount = self.questionCount
                secondClickerBarGraphViewController.viewFlag = false
                SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondClickerBarGraphViewController)
                
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreCentralManager.coreCentralInstance.delegate = self
        self.drawClickerBarGraphView.delegate = self
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    /**
    tableViewに表示する学生の名前リストを作成
    */
    func setStudentName() {
        self.studentNameList = []
        
        let studentName = ClickerInfo.clickerInfoInstance.studentAnswerList.keys.array
        
        let selectMarkList = ClickerInfo.clickerInfoInstance.studentAnswerList.values.array
        
        for (index, selectMark) in enumerate(selectMarkList) {
            if selectMark == getMark(self.selectMarkNumber) {
                self.studentNameList.append(studentName[index])
            }
        }
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
        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as! ClickerStudentTableViewCell
        cell.studentName.text = "名前"
        cell.backgroundColor = UIColor.hexStr("#D0D0D0", alpha: 1)
        return cell
    }
    
    /**
    cellの数
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentNameList.count
    }
    
    /**
    cellに値を格納
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! ClickerStudentTableViewCell
        cell.studentName.text = self.studentNameList[indexPath.row]
        return cell
    }
    
    
    /**
    画面のどこかを触った時
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        UIView.animateWithDuration(0.2,
            animations: {() -> Void in
                self.studentListTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)},
            completion: {(Bool) -> Void in
                println("DeleteView!")
        })
        
    }
    
    /**
    結果表示のボタンを押した時の動作
    */
    @IBAction func resultViewButtonAction(sender: AnyObject) {
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
            
            var secondClickerBarGraphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("secondClickerBarGraphView") as! SecondClickerBarGraphViewController
            secondClickerBarGraphViewController.questionCount = self.questionCount
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondClickerBarGraphViewController)
            
        }
        // ボタンを入れ替え
        self.resultViewButton.hidden = true
        self.resultHiddenButton.hidden = false
    }
    
    /**
    結果非表示のボタンを押した時の動作
    */
    @IBAction func resultHiddenButtonAction(sender: AnyObject) {
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
            
            var secondClickerBarGraphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("secondClickerBarGraphView") as! SecondClickerBarGraphViewController
            secondClickerBarGraphViewController.questionCount = self.questionCount
            secondClickerBarGraphViewController.viewFlag = false
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondClickerBarGraphViewController)
            
        }
        // ボタンを入れ替え
        self.resultViewButton.hidden = false
        self.resultHiddenButton.hidden = true
    }
    
    /**
    受付終了のボタンを押した時にの動作
    */
    @IBAction func finishClickerAcceptanceButtonAction(sender: AnyObject) {
        ClickerInfo.clickerInfoInstance.status = "stop"
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.clickerStatusUUID, sendData: ClickerInfo.clickerInfoInstance.status)
        
        self.finishClickerButton.hidden = false
        self.finishClickerAcceptanceButton.hidden = true
        
    }
    
    @IBAction func finishClickerButtonAction(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            // AlertController作成
            var checkAlertView = UIAlertController(title: "クリッカーを終了します", message: "よろしいですか？", preferredStyle: .Alert)
            
            // OKボタンを押した時
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                ClickerInfo.clickerInfoInstance.status = "finish"
                CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.clickerStatusUUID, sendData: ClickerInfo.clickerInfoInstance.status)
                // トップに戻る
                self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
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
    
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    
    
    // ----Delegate宣言----
    
    /**
    学生からの解答
    */
    func clickerNotification(userID: String, beforMark: String?) {
        var afterMark = ClickerInfo.clickerInfoInstance.studentAnswerList[userID]!
        ClickerInfo.clickerInfoInstance.buttonTapCount[getMarkNumber(afterMark)]++
        
        if beforMark != nil {
            ClickerInfo.clickerInfoInstance.buttonTapCount[getMarkNumber(beforMark!)]--
        }
        
        //ビューの削除
        var removeView = self.view.viewWithTag(1000)
        //消すべきビューがあった場合
        if((removeView) != nil){
            removeView!.removeFromSuperview()
        }
        
        //棒グラフのビュー作成
        var buttonView = DrawClickerBarGraphView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        //選択したボタンのカウント情報を取得
        var markCount = drawClickerBarGraphView.getMarkCount(getMarkNumber(afterMark))
        
        buttonView.transform = CGAffineTransformMakeScale(1, 0.6)
        buttonView.layer.position.y = buttonView.bounds.height/2 + 70
        buttonView.tag = 1000
        buttonView.backgroundColor = UIColor.whiteColor()
        
        buttonView.delegate = self
        self.view.addSubview(buttonView)
        
        // ラベルの値変更
        for var i=0; i < ClickerInfo.clickerInfoInstance.buttonTapCount.count; i++ {
            let selectLabel = self.view.viewWithTag(i+100) as! UILabel
            selectLabel.text = ClickerInfo.clickerInfoInstance.buttonTapCount[i].description
        }
        
        // 値を設定
        self.setStudentName()
        
        // カウントラベルをセット
        self.selectedStudentLabel.text = ClickerInfo.clickerInfoInstance.studentAnswerList.count.description
        
        // 最前面
        self.view.bringSubviewToFront(self.studentListTableView)
        self.studentListTableView.reloadData()
    }
    
    /**
    viewをタッチした時
    */
    func pushBarGraph(markNumber: Int) {
        var count = 0
        
        // 選択した情報保存
        self.selectMarkNumber = markNumber
        
        // 値を設定
        self.setStudentName()
        
        
        self.studentListTableView.reloadData()
        
        // アニメーション！
        UIView.animateWithDuration(
            0.5,
            animations: {() -> Void in
                self.studentListTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width-self.view.frame.width/4, 60)},
            completion: {(Bool) -> Void in
                println("addView")
        })
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}

