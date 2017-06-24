//
//  GraphViewController.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import Foundation

class GraphViewController: UIViewController, SecondViewCoreCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var chooseAnswerTable: UITableView!
    //@IBOutlet weak var graphImage: UIImageView!
    
    var indexNumber = 0
    
    var questionNumber = 0
    
    let buttonColorList: [String] = ["#ff1e1e", "#f39800", "#ffff28", "#adff2f", "#00ff00", "#00bfff", "#0000cd", "#962dff"]
    
    var viewFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let img = UIImage(named: "grafu777.png")
        //        graphImage.image = img
        
        self.chooseAnswerTable.delegate = self
        self.chooseAnswerTable.dataSource = self

        //行数無制限
        self.questionTextLabel.numberOfLines = -1
        
        // サイズを自動調整
        //self.questionTextLabel.sizeToFit()
        
        // 問題文設定
        self.questionTextLabel.text = "Q. "+htmlParse(QuestionBox.questionBoxInstance.selectQuestion[indexNumber].question_text)
        
        self.questionNumber = QuestionBox.questionBoxInstance.selectQuestion[self.indexNumber].questionNumber
        
        self.animation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreCentralManager.coreCentralInstance.secondViewDelegate = self
    }
    
    /**
    Cellの数を返す
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewFlag {
            //テーブルのrowの数、解答群の数だけ追加,未解答分で+1
            return StudentInfoBox.studentInfoBoxInstance.studentList.count
        }
        else {
            return 0
        }
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
    アニメーション
    */
    func animation() {
        var questionAnswerCount: [Int]
        let questionNumber = QuestionBox.questionBoxInstance.selectQuestion[self.indexNumber].questionNumber
        if QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[questionNumber] != nil {
            questionAnswerCount = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[questionNumber]!
        }
        else {
            questionAnswerCount = [Int](count: QuestionBox.questionBoxInstance.selectQuestion[self.indexNumber].answers.count, repeatedValue: 0)
        }
        
        // アニメーション設定
        self.graphView.changeParams(questionAnswerCount)
        self.graphView.startAnimating()
    }
    
    
    /**
    学生が解答した際通知
    */
    func quizAnswerRequest(questionNumber: Int) {
        if questionNumber == self.indexNumber {
            if self.viewFlag {
                self.chooseAnswerTable.reloadData()
            }
            self.animation()
        }
    }
}
