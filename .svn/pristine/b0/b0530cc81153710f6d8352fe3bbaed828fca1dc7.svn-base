//
//  ZoomUpMonitoringViewController.swift
//  SlideMenuControllerSwift_Test
//
//  Created by sotuken on 2015/08/22.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//
import UIKit

class ZoomUpMonitoringViewController: UIViewController {
    // 戻るボタンを用意
    var backdButton: UIBarButtonItem!
    var selectStudentNumber: Int!
    var screenShotImageData: NSData!
    
    @IBOutlet weak var lockButton: UIBarButtonItem!
    
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].name+"の画面"

        //画像の描画
        screenShotImageView.image = UIImage(data: screenShotImageData)
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].lock){
            self.lockButton.title = "ロック解除"
        }else{
            self.lockButton.title = "ロックする"
        }
    }
    
    /**
    ロックボタンを押した時のアクション
    */
    @IBAction func pushLockButton(sender: AnyObject) {
        if(StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].lock){
            StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].lock = false
            self.lockButton.title = "ロックする"
            // ロック通知
            var studentInfo: [NSUUID] = []
            studentInfo.append(StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].UUID!)
            CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.lockUUID, sendData: "unlock", studentUUIDList: studentInfo)

        }else{
            StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].lock = true
            self.lockButton.title = "ロック解除"
            // ロック解除通知
            var studentInfo: [NSUUID] = []
            studentInfo.append(StudentInfoBox.studentInfoBoxInstance.studentList[selectStudentNumber].UUID!)
            CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.lockUUID, sendData: "lock", studentUUIDList: studentInfo)
        }
        
    }
    
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
    }
}