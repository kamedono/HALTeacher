//
//  StudentSelectTableViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/08/09.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class NominationStudentSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RightViewControllerDelegate {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var studentListTabelView: UITableView!
    
    // 接続中の学生リストを取得
    var studentList: [StudentInfo] = StudentInfoBox.studentInfoBoxInstance.studentList
    
    // 選択した学生を保存
    var selectList: [Bool] = []
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton
        
        self.studentListTabelView.delegate = self
        self.studentListTabelView.dataSource = self
        
        // ボタンを無効化
        self.nextButton.enabled = false

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectList = [Bool](count: self.studentList.count, repeatedValue: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectList[indexPath.row] = true
        self.selectStudents()
    }
    
    
     func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectList[indexPath.row] = false
        self.selectStudents()
    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentList.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! NominationStudentTableViewCell
        cell.studentNameLabel.text = self.studentList[indexPath.row].name
        cell.studentNumLabel.text = "No.\(indexPath.row + 1)"
        cell.imageView?.image = self.studentList[indexPath.row].profileImage
        
        return cell
    }
    
    
    @IBAction func goToStuSele(sender: AnyObject) {
        var selectStudentList: [StudentInfo] = []
        
        // 選択した学生をセット
        if self.nextButton.enabled {
            for (index, value) in enumerate(self.selectList) {
                if value {
                    selectStudentList.append(self.studentList[index])
                }
            }
            StudentInfoBox.studentInfoBoxInstance.selectStudentList = selectStudentList
            
            self.performSegueWithIdentifier("goNominationQuizSettingViewControllerSegue", sender: self)
        }
    }
    
    
    /**
    選択数をタイトルに設定
    */
    private func selectStudents(){
        var count = 0
        for select in self.selectList {
            if select {
                count++
            }
        }
        self.title = "ー　学生選択　ー　選択人数 : \(count)"
        
        // 選択されていない場合にnextButtonを使えなくする
        if count == 0 {
            self.nextButton.enabled = false
        }
        else {
            self.nextButton.enabled = true
        }
    }

    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }

}
