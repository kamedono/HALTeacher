//
//  MasterViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/15.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit


class MasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CoreCentralManagerDelegate, QDetailsViewControllerDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var timerView: TimerView!
    
    @IBOutlet weak var questionCollectionView: UICollectionView!
    
    var reanimationNumber: Int = -1
    
    var indexNumber: Int = 0
    
    var indexPathList: [NSIndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        //画面をタップするとtappedを実行する
        //        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"tapped:")
        //        tapGesture.delegate = self
        //        self.view.addGestureRecognizer(tapGesture)
        
        
        self.questionCollectionView.delegate = self
        self.questionCollectionView.dataSource = self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.backView()
//        var timerFinish: String = Timer.timerInstance.count.description
//        if Timer.timerInstance.count == 0 {
//            timerFinish = "Finish!"
//        }
//        self.timerView.setTimerText(timerFinish, timeNum: 1)
    }
    
    /**
    セルの行数を返す
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuestionBox.questionBoxInstance.selectQuestion.count
    }
    
    /**
    セルを内容を変更する
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        self.indexPathList.append(indexPath)
        let cell:QuizQuestionCollectionViewCell = questionCollectionView.dequeueReusableCellWithReuseIdentifier("quizQuestionCollectionViewCell", forIndexPath: indexPath) as! QuizQuestionCollectionViewCell
        
        // 文字の設定
        cell.title.text = QuestionBox.questionBoxInstance.selectQuestion[indexPath.row].name
        cell.number.text = "Q" + (indexPath.row+1).description
        
        cell.backgroundColor = UIColor.clearColor()

        // Cellを黒枠で囲む
        cell.layer.borderColor = UIColor.blackColor().CGColor;
        cell.layer.borderWidth = 1
        
        // 画像を丸く
        cell.layer.cornerRadius = cell.frame.width / 10
        cell.layer.masksToBounds = true
        
        // アニメーション実行
        if self.reanimationNumber == indexPath.row {
            // 問題番号取得
            let questionNumber: Int = QuestionBox.questionBoxInstance.selectQuestion[self.reanimationNumber].questionNumber
            let questionAnswerCount: [Int] = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[questionNumber]!
            // アニメーション設定
            println("animetion", reanimationNumber.description)
            cell.graphView.changeParams(questionAnswerCount)
            cell.graphView.startAnimating()
        }
            
        // 初期の場合
        else if self.reanimationNumber == -1 {
            // 問題番号取得
            let questionNumber = QuestionBox.questionBoxInstance.selectQuestion[indexPath.row].questionNumber
            if let questionAnswerCount: [Int] = QuestionAnswerBox.questionAnswerBoxInstance.questionAnswerCount[questionNumber] {
                // アニメーション設定
                println("animetion", reanimationNumber.description)
                cell.graphView.changeParams(questionAnswerCount)
                cell.graphView.startAnimating()
            }
        }
        
        return cell
    }
    
    /**
    セルを選択したときに呼び出される
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.indexNumber = indexPath.row
        self.performSegueWithIdentifier("goSyousai", sender: self)
    }
    
    /**
    ページ遷移をする際に呼ばれるメソッド
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goSyousai") {
            let qDetailsViewController: QDetailsViewController = segue.destinationViewController as! QDetailsViewController
            qDetailsViewController.indexNumber = self.indexNumber
            qDetailsViewController.delegate = self
            //            resultView.questions = questions
        }
    }
    
    
    
    // ----Delegate宣言----
    
    
    /**
    学生が解答した際通知
    */
    func quizAnswerRequest(questionNumber: Int) {
        println("問題番号",questionNumber.description)
        self.reanimationNumber = questionNumber
        
        // indexPathでないといけないので、
        var indexPath: [NSIndexPath] = []
        indexPath.append(self.indexPathList[questionNumber])
        
        self.questionCollectionView.reloadItemsAtIndexPaths(indexPath)
    }
    
    /**
    詳細から戻ってきた時のデリゲート
    */
    func backView() {
        // タイマーデリゲートを設定
        Timer.timerInstance.delegate = self.timerView
        
        // BLEのデリゲートを設定
        CoreCentralManager.coreCentralInstance.delegate = self
        
        // グラフアニメーションの実行
        self.reanimationNumber = -1
        self.questionCollectionView.reloadData()
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}
