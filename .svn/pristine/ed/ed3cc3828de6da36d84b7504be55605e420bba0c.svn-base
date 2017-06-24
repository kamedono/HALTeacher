//
//  aaa.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/18.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import CoreBluetooth
import UIKit

class ConnectionStudentViewController: UIViewController, CoreCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource, TeacherMoodleAccessDelegate {
    @IBOutlet weak var connectStudentTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    enum State {
        case null
        case discover
        case connect
        case disconnect
    }
    
    internal struct ConnectInfo {
        var peripheral: CBPeripheral?
        var name: String?
        var state: State?
    }
    
    var connectStudentList: [ConnectInfo]!
    
    var stateList: [Int] = []
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    var teacherMoodleAccess: TeacherMoodleAccess!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //デリゲートの取得
        self.connectStudentTableView.dataSource = self
        self.connectStudentTableView.delegate = self
        
        CoreCentralManager.coreCentralInstance.delegate = self
        
        // ボタンを使えなくする
        self.nextButton.enabled = true
        
        self.connectStudentList = [ConnectInfo](count: MoodleInfo.moodleInfoInstance.selectCource.studentList.count, repeatedValue: ConnectInfo(peripheral: nil, name: nil, state: .null))
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreCentralManager.coreCentralInstance.scanStart()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        CoreCentralManager.coreCentralInstance.scanStop()
    }
    
    /**
    セルの行数を返す
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        println("カウント",MoodleInfo.moodleInfoInstance.selectCource.studentList.count)
        return MoodleInfo.moodleInfoInstance.selectCource.studentList.count
    }
    
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        // 名前の設定
        var cell: StudentProfileCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StudentProfileCell
        
        // 画像の設定
        cell.nameLabel.text = MoodleInfo.moodleInfoInstance.selectCource.studentList[indexPath.row] ?? "no name"
        if StudentInfoBox.studentInfoBoxInstance.getStudentNameIndex(MoodleInfo.moodleInfoInstance.selectCource.studentList[indexPath.row]) != -1 {
            let name = MoodleInfo.moodleInfoInstance.selectCource.studentList[indexPath.row]
            let studentInfo = StudentInfoBox.studentInfoBoxInstance.getStudentInfo(name)
            cell.profileImage.image = studentInfo!.profileImage
        }
        
        
        // セルの色を設定
        switch(self.connectStudentList[indexPath.row].state!) {
        case .null:
            cell.backgroundColor = UIColor.hexStr("#9FD8FF", alpha: 1)
            cell.contentView.backgroundColor = UIColor.hexStr("#9FD8FF", alpha: 1)
            
        case .discover:
            cell.backgroundColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = UIColor.whiteColor()
            
        case .connect:
            cell.backgroundColor = UIColor.hexStr("#9FFF8D", alpha: 1)
            cell.contentView.backgroundColor = UIColor.hexStr("#9FFF8D", alpha: 1)
            
        case .disconnect:
            cell.backgroundColor = UIColor.hexStr("#FFAB9B", alpha: 1)
            cell.contentView.backgroundColor = UIColor.hexStr("#FFAB9B", alpha: 1)
            
        }
        
        return cell
        
    }
    
    
    /**
    セルを選択したときに呼び出される
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        CoreCentralManager.coreCentralInstance.connectStudent(self.connectStudentList[indexPath.row].peripheral)
        //        println("touch")
    }
    
    
    //次へボタンが押されたとき
    @IBAction func nextButton(sender: AnyObject) {
        CoreCentralManager.coreCentralInstance.scanStop()
        
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: self)

    }
    
    
    
    
    // ----Delegate宣言----
    
    /**
    デバイス発見時に呼び出さられるデリゲート
    */
    func discoverStudent(peripheral: CBPeripheral, name: String) {
        println("name",name)
        for (index, studentName) in enumerate(MoodleInfo.moodleInfoInstance.selectCource.studentList) {
            if name == studentName {
                self.connectStudentList[index] = (ConnectInfo(peripheral: peripheral, name: name, state: .discover))
                CoreCentralManager.coreCentralInstance.connectStudent(peripheral)
                self.connectStudentTableView.reloadData()
            }
        }
    }
    
    
    /**
    学生端末から学生の情報を取得した時のデリゲート
    */
    func getStudentLogin(peripheral: CBPeripheral) {
        
        dispatch_async(dispatch_get_main_queue(), {
            // 接続成功した端末のstate変更
            for (index, connectInfo) in enumerate(self.connectStudentList) {
                if connectInfo.peripheral?.identifier == peripheral.identifier {
                    self.connectStudentList[index].state = .connect
                    println("connectttttttt")
                    break
                }
            }
            self.connectStudentTableView.reloadData()
            self.nextButton.enabled = true
        })
    }
    
    
    /**
    学生端末から学生の情報に失敗した時のデリゲート
    */
    func disConnectStudent(peripheral: CBPeripheral) {
        // 接続失敗した端末のstate変更
        for (index, connectInfo) in enumerate(self.connectStudentList) {
            if connectInfo.peripheral?.identifier == peripheral.identifier {
                self.connectStudentList[index].state = .disconnect
                break
            }
        }
        
        self.connectStudentTableView.reloadData()
    }
}
