////
////  ViewController.swift
////  SlideMenuControllerSwift
////
////  Created by Yuji Hato on 12/3/14.
////
//
//import UIKit
//
//class MainViewController: UIViewController {
//    
//    let notificationCenter = NSNotificationCenter.defaultCenter()
//    
//    @IBOutlet weak var testButton: UIButton!
//    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //デリゲートの取得
//        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton
//        
////        //学生データの初期設定
////        //学生の名前
////        let studentName:[String] = ["弓削太郎","弓削二郎","弓削三郎","弓削四郎","弓削五郎"]
////        let defaultStudentState:[Bool] = [true,false,false,true,false]
////        for(var i=0; studentName.count>i; i++){
////            StudentInfoBox.studentInfoBoxInstance.studentInfoBox.append(StudentInfo(userName: studentName[i], userID: "i"+String(i+1), idNumber: i+1, absent: defaultStudentState[i], lock:false))
////        }
//    }
//    
//    //+をおした時
//    @IBAction func plusBadgeNumber(sender: AnyObject) {
//        println("+をおした")
//        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.addBadgeNumber()
//        rigahtTablesViewReload()
//    }
//    
//    
//    
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
//    @IBAction func puchNextView(sender: AnyObject) {
//        performSegueWithIdentifier("goToNextView",  sender: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    /*
//    制御テーブルビューを出す
//    */
//    @IBAction func openRightMenu(sender: AnyObject) {
//        self.toggleRight()
//    }
//    
//}
//
