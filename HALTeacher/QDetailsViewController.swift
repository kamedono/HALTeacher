//
//  QSyousaiViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/16.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

protocol QDetailsViewControllerDelegate {
    func backView()
}

class QDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CoreCentralManagerDelegate, RightViewControllerDelegate {
    
    
    @IBOutlet weak var timerView: TimerView!
    
    @IBOutlet weak var questionTextLabel: UILabel!
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var chooseAnswerTable: UITableView!
    
    var delegate: QDetailsViewControllerDelegate!
    
    var indexNumber = 0
    var questionNumber = 0
    
    var markList: [String] = []
    
    let buttonColorList: [String] = ["#ff1e1e", "#f39800", "#ffff28", "#adff2f", "#00ff00", "#00bfff", "#0000cd", "#962dff"]
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getScreen = UIScreen.screens()
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
        }
        
        self.chooseAnswerTable.dataSource = self
        self.chooseAnswerTable.delegate = self
        
        // 問題文設定
        self.questionTextLabel.text = htmlParse(QuestionBox.questionBoxInstance.selectQuestion[indexNumber].question_text)
        
        // フォントの自動調節
        self.questionTextLabel.adjustsFontSizeToFitWidth = true
        self.questionTextLabel.lineBreakMode = NSLineBreakMode.ByClipping
        
        // 解答群の数
        var answers = QuestionBox.questionBoxInstance.selectQuestion[indexNumber].answers
        
        var answersCount = answers.count
        
        var markList: [String] = []
        for answer in answers {
            markList.append(answer.mark)
        }
        println("mark:\(markList)")
        
        self.animation()
        
        self.questionNumber = QuestionBox.questionBoxInstance.selectQuestion[indexNumber].questionNumber
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        Timer.timerInstance.delegate = self.timerView
        CoreCentralManager.coreCentralInstance.delegate = self
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
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
        
        //テーブルのrowの数、解答群の数だけ追加,未解答分で+1
        return StudentInfoBox.studentInfoBoxInstance.studentList.count
    }
    
    /**
    Cellの値を設定
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: ChooseAnswerCell = tableView.dequeueReusableCellWithIdentifier("ChooseAnswerCell", forIndexPath: indexPath) as! ChooseAnswerCell
        
        // セルの表示内容取得
        cell.nameLabel.text = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].name
        let studentUUID = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].UUID
        let studentQuestionAnswers = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentUUID!]
        if let studentAnswer = studentQuestionAnswers?.studentAnswer[self.questionNumber] {
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
            cell.questionTextLabel.text = ""
            cell.judgeImage.image = UIImage(named: "NoAnswer.png")
        }
        
        
        return cell
    }
    
    /**
    設定ボタン
    */
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    //ラベル変更フラグ
    var flag: Int = 0
    
    //詳細ボタン
    @IBOutlet weak var sendDetailButton: UIButton!
    @IBAction func sendDetailButton(sender: UIButton) {
        
        //
        if(flag == 0) {
            //            sendDetailButton.setTitle("タイマーに戻る", forState: UIControlState.Normal)
            println("Show Detail!")
            
            if getScreen.count > 1 {
                var graphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GraphViewController") as! GraphViewController
                graphViewController.indexNumber = indexNumber
                graphViewController.viewFlag = false
                SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: graphViewController)
            }
            flag = 1
            
            //State更新
            SecondWindow.secondWindowInstance.setSecondViewState("GraphView")
        }
            
        else if flag == 1 {
            if getScreen.count > 1 {
                var graphViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GraphViewController") as! GraphViewController
                graphViewController.indexNumber = indexNumber
                SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: graphViewController)
            }
            //State更新
            SecondWindow.secondWindowInstance.setSecondViewState("GraphView")
            
            flag = 2
        }
            
        else {
            //            sendDetailButton.setTitle("ディスプレイに出力", forState: UIControlState.Normal)
            println("Show Timer!")
            
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
        println("index :",self.indexNumber.description)
        var questionAnswerCount: [Int]
        let questionNumber = QuestionBox.questionBoxInstance.selectQuestion[self.indexNumber].questionNumber
        if QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[questionNumber] != nil {
            questionAnswerCount = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[questionNumber]!
        }
        else {
            println("nil")
            questionAnswerCount = [Int](count: QuestionBox.questionBoxInstance.selectQuestion[indexNumber].answers.count, repeatedValue: 0)
        }
        
        // アニメーション設定
        self.graphView.changeParams(questionAnswerCount)
        self.graphView.startAnimating()
    }
    
    
    
    
    // ----Delegate宣言----
    
    
    /**
    学生が解答した際通知
    */
    func quizAnswerRequest(questionNumber: Int) {
        if questionNumber == self.indexNumber {
            self.chooseAnswerTable.reloadData()
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
