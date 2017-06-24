//
//  ConnectStudentViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/07/28.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectStudentViewController: UIViewController, CoreCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var connectStudentTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var navigationItemView: UIBarButtonItem!
    enum State {
        case discover
        case connect
        case disconnect
    }
    
    internal struct ConnectInfo {
        var peripheral: CBPeripheral
        var name: String
        var state: State
    }
    
    var connectStudentList: [ConnectInfo]!
    
    var stateList: [Int] = []
    
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        getScreen = UIScreen.screens()
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
            //            let screen: UIScreen = UIScreen.screens()[1] as! UIScreen
            //            showSecondScreenWindow(screen)
        }
        
        
        if getScreen.count > 1 {
            var waitViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WaitViewController") as! WaitViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: waitViewController)
        }
        
        
        //デリゲートの取得
        self.connectStudentTableView.dataSource = self
        self.connectStudentTableView.delegate = self
        CoreCentralManager.coreCentralInstance.delegate = self
        
        self.nextButton.enabled = false
        
        self.connectStudentList = []
        
        
    }
    
    func screenDidConnect(){
        
    }
    
    
    
    /**
    セルの行数を返す
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectStudentList.count
    }
    
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.connectStudentList[indexPath.row].name ?? "no name"
        
        // セルの色を設定
        for connectinfo in self.connectStudentList {
            switch(connectinfo.state) {
            case .discover:
                cell.backgroundColor = UIColor.whiteColor()

            case .connect:
                cell.backgroundColor = UIColor.greenColor()

            case .disconnect:
                cell.backgroundColor = UIColor.redColor()

            }
        }
        
        return cell
    }
    
    
    /**
    セルを選択したときに呼び出される
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CoreCentralManager.coreCentralInstance.connectStudent(self.connectStudentList[indexPath.row].peripheral)
        println("touch")
    }
    
    
    //次へボタンが押されたとき
    @IBAction func nextButton(sender: AnyObject) {
        CoreCentralManager.coreCentralInstance.scanStop()
        
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: self)
        println("スタートビューが押された")
        if getScreen.count > 1 {
            var waitViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WaitViewController") as! WaitViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: waitViewController)
        }
    }
    
    
    
    
    // ----Delegate宣言----
    
    /**
    書き込みのリクエストがあった場合のプロトコルメソッド
    */
    func discoverStudent(peripheral: CBPeripheral, name: String) {
        self.connectStudentList.append(ConnectInfo(peripheral: peripheral, name: name, state: .discover))
        self.connectStudentTableView.reloadData()
    }
    
    
    /**
    学生端末から学生の情報を取得した時のデリゲート
    */
    func getStudentLogin(peripheral: CBPeripheral) {
        // 接続成功した端末のstate変更
        for connectInfo in self.connectStudentList {
            var i = 0
            if connectInfo.peripheral.identifier == peripheral.identifier {
                self.connectStudentList[i].state = .connect
                println("connectttttttt")
                break
            }
            i++
        }
        
        self.connectStudentTableView.reloadData()
        self.nextButton.enabled = true
    }
    
    
    /**
    学生端末から学生の情報に失敗した時のデリゲート
    */
    func disConnectStudent(peripheral: CBPeripheral) {
        // 接続失敗した端末のstate変更
        for connectInfo in self.connectStudentList {
            var i = 0
            if connectInfo.peripheral.identifier == peripheral.identifier {
                self.connectStudentList[i].state = .disconnect
                break
            }
            i++
        }
        
        self.connectStudentTableView.reloadData()
    }
}
