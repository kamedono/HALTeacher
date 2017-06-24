//
//  NominationSDetailsViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/09.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class NominationStudentMasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CoreCentralManagerDelegate, RightViewControllerDelegate {
    
    @IBOutlet weak var studentCollectionView: UICollectionView!

    var buttonList = ["Abutton.png", "Bbutton.png", "Cbutton.png", "Dbutton.png", "Ebutton.png", "Fbutton.png", "Gbutton.png", "Hbutton.png"]
    
    // 接続中の学生を取得
    let studentList = StudentInfoBox.studentInfoBoxInstance.selectStudentList
    
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
        
        // BLEのデリゲートを設定
        CoreCentralManager.coreCentralInstance.delegate = self
        
        // グラフアニメーションの実行
        self.reanimationNumber = -1
        self.studentCollectionView.reloadData()
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
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
        let cell: NominationQuizStudentCollectionViewCell = studentCollectionView.dequeueReusableCellWithReuseIdentifier("quizStudentCollectionViewCell", forIndexPath: indexPath) as! NominationQuizStudentCollectionViewCell
        
        // indexPathの追加
        self.indexPathList[indexPath.row] = indexPath

        // Cellを黒枠で囲む
        cell.layer.borderColor = UIColor.blackColor().CGColor;
        cell.layer.borderWidth = 1
        
        // 画像を丸く
        cell.layer.cornerRadius = cell.frame.width / 10
        cell.layer.masksToBounds = true

        cell.title.text = studentList[indexPath.row].name

            // 学生の解答取得
            let studentUUID: NSUUID = self.studentList[indexPath.row].UUID!
            let questionNumber = QuestionBox.questionBoxInstance.selectQuestion[0].questionNumber
            let studentsAnswerMark: String? = QuestionAnswerBox.questionAnswerBoxInstance.studentsAnswer[studentUUID]?.studentAnswer[questionNumber]?.mark
            

            if studentsAnswerMark != nil && getMarkNumber(studentsAnswerMark!) != -1 {
                cell.answerImage.image = UIImage(named: self.buttonList[getMarkNumber(studentsAnswerMark!)])
            }
        
        return cell
    }
    
    
    /**
    セルを選択したときに呼び出される
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    
    
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
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}
