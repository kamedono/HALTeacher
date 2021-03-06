//
//  RightViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum RightMenu: Int {
    case Monitor = 0
    case Lock
    case Connect
    case Sound
    //    case Setting
    case Finish
    
    case Main
}


protocol RightMenuProtocol : class {
    func changeViewController(menu: RightMenu)
}


/**
ホーム画面に行って欲しいときに通知されるデリゲート
*/
@objc protocol RightViewControllerDelegate {
    /**
    ホーム画面に行って欲しいときに通知されるデリゲート
    */
    optional func goTopTableViewSegue()
}

class RightViewController : UIViewController, RightMenuProtocol {
    @IBOutlet weak var tableView: UITableView!
    var menusR = ["監視", "端末ロック", "接続確認","効果音", "コンテンツを終了する"]
    var mainViewController: UIViewController!
    var monitoringViewController: UIViewController!
    var lockViewController: UIViewController!
    var connectionConfirmationViewController: UIViewController!
    var soundViewController: UIViewController!
    var settingViewController: UIViewController!
    var finishSubjectViewController: UIViewController!
    
    //バッジラベル
    var badgeLabel:UILabel!
    
    var prevViewController : UIViewController!

    // デリゲート宣言
    var delegate: RightViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let monitoringViewController = storyboard.instantiateViewControllerWithIdentifier("MonitoringViewController") as! MonitoringViewController
        self.monitoringViewController = UINavigationController(rootViewController: monitoringViewController)
        
        let lockViewController = storyboard.instantiateViewControllerWithIdentifier("LockViewController") as! LockViewController
        self.lockViewController = UINavigationController(rootViewController: lockViewController)
        
        let connectionConfirmationViewController = storyboard.instantiateViewControllerWithIdentifier("ConnectionConfirmationViewController") as! ConnectionConfirmationViewController
        self.connectionConfirmationViewController = UINavigationController(rootViewController: connectionConfirmationViewController)
        
        let soundViewController = storyboard.instantiateViewControllerWithIdentifier("SoundViewController") as! SoundViewController
        self.soundViewController = UINavigationController(rootViewController: soundViewController)
        
        let settingViewController = storyboard.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        self.settingViewController = UINavigationController(rootViewController: settingViewController)
        
        let finishSubjectViewController = storyboard.instantiateViewControllerWithIdentifier("FinishSubjectViewController") as! FinishSubjectViewController
        self.finishSubjectViewController = UINavigationController(rootViewController: finishSubjectViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menusR.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RightBaseTableViewCell = RightBaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: RightBaseTableViewCell.identifier)
        cell.backgroundColor = UIColor(red: 64/255, green: 170/255, blue: 239/255, alpha: 1.0)
        cell.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        cell.textLabel?.text = menusR[indexPath.row]
        if(menusR[indexPath.row] == "接続確認"){
            //バッジナンバーが0以上だったら
            if(ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.badgeNumber>0){
                //バッジ作成
                var fontSize:CGFloat = 18
                var CircleSize:CGFloat = 23
                
                badgeLabel = UILabel()
                badgeLabel.text = String(ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.badgeNumber)
                badgeLabel.font = UIFont.systemFontOfSize(fontSize)
                badgeLabel.layer.backgroundColor = UIColor.redColor().CGColor
                badgeLabel.textColor = UIColor.whiteColor()
                badgeLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
                badgeLabel.layer.cornerRadius = 12
                badgeLabel.textAlignment = NSTextAlignment.Center
                
                var frame:CGRect = badgeLabel.frame
                frame.size.height = CircleSize
                frame.size.width = CircleSize
                badgeLabel.frame = frame
                cell.accessoryView = badgeLabel
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = RightMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changeViewController(menu: RightMenu) {
        // 一個前のViewControllerを保存
        self.prevViewController = self.slideMenuController()?.mainViewController
        switch menu {
        case .Monitor:
            self.slideMenuController()?.changeMainViewController(self.monitoringViewController, close: true)
            break
        case .Lock:
            self.slideMenuController()?.changeMainViewController(self.lockViewController, close: true)
            break
        case .Connect:
            self.slideMenuController()?.changeMainViewController(self.connectionConfirmationViewController, close: true)
            break
        case .Sound:
            self.slideMenuController()?.changeMainViewController(self.soundViewController, close: true)
            break
            //        case .Setting:
            //            self.slideMenuController()?.changeMainViewController(self.settingViewController, close: true)
            //            break
        case .Finish:
            dispatch_async(dispatch_get_main_queue(), {
                // windowKeyの取得？
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDel.window?.makeKeyAndVisible()

                // AlertController作成
                var downloadingAlertView = UIAlertController(title: "コンテンツを終了しますか？", message: "", preferredStyle: .Alert)
                
                // わかったボタン
                var acceptAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    Timer.timerInstance.stopTimer()
                    BGMManager.bgmManagerInstance.stopMusic()
                    
                    CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.statusUUID, sendData: "finish")
                    
                    self.delegate?.goTopTableViewSegue?()
                    self.closeRight()
                }
                // わかったボタン
                var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                }
                // AlertControllerにindicatorを追加させる
                downloadingAlertView.addAction(acceptAction)
                downloadingAlertView.addAction(cancelAction)
                let topview = getTopViewController()
                // Viewを見せる
                topview.presentViewController(downloadingAlertView, animated: true, completion: nil)
            })
            //            self.slideMenuController()?.changeMainViewController(self.finishSubjectViewController, close: true)
            //            break
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        default:
            break
        }
    }
}
