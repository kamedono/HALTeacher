//
//  File.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class SelectMoodleQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoreCentralManagerDelegate, RightViewControllerDelegate {
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    @IBOutlet weak var quizListTableView: UITableView!
    
    //選択したセルを記憶
    var selectStudent:[Bool] = []
    var selectStudentIndexPath:[NSIndexPath] = []
    
    // クリッカーの情報を取得
    var clickerSubject = MoodleInfo.moodleInfoInstance.getClickerSubjectList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのデリゲート設定
        self.quizListTableView.dataSource = self
        self.quizListTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
        
        CoreCentralManager.coreCentralInstance.delegate = self
        quizListTableView.reloadData()
    }
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }

    
    
    /**
    セルの行数
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.clickerSubject.count
    }
    
    /**
    セルをタッチした時
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ClickerInfo.clickerInfoInstance.setEmpty()
        ClickerInfo.clickerInfoInstance.clickerSubject = self.clickerSubject[indexPath.row]
        
        // 学生の情報を送る
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.clickerUUID, sendData: nil)
        self.performSegueWithIdentifier("goMoodleClickerBarGraphViewControllerSegue", sender: nil)
        
    }
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.clickerSubject[indexPath.row].title
        
        return cell
    }
    
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}