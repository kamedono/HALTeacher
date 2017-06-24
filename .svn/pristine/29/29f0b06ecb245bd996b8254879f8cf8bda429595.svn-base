//
//  SelectTableViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/05.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class SelectQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RightViewControllerDelegate {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    @IBOutlet weak var questionListTableView: UITableView!
    
    @IBOutlet weak var detailButton: UIButton!

    //タップしたセルを記憶する
    var selections: [Bool] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewの設定
        self.questionListTableView.delegate = self
        self.questionListTableView.dataSource = self

        self.questionListTableView.estimatedRowHeight = 44.0
        self.questionListTableView.rowHeight = UITableViewAutomaticDimension

        self.detailButton.enabled = false
        
        //問題を書くのする配列の初期化
        self.selections = [Bool](count: QuestionBox.questionBoxInstance.questions.count, repeatedValue: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    セルを押したとき
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selections[indexPath.row] = true
        self.selectQuestions()
    }
    
    /**
    二回目にセルを押したとき
    */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.selections[indexPath.row] = false
        self.selectQuestions()
    }
    
    /**
    セルの行数
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionBox.questionBoxInstance.questions.count
    }
    
    /**
    セル作成
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: QuestionTableViewCell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionTableViewCell
        var questionText = htmlParse(QuestionBox.questionBoxInstance.questions[indexPath.row].question_text)
        
        // セルのラベルをセット
        cell.questionNumberLabel.text = "Q.\(indexPath.row + 1)"
        cell.questionLabel.text = QuestionBox.questionBoxInstance.questions[indexPath.row].name
        cell.questionText.text = questionText
        
        return cell
    }
    
    @IBAction func goSetTimeButton(sender: AnyObject) {
        // 選択した問題をselectQuestionにセット
        for select in self.selections {
            if(select) {
                var selectedQuestion: [QuestionXML] = []
                var questionID: [Int] = []
                
                for (var i=0; i<QuestionBox.questionBoxInstance.questions.count; i++) {
                    if(selections[i] == true) {
                        selectedQuestion.append(QuestionBox.questionBoxInstance.questions[i])
                        
                        // BLEの通信部分にデータ格納
                        questionID.append(i)
                        
                        // 学生の解答カウントの変数を初期化
                        // 回答群の個数
                        let answerCount: Int = QuestionBox.questionBoxInstance.questions[i].answers.count
                        var answerArray: [Int] = [Int](count: answerCount , repeatedValue: 0)
                        
                        
                        QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount.updateValue(answerArray, forKey: QuestionBox.questionBoxInstance.questions[i].questionNumber)
                        
                    }
                }
                QuestionBox.questionBoxInstance.questionID = questionID
                QuestionBox.questionBoxInstance.selectQuestion = selectedQuestion
                println(QuestionBox.questionBoxInstance.questionID)
                
                self.performSegueWithIdentifier("goQuizSettingViewSegue", sender: self)
                break
            }
        }
    }
    
    // 制御ボタンを押した時
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    // 選択した問題の表示、保存などを行う
    private func selectQuestions(){
        var count = 0
        for select in self.selections{
            if(select){
                count++
                // ボタンを許可
                self.detailButton.enabled = true
            }
        }
        if count == 0 {
            self.detailButton.enabled = false
        }
        self.title = "ー　問題選択　ー　選択数 : \(count)"
        
        // 問題数の保存
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(count, forKey: "questionCount")
        userDefaults.synchronize()
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
    
}