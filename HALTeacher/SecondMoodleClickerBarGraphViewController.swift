//
//  SecondMoodleClickerBarGraphViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/10/07.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

//UITableViewDataSource, UITableViewDelegate
class SecondMoodleClickerBarGraphViewController: UIViewController, SecondViewCoreCentralManagerDelegate, DrawClickerBarGraphViewDelegate {
    
    // 解答を送った学生人数
    @IBOutlet weak var selectedStudentLabel: UILabel!
    
    // クリッカーを受講している学生の人数
    @IBOutlet weak var totalStudentLabel: UILabel!
    
    // クリッカーの問題文
    @IBOutlet weak var questionText: UILabel!
    
    // はてなラベル
    @IBOutlet weak var hatenaLabel: UILabel!
    
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
    //    var studentListTableView: UITableView!
    
    // tableViewのCell数
    var studentNameList: [String] = []
    
    var selectMarkNumber = 0
    
    // クリッカーの情報
    let clickerSubject = ClickerInfo.clickerInfoInstance.clickerSubject
    
    var viewFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // クリッカーのタイトル
        self.questionText.text = ClickerInfo.clickerInfoInstance.clickerSubject?.title
        
        // フォントの自動調節
        self.questionText.adjustsFontSizeToFitWidth = true
        self.questionText.lineBreakMode = NSLineBreakMode.ByClipping
        
        // 学生数
        self.totalStudentLabel.text = StudentInfoBox.studentInfoBoxInstance.studentList.count.description
        
        // 学生が解答した数（初期値なので０）
        self.selectedStudentLabel.text = ClickerInfo.clickerInfoInstance.studentAnswerList.count.description
        
        // 背景透明化
//        self.graphView.backgroundColor = UIColor.clearColor()
        
        
        //問題数格納
        var questionCount = self.clickerSubject!.answerList.count
        
        // グラフ情報初期化
        let buttonTapCount = [Int](count: questionCount, repeatedValue: 0)
        //        ClickerInfo.clickerInfoInstance.buttonTapCount = buttonTapCount
    
        //Viewの長さ・高さ
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        
        drawClickerBarGraphView  = DrawClickerBarGraphView(frame: CGRectMake(0, 0, screenWidth, screenHeight))

        //選択肢の数によってボタンの位置を変える
        switch questionCount {
        case 2:
            selectLabelControl = 325
            selectLabelControlPlus = 355
            countLabelControl = 350
            countLabelControlPlus = 355
            buttonViewSet = 330
            buttonViewSetPlus = 355
            
        case 3:
            selectLabelControl = 265
            selectLabelControlPlus = 245
            countLabelControl = 285
            countLabelControlPlus = 245
            buttonViewSet = 260
            buttonViewSetPlus = 245
            
        case 4:
            selectLabelControl = 215
            selectLabelControlPlus = 197
            countLabelControl = 235
            countLabelControlPlus = 197
            buttonViewSet = 210
            buttonViewSetPlus = 197
            
        case 5:
            selectLabelControl = 175
            selectLabelControlPlus = 170
            countLabelControl = 195
            countLabelControlPlus = 170
            buttonViewSet = 175
            buttonViewSetPlus = 170
            
        case 6:
            selectLabelControl = 148
            selectLabelControlPlus = 145
            countLabelControl = 168
            countLabelControlPlus = 145
            buttonViewSet = 150
            buttonViewSetPlus = 150
            
        case 7:
            selectLabelControl = 118
            selectLabelControlPlus = 130
            countLabelControl = 138
            countLabelControlPlus = 130
            buttonViewSet = 120
            buttonViewSetPlus = 130
            
        case 8:
            selectLabelControl = 108
            selectLabelControlPlus = 115
            countLabelControl = 134
            countLabelControlPlus = 115
            buttonViewSet = 110
            buttonViewSetPlus = 115
            
            
        default:
            break
        }
        
        
        for (var i=0; i<questionCount; i++){
            //            //生成
            //            self.studentListTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width/4, self.view.frame.height))
            //
            //            //スタート位置にtableviewをセット
            //            self.studentListTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)
            //
            //            // Xibでの宣言
            //            var nib = UINib(nibName: "ClickerStudentTableViewCell", bundle: nil)
            //
            //            // Cell名の登録をおこなう.
            //            self.studentListTableView.registerNib(nib, forCellReuseIdentifier: "StudentCell")
            //
            //            // DataSourceの設定をする.
            //            self.studentListTableView.dataSource = self
            //
            //            // Delegateを設定する.
            //            self.studentListTableView.delegate = self
            //
            //            self.view.addSubview(self.studentListTableView)
            
            
            //各選択肢のラベル作成
            markLabel = UILabel()
            markLabel.frame = CGRectMake(0,0,50,40)
            
            markLabel.layer.position = CGPoint(x: selectLabelControl+(i*selectLabelControlPlus), y: 700)
            
            markLabel.text = buttonText[i]
            markLabel.font = UIFont.systemFontOfSize(30)
            
            
            //選択した数
            countLabel = UILabel()
            countLabel.frame = CGRectMake(0, 0, 50, 40)
            
            countLabel.layer.position = CGPoint(x: countLabelControl+(i*countLabelControlPlus), y: 700)
            
            if viewFlag {
                countLabel.text = ClickerInfo.clickerInfoInstance.buttonTapCount[i].description
            }
            else {
                countLabel.text = "?"
            }
            countLabel.font = UIFont.systemFontOfSize(30)
            countLabel.tag = i+100
            
            self.view.addSubview(countLabel)
            self.view.addSubview(markLabel)
        }
        if viewFlag {
            self.hatenaLabel.text = ""
            drawClickerBarGraphView.transform = CGAffineTransformMakeScale(1, 0.6)
            drawClickerBarGraphView.layer.position.y = drawClickerBarGraphView.bounds.height/2 + 70
            drawClickerBarGraphView.backgroundColor = UIColor.whiteColor()
            drawClickerBarGraphView.tag = 1000

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreCentralManager.coreCentralInstance.secondViewDelegate = self
        self.drawClickerBarGraphView.delegate = self
        
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
                let name = StudentInfoBox.studentInfoBoxInstance.getStudentInfoForID(studentName[index])?.name
                self.studentNameList.append(name!)
            }
        }
    }
    
    //    /**
    //    tableViewのヘッダー高さ
    //    */
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 44
    //    }
    //
    //    /**
    //    tableViewのヘッダー設定
    //    */
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as! ClickerStudentTableViewCell
    //        cell.studentName.text = "名前"
    //        cell.backgroundColor = colorList2[self.selectMarkNumber]
    //        return cell
    //    }
    //
    //    /**
    //    cellの数
    //    */
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return self.studentNameList.count
    //    }
    //
    //    /**
    //    cellに値を格納
    //    */
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! ClickerStudentTableViewCell
    //        cell.studentName.text = self.studentNameList[indexPath.row]
    //        return cell
    //    }
    
    
    
    // ----Delegate宣言----
    
    /**
    学生からの解答
    */
    func clickerNotification(userID: String, beforMark: String?) {
        if viewFlag {
            var afterMark = ClickerInfo.clickerInfoInstance.studentAnswerList[userID]!
            
            //ビューの削除
            var removeView = self.view.viewWithTag(1000)
            //消すべきビューがあった場合
            if((removeView) != nil){
                removeView!.removeFromSuperview()
            }
            
            // ラベルの値変更
            for var i=0; i < ClickerInfo.clickerInfoInstance.buttonTapCount.count; i++ {
                let selectLabel = self.view.viewWithTag(i+100) as! UILabel
                selectLabel.text = ClickerInfo.clickerInfoInstance.buttonTapCount[i].description
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
            
            // 値を設定
            self.setStudentName()
            
        }
        // カウントラベルをセット
        self.selectedStudentLabel.text = ClickerInfo.clickerInfoInstance.studentAnswerList.count.description
        
        // 最前面
        //        self.view.bringSubviewToFront(self.studentListTableView)
        //        self.studentListTableView.reloadData()
    }
    
}

