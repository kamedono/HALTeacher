//
//  StudentMasterViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/19.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class StudentMasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CoreCentralManagerDelegate, SDetailsViewControllerDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var timerView: TimerView!
    
    @IBOutlet weak var studentCollectionView: UICollectionView!
    
    // 接続中の学生を取得
    let studentList = StudentInfoBox.studentInfoBoxInstance.studentList
    
    var reanimationNumber: Int = -1
    
    var indexNumber: Int = 0
    
    var indexPathList: [NSIndexPath] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        studentCollectionView.delegate = self
        studentCollectionView.dataSource = self
        
        
        // indexPathListの初期化
        for var i=0; i<studentList.count; i++ {
            indexPathList.append(NSIndexPath(index: i))
        }
        
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
        return studentList.count
    }
    
    /**
    セルを内容を変更する
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:QuizStudentCollectionViewCell = studentCollectionView.dequeueReusableCellWithReuseIdentifier("quizStudentCollectionViewCell", forIndexPath: indexPath) as! QuizStudentCollectionViewCell

        // Cellを黒枠で囲む
        cell.layer.borderColor = UIColor.blackColor().CGColor;
        cell.layer.borderWidth = 1

        // 画像を丸く
        cell.layer.cornerRadius = cell.frame.width / 10
        cell.layer.masksToBounds = true
        
        // indexPathの追加
        self.indexPathList[indexPath.row] = indexPath
        
        cell.title.text = studentList[indexPath.row].name
        cell.backgroundColor = UIColor.clearColor()
        
        // アニメーション実行
        if self.reanimationNumber == indexPath.row {
            // 学生の解答取得
            let studentUUID: NSUUID = self.studentList[reanimationNumber].UUID!
            let studentsAnswerMarkCount: [Int] = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentUUID]!.studentsAnswerMarkCount
            

            println("studentsAnswerMark\(studentsAnswerMarkCount)")

            // アニメーション設定
            println("animetion", reanimationNumber.description)
            cell.graphView.changeParams(studentsAnswerMarkCount)
            cell.graphView.startAnimating()
        }
        
        else if self.reanimationNumber == -1 {
            // 学生の解答取得
            let studentUUID: NSUUID = self.studentList[indexPath.row].UUID!
            if let studentsAnswerMarkCount = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentUUID]?.studentsAnswerMarkCount {
            
            
            println("studentsAnswerMark\(studentsAnswerMarkCount)")
            
            // アニメーション設定
            println("animetion", reanimationNumber.description)
            cell.graphView.changeParams(studentsAnswerMarkCount)
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
        self.performSegueWithIdentifier("goStudentSyousai", sender: self)
    }
    
    /**
    ページ遷移をする際に呼ばれるメソッド
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goStudentSyousai") {
            let sDetailsViewController: SDetailsViewController = segue.destinationViewController as! SDetailsViewController
            sDetailsViewController.indexPath = self.indexNumber
            sDetailsViewController.delegate = self
            //            resultView.questions = questions
        }
    }
    
    
    
    
    // ----Delegate宣言----
    
    
    /**
    学生が解答した際通知
    */
    func quizStudentAnswerRequest(UUID: NSUUID) {
        var studentNumber: Int = 0
        for var i=0; i<studentList.count; i++ {
            if studentList[i].UUID == UUID {
                studentNumber = i
                break
            }
        }
        self.reanimationNumber = studentNumber
        
        // indexPathでないといけないので、
        var indexPath: [NSIndexPath] = []
        indexPath.append(self.indexPathList[studentNumber])
        
        self.studentCollectionView.reloadItemsAtIndexPaths(indexPath)
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
        
        self.studentCollectionView.reloadData()
        
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
