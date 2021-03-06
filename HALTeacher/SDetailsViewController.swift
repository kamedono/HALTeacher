//
//  SDetailsViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/17.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

protocol SDetailsViewControllerDelegate {
    func backView()
}

class SDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoreCentralManagerDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var timerView: TimerView!
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var studentNameLabel: UILabel!
    
    @IBOutlet weak var sChooseAnswerTable: UITableView!
    
    var delegate: SDetailsViewControllerDelegate!
    
    var indexPath = 0
    
    let studentList = StudentInfoBox.studentInfoBoxInstance.studentList
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    let buttonColorList: [String] = ["#ff1e1e", "#f39800", "#ffff28", "#adff2f", "#00ff00", "#00bfff", "#0000cd", "#962dff"]

    
    //ラベル変更フラグ
    var flag: Int = 0
    
    var studentName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getScreen = UIScreen.screens()
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
        }
        
        self.sChooseAnswerTable.dataSource = self
        self.sChooseAnswerTable.delegate = self
        
        // 問題文設定,学生の名前
        self.studentName = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath].name
        self.studentNameLabel.text = htmlParse(self.studentName) + "さん"
        
        self.animation()
    }
    
    /**
    戻る時の処理
    */
    override func viewWillDisappear(animated: Bool) {
        self.delegate.backView()
    }
    
    /**
    Cellの数を返す
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //テーブルのrowの数、ここを動的にするようにするんだよお
        
        //問題数分cellを置く
        return QuestionBox.questionBoxInstance.selectQuestion.count
    }
    
    /**
    Cellの中身を設定
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:SChooseAnswerCell = tableView.dequeueReusableCellWithIdentifier("SChooseAnswerCell", forIndexPath: indexPath) as! SChooseAnswerCell
        
        cell.numberLabel.text = "Q" + (indexPath.row+1).description
        
        // 学生の情報取得
        let studentInfo = StudentInfoBox.studentInfoBoxInstance.getStudentInfo(self.studentName)
        let studentQuestionAnswers = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentInfo!.UUID!]
        let questionNumber = QuestionBox.questionBoxInstance.selectQuestion[indexPath.row].questionNumber
        
        if let studentAnswer = studentQuestionAnswers?.studentAnswer[questionNumber] {
            let questionText = studentAnswer.questionText
            let mark = studentAnswer.mark
            let judge = studentAnswer.judge
            
            cell.markLabel.text = mark
            cell.questionTextLabel.text = htmlParse(questionText)
            
            // 色の設定
            cell.markLabel.backgroundColor = UIColor.hexStr(self.buttonColorList[getMarkNumber(mark)], alpha: 1)

            // 正解だったら
            if judge != "0" {
                cell.judgeImage.image = UIImage(named: "maruClear.png")
            }
            else {
                cell.judgeImage.image = UIImage(named: "batuClear.png")
            }
        }
        else {
            cell.markLabel.text = "未解答"
            cell.questionTextLabel.text = "未解答"
            cell.judgeImage.image = UIImage(named: "NoAnswer.png")
        }
        //        StudentInfoBox.studentInfoBoxInstance.
        //        if QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[
        println(studentQuestionAnswers?.getScore())
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
//        var timerFinish: String = Timer.timerInstance.count.description
//        if Timer.timerInstance.count == 0 {
//            timerFinish = "Finish!"
//        }
//        self.timerView.setTimerText(timerFinish, timeNum: 1)

        Timer.timerInstance.delegate = self.timerView
        CoreCentralManager.coreCentralInstance.delegate = self
    
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    /**
    設定ボタン
    */
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    /**
    詳細ボタン
    */
    @IBOutlet weak var sendDetailButton: UIButton!
    @IBAction func sendDetailButton(sender: UIButton) {
        
        //
        if(flag == 0) {
            //SGraphViewControllerを出さねばならぬ
            if getScreen.count > 1 {
                var sGraphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SGraphViewController") as! SGraphViewController
                sGraphViewController.indexPath = indexPath
                sGraphViewController.viewFlag = false
                SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: sGraphViewController)
            }
            flag = 1
            
            //State更新
            SecondWindow.secondWindowInstance.setSecondViewState("SGraphView")
        }
            
        else if flag == 1 {
            if getScreen.count > 1 {
                var sGraphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SGraphViewController") as! SGraphViewController
                sGraphViewController.indexPath = indexPath
                SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: sGraphViewController)
            }
            //State更新
            SecondWindow.secondWindowInstance.setSecondViewState("GraphView")
            
            flag = 2
        }
            
        else {
            if getScreen.count > 1 {
                var secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondTimerViewController") as! SecondTimerViewController
                SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: secondViewController)
            }
            flag = 0
            
            //State更新
            SecondWindow.secondWindowInstance.setSecondViewState("TimerView")

        }
    }
    
    
    /**
    アニメーション
    */
    func animation() {
        println("index ",indexPath.description)
        var questionAnswerCount: [Int]
        
        // 学生の解答取得
        let studentUUID: NSUUID = self.studentList[indexPath].UUID!
        var studentsAnswerMarkCount: [Int]
        
        
        if QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentUUID]?.studentsAnswerMarkCount != nil {
            studentsAnswerMarkCount = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentUUID]!.studentsAnswerMarkCount
        }
        else {
            studentsAnswerMarkCount = [Int](count: 8, repeatedValue: 0)
        }
        println("DetailsView studentsAnswerMark\(studentsAnswerMarkCount)")
        
        // アニメーション設定
        self.graphView.changeParams(studentsAnswerMarkCount)
        self.graphView.startAnimating()
    }

    
    
    
    // ----Delegate宣言----

    
    /**
    学生が解答した際通知
    */
    func quizStudentAnswerRequest(UUID: NSUUID) {
        
        var studentNumber: Int = 0
        
        // 学生の番号を取得
        for var i=0; i<StudentInfoBox.studentInfoBoxInstance.studentList.count; i++ {
            if StudentInfoBox.studentInfoBoxInstance.studentList[i].UUID == UUID {
                studentNumber = i
                break
            }
        }
        
        if self.indexPath == studentNumber {
            self.sChooseAnswerTable.reloadData()
            self.animation()
        }
        
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}
