//
//  SGraphViewController.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/16.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import Foundation

class SGraphViewController: UIViewController, SecondViewCoreCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var graphView: GraphView!

    @IBOutlet weak var sChooseAnswerTable: UITableView!

    
    var indexPath = 0
    
    let studentList = StudentInfoBox.studentInfoBoxInstance.studentList
    
    var studentName: String!
    
    let buttonColorList: [String] = ["#ff1e1e", "#f39800", "#ffff28", "#adff2f", "#00ff00", "#00bfff", "#0000cd", "#962dff"]

    var viewFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.studentName = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath].name

        self.sChooseAnswerTable.delegate = self
        self.sChooseAnswerTable.dataSource = self

        
        self.nameTextLabel.numberOfLines = -1
        
        self.nameTextLabel.text = htmlParse(StudentInfoBox.studentInfoBoxInstance.studentList[indexPath].name)
        
        
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
            return QuestionBox.questionBoxInstance.selectQuestion.count
        }
        else {
            return 0
        }
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
    
    /**
    アニメーション
    */
    func animation() {
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
        
        // アニメーション設定
        self.graphView.changeParams(studentsAnswerMarkCount)
        self.graphView.startAnimating()
    }
    
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
            if self.viewFlag {
                self.sChooseAnswerTable.reloadData()
            }
            self.animation()
        }
        
    }}