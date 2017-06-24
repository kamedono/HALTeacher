//
//  NominationExitViewController.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/09.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class NominationFinishViewController: UIViewController, RightViewControllerDelegate, CoreCentralManagerDelegate {
    
    @IBOutlet weak var nominationQuizFinishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nominationQuizFinishButton.enabled = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        CoreCentralManager.coreCentralInstance.delegate = self

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FinishButtonAction(sender: AnyObject) {
        self.createMoodleAccessAlertView("小テスト")
    }
    
    /**
    確認alertの表示
    */
    func createMoodleAccessAlertView(title: String) {
        dispatch_async(dispatch_get_main_queue(), {
            // AlertController作成
            var checkAlertView = UIAlertController(title: title + "を終了します", message: "よろしいですか？", preferredStyle: .Alert)
            
            // OKボタンを押した時
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                    self.contentFinish()
            }
            
            // Cancelボタンを押した時
            var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            // AlertControllerにActionを追加させる
            checkAlertView.addAction(okAction)
            checkAlertView.addAction(cancelAction)
            
            //Viewを見せる
            self.presentViewController(checkAlertView, animated: true, completion: nil)
        })
    }
    
    /**
    解答締め切りの終了処理
    */
    @IBAction func finishNominationQuizAcceptanceButton(sender: AnyObject) {
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.quizFinishUUID, sendData: "quizFinish", studentUUIDList: StudentInfoBox.studentInfoBoxInstance.getSelectUUIDList())
        self.nominationQuizFinishButton.enabled = true
    }
    
    /**
    小テストの終了処理
    */
    func contentFinish() {
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.quizFinishUUID, sendData: "exit", studentUUIDList: StudentInfoBox.studentInfoBoxInstance.getSelectUUIDList())
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
        BGMManager.bgmManagerInstance.stopMusic()
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}
