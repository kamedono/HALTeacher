//
//  TopTableViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/05.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class TopTableViewController: UITableViewController {
    
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    // タイトル戻るボタン！
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {}
    
    //コース一覧
    var cource :[String] = ["小テスト(全員)","小テスト（指名）","KJ"]
    
    //選択したコースを記憶
    var selectCourceNumber = 0
    
    var selectScreen: UIScreen!
    var getScreen: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // インスタンスの配列の初期化のつもり
        QuestionBox.questionBoxInstance.setEmpty()
        
        QuestionAnswerBox.questionAnswerBoxInstance.setEmpty()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        // navigationBarを出す
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton
        
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.statusUUID, sendData: "Wait")
        
        // セカンドスクリーンについて
        getScreen = UIScreen.screens()
        
        // 接続中の画面が2つある場合、2番目を表示.
        if getScreen.count > 1 {
            selectScreen = UIScreen.screens()[1] as! UIScreen
            
            var waitViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WaitViewController") as! WaitViewController
            SecondWindow.secondWindowInstance.changeSecondWindow(selectScreen, startViewController: waitViewController)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // cellを押した時に呼ばれる
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var status = ""
        switch(indexPath.row) {
            // 小テスト（全体）を押した時
        case 0:
            self.performSegueWithIdentifier("goCourceTableViewSegue", sender: nil)
            status = "QuizAll"
            
            // 小テスト（指名）を押した時
        case 1:
            self.performSegueWithIdentifier("goNominationQuizSegue", sender: nil)
            status = "QuizNomination"
            
            // クリッカー
        case 2:
            self.performSegueWithIdentifier("goClickerTypeSelectViewControllerSegue", sender: nil)
            status = "Clicker"
            
            // 調べ学習
        case 3:
            self.performSegueWithIdentifier("goWebViewSegue", sender: nil)
            status = "Web"
            
            // 終了
        case 4:
            dispatch_async(dispatch_get_main_queue(), {
                
                //AlertController作成
                var classFinishAlertView = UIAlertController(title: "授業を終了します", message: "", preferredStyle: .Alert)
                
                //OKボタンを押した時
                var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.performSegueWithIdentifier("goTitleSegue", sender: nil)
                }
                
                //OKボタンを押した時
                var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                }
                
                // Add the actions
                classFinishAlertView.addAction(okAction)
                classFinishAlertView.addAction(cancelAction)
                
                //Viewを見せる
                self.presentViewController(classFinishAlertView, animated: true, completion: nil)
                
            })
            
        default:
            status = "Wait"
        }
        
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.statusUUID, sendData: status)
    }
    
    // ページ遷移をする際に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goCourceTableViewSegue") {
        }
        if (segue.identifier == "NominationQuizSegue") {
            println("ちゃんと呼ばれています")
        }
    }
    
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    
}