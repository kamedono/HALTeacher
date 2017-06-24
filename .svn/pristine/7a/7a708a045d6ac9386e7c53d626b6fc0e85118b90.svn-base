//
//  ConnectionConfirmationViewController.swift
//  SlideMenuControllerSwift_Test
//
//  Created by sotuken on 2015/08/27.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import CoreBluetooth
import UIKit


class ConnectionConfirmationViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, CoreCentralManagerDelegate {
    //ソート確認フラグ
    var sortedFlag = false
    
    //欠席者順にする時に入れる配列
    var absentStudents:[StudentInfo] = []
    
    @IBOutlet weak var StudentListTablewView: UITableView!
    
    // 戻るボタンを用意
    var backButton: UIBarButtonItem!

    // テーブルソート用のswitchボタン
    var tableSortSwitch: UISwitch!
    var tableStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのデリゲート設定
        self.StudentListTablewView.dataSource = self
        self.StudentListTablewView.delegate = self
        
        //ナビゲーションバーのタイトル
        self.title = "接続確認画面"
        
        //switchの初期化
        tableSortSwitch = UISwitch()
        tableStateLabel = UILabel()
        tableSortSwitch.on = true
        
        //テーブルの状態を表示するラベルの初期化
        tableStateLabel.text = "出席番号"
        tableStateLabel.sizeToFit()
        // Switchを押された時に呼ばれるメソッド
        tableSortSwitch.addTarget(self, action: "pushTableSortSwicth:", forControlEvents: UIControlEvents.ValueChanged)
        
        //backボタンの初期化
        backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "pushBuckButton")
        //UIBarButtonItemをナビゲーションバーの左側に設置
        self.navigationItem.leftBarButtonItem = backButton
        var navigationSwitch = UIBarButtonItem(customView: tableSortSwitch)
        var navigationLabel = UIBarButtonItem(customView: tableStateLabel)
        var navigationItems :[AnyObject] = [navigationSwitch,navigationLabel]
        self.navigationItem.rightBarButtonItems = navigationItems
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
    }
    
    func pushTableSortSwicth(sender: UISwitch){
        if sender.on {
            tableStateLabel.text = "出席番号"
            sortedFlag = false
            StudentListTablewView.reloadData()
        }
        else {
            tableStateLabel.text = "欠席"
            sortTableView()
            sortedFlag = true
            StudentListTablewView.reloadData()
        }
    }
    
    /**
    ソートする
    */
    func sortTableView() {
        var studyingStudents:[StudentInfo] = []
        for(var i=0; StudentInfoBox.studentInfoBoxInstance.studentList.count>i; i++){
            if(StudentInfoBox.studentInfoBoxInstance.studentList[i].absent){
                absentStudents.append(StudentInfoBox.studentInfoBoxInstance.studentList[i])
            }else{
                studyingStudents.append(StudentInfoBox.studentInfoBoxInstance.studentList[i])
            }
        }
        for student in studyingStudents{
            absentStudents.append(student)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CoreCentralManager.coreCentralInstance.delegate = self
        StudentListTablewView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return StudentInfoBox.studentInfoBoxInstance.studentList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("おされた\(indexPath.row)")
    }
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        //ソートされているか確認
        if(sortedFlag){
            cell.textLabel?.text = self.absentStudents[indexPath.row].name
            //欠席している学生のセルを赤色にする
            if(self.absentStudents[indexPath.row].absent){
                cell.backgroundColor = UIColor.redColor()
            }
        }else{
            cell.textLabel?.text = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].name
            //欠席している学生のセルを赤色にする
            if(StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].absent){
                cell.backgroundColor = UIColor.redColor()
            }
        }
        return cell
    }
    
    
    
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
    }
    
    
    func disConnectStudent(peripheral: CBPeripheral) {
        StudentListTablewView.reloadData()
    }
}