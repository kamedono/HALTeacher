//
//  GoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    // 戻るボタンを用意
    var backdButton: UIBarButtonItem!
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var terminator: UIButton!
    @IBOutlet weak var requiem: UIButton!
    @IBOutlet weak var tetete: UIButton!
    @IBOutlet weak var selectMusicLabel: UILabel!
    
    //    var buttonList = ["tetete","terminator","requiem","tetete"]
    var buttonList:[UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定画面"
        //初期化
        backdButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "pushBuckButton")
        //UIBarButtonItemをナビゲーションバーの左側に設置
        self.navigationItem.leftBarButtonItem = backdButton

        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()

        //ボタンリストを初期化
        buttonList = [terminator,requiem,tetete]
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        println("呼ばれた")
        super.viewWillAppear(animated)
        // 保存しているBGMの取得
        let result : String? = userDefaults.objectForKey("quizBGM") as! String?
        
        if(result == nil){
            //BGMが選択されてない時はデフォルトでテッテッテー
            userDefaults.setObject("tetete", forKey: "quizBGM")
            userDefaults.synchronize()
            tetete.layer.borderWidth = 1     //枠線
            selectMusicLabel.text = "テッテッテー"
        }else{
            switch result! {
            case "terminator":
                println("た")
                selectMusicLabel.text = "ターミネータ"
            case "requiem":
                println("れ")
                selectMusicLabel.text = "レクイエム"
            default:
                break
            }
        }
    }
    
    @IBAction func pushTerminator(sender: AnyObject) {
        userDefaults.setObject("terminator", forKey: "quizBGM")
        userDefaults.synchronize()
        changeButtonEffect()
        selectMusicLabel.text = "ターミネータ"
        
        println("terminatorStart!")
        BGMManager.bgmManagerInstance.playMusic()
    }
    
    @IBAction func pushRequiem(sender: AnyObject) {
        userDefaults.setObject("requiem", forKey: "quizBGM")
        userDefaults.synchronize()
        changeButtonEffect()
        selectMusicLabel.text = "レクイエム"
        
        println("requiemStart!")
        BGMManager.bgmManagerInstance.playMusic()
    }
    
    @IBAction func pushTetete(sender: AnyObject) {
        userDefaults.setObject("tetete", forKey: "quizBGM")
        userDefaults.synchronize()
        changeButtonEffect()
        selectMusicLabel.text = "テッテッテー"
        
        println("teteteStart!")
        BGMManager.bgmManagerInstance.playMusic()
    }
    
    
    func changeButtonEffect(){
        let anyObjQuizBGM : AnyObject! = userDefaults.objectForKey("quizBGM")
        var quizBGM = anyObjQuizBGM as! String
        for(var i=0;i<buttonList.count;i++){
            if(quizBGM == buttonList[i].restorationIdentifier){
                buttonList[i].layer.borderWidth = 1
            }else{
                buttonList[i].layer.borderWidth = 0
            }
        }
    }
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
    }
    
    
    
}