//
//  ConnectMoodleViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/18.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class ConnectMoodleViewController: UIViewController, TeacherMoodleLoginAlertDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var courceTableView: UITableView!
    
    // Moodleアクセスの際に必要なアラート表示のインスタンス
    var teacherMoodleLoginAlert = TeacherMoodleLoginAlert()

    // Moodleのアクセスするためのインスタンス
    var moodleAccess = TeacherMoodleAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーをつける
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.courceTableView.delegate = self
        self.courceTableView.dataSource = self

        self.teacherMoodleLoginAlert.delegate = self
        
        // 自動設定が入っている場合
        if MoodleInfo.moodleInfoInstance.autoFlag {
            self.moodleAccess.delegate = teacherMoodleLoginAlert
            self.teacherMoodleLoginAlert.moodleAccess = moodleAccess
            self.teacherMoodleLoginAlert.createMoodleAccessAlertView()
            self.moodleAccess.checkMoodleLogin(UserInfo.userInfoInstance.userID!, password: UserInfo.userInfoInstance.password!)
        }
            
        // CoreDataにデータがない場合
        else if MoodleInfo.moodleInfoInstance.courceList.count == 0 {
            self.teacherMoodleLoginAlert.createMoodleAccessCheckAlertEnableCancel()
        }
            
        else {
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreCentralManager.coreCentralInstance.setEmpty()
    }
    
    /**
    セルの行数を返す
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoodleInfo.moodleInfoInstance.courceList.count
        
    }
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CourceCell")
        cell.textLabel?.text = MoodleInfo.moodleInfoInstance.courceList[indexPath.row].courceName ?? "no name"
        cell.textLabel?.font = UIFont.systemFontOfSize(CGFloat(30))
        return cell
    }
    
    /**
    セルを選択したときに呼び出される
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let list:[CourceContent] = MoodleInfo.moodleInfoInstance.courceList
        MoodleInfo.moodleInfoInstance.selectCource = MoodleInfo.moodleInfoInstance.courceList[indexPath.row]

        println("courceInfo\(MoodleInfo.moodleInfoInstance.courceList[indexPath.row].studentList)")
        self.performSegueWithIdentifier("goConnectStudentViewControllerSegue", sender: nil)
    }
    
    /**
    ユーザ変更ボタン
    */
    @IBAction func userChangeButtonAction(sender: AnyObject) {
        self.teacherMoodleLoginAlert.createMoodleAccessCheckAlertEnableCancel()
    }
    
    
    
    // ----Delegate宣言----

    /**
    接続終了時
    */
    func connectionFinished() {
        dispatch_async(dispatch_get_main_queue(), {
            self.courceTableView.reloadData()
        })
    }
}