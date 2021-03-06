//
//  GoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit

class LockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // 戻るボタンを用意
    var backButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    //選択したセルを記憶
    var selectStudent:[Bool] = []
    
    var selectStudentIndexPath:[NSIndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for(var i=0; i<StudentInfoBox.studentInfoBoxInstance.studentList.count; i++){
            selectStudent.append(false)
            selectStudentIndexPath.append(NSIndexPath())
        }
        
        //テーブルビューのデリゲート設定
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsMultipleSelection = true
        
        //ナビゲーションバーのタイトル
        self.title = "ロック画面"
        
        //初期化
        backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "pushBuckButton")
        
        //UIBarButtonItemをナビゲーションバーの左側に設置
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return StudentInfoBox.studentInfoBoxInstance.studentList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectStudent[indexPath.row] = true
    }
    
    /**
    選択解除した時
    */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectStudent[indexPath.row] = false
    }
    
    
    /**
    全端末ロックのボタンを押した時
    selectStudentを全選択した状態にして
    テーブルビューをリロードする
    */
    @IBAction func pushAllLock(sender: AnyObject) {
        selectStudent = [Bool](count: selectStudent.count, repeatedValue: true)
        
        for(var i=0; StudentInfoBox.studentInfoBoxInstance.studentList.count > i; i++){
            StudentInfoBox.studentInfoBoxInstance.studentList[i].lock = true
        }
        // lock送信
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.lockUUID, sendData: "lock")
        
        tableView.reloadData()
    }
    
    
    /**
    ロック解除のボタンを押した時
    selectStudentの中身を全てfalseにして
    テーブルビューをリロード
    */
    @IBAction func pushCanselLock(sender: AnyObject) {
        selectStudent = [Bool](count: selectStudent.count, repeatedValue: false)
        
        for(var i=0; StudentInfoBox.studentInfoBoxInstance.studentList.count > i; i++){
            StudentInfoBox.studentInfoBoxInstance.studentList[i].lock = false
        }
        // Unlock送信
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.lockUUID, sendData: "unlock")
        
        tableView.reloadData()
    }
    
    
    /**
    ロックボタンを押した時
    テーブルビューをリロードする
    */
    @IBAction func pushLock(sender: AnyObject) {
        var studentUUIDList: [NSUUID] = []
        for(var i=0; StudentInfoBox.studentInfoBoxInstance.studentList.count > i; i++){
            if(selectStudent[i]){
                StudentInfoBox.studentInfoBoxInstance.studentList[i].lock = true
                studentUUIDList.append(StudentInfoBox.studentInfoBoxInstance.studentList[i].UUID!)
            }
        }
        // lock送信
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.lockUUID, sendData: "lock", studentUUIDList: studentUUIDList)
        
        tableView.reloadData()
    }
    
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].name
        //        selectStudentIndexPath[indexPath.row] = indexPath
        //        if (selectStudent[indexPath.row]){
        //            cell.backgroundColor = UIColor.redColor()
        //            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //        }else{
        //            cell.backgroundColor = UIColor.whiteColor()
        //        }
        
        if(StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].lock){
            cell.backgroundColor = UIColor.redColor()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
        
    }
    
    
    
}