//  GoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import AVFoundation
import UIKit


class SoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate{
    // 戻るボタンを用意
    var backdButton: UIBarButtonItem!
    
    // 効果音
    var correctAudio : AVAudioPlayer!
    var incorrectAudio : AVAudioPlayer!
    var alarmAudio : AVAudioPlayer!
    
    @IBOutlet weak var tableView: UITableView!
    
    // 選択したセル情報
    var selectStudent:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectStudent = [Bool](count: StudentInfoBox.studentInfoBoxInstance.studentList.count, repeatedValue: false)
        
        //        //再生する音源の作成
        //        //音楽ファイルのパス取得
        //        let correctAudioFilePath : NSString = NSBundle.mainBundle().pathForResource("Seikai", ofType: "mp3")!
        //        let correctAudiofileURL : NSURL = NSURL(fileURLWithPath: correctAudioFilePath as String)!
        //
        //        //AVAudioPlayerのインスタンス化.
        //        let correctAudio = AVAudioPlayer(contentsOfURL: correctAudiofileURL, error: nil)
        //
        //        //AVAudioPlayerのデリゲートをセット
        //        correctAudio.delegate = self
        //
        //        let incorrectAudioFilePath : NSString = NSBundle.mainBundle().pathForResource("Huseikai", ofType: "mp3")!
        //        let incorrectAudiofileURL : NSURL = NSURL(fileURLWithPath: incorrectAudioFilePath as String)!
        //
        //        //AVAudioPlayerのインスタンス化.
        //        incorrectAudio = AVAudioPlayer(contentsOfURL: incorrectAudiofileURL, error: nil)
        //
        //        //AVAudioPlayerのデリゲートをセット
        //        incorrectAudio.delegate = self
        //
        //        let alarmAudioFilePath : NSString = NSBundle.mainBundle().pathForResource("alarm10s", ofType: "mp3")!
        //        let alarmAudiofileURL : NSURL = NSURL(fileURLWithPath: alarmAudioFilePath as String)!
        //
        //        //AVAudioPlayerのインスタンス化.
        //        alarmAudio = AVAudioPlayer(contentsOfURL: alarmAudiofileURL, error: nil)
        //
        //        //AVAudioPlayerのデリゲートをセット
        //        alarmAudio.delegate = self
        
        self.title = "効果音画面"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsMultipleSelection = true
        //        self.tableView.allowsMultipleSelectionDuringEditing = true
        //        self.tableView.deselectRowAtIndexPath(<#indexPath: NSIndexPath#>, animated: <#Bool#>)
        
        //初期化
        backdButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "pushBuckButton")
        //UIBarButtonItemをナビゲーションバーの左側に設置
        self.navigationItem.leftBarButtonItem = backdButton
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // リストの件数を返す
        return StudentInfoBox.studentInfoBoxInstance.studentList.count
    }
    
    
    /**
    セルを内容を変更する
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        
        //        if(StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].lock){
        //            cell.backgroundColor = UIColor.redColor()
        //            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //        }else{
        //            cell.backgroundColor = UIColor.whiteColor()
        //        }
        
        return cell
    }
    
    
    /**
    セルをタッチした時
    選択した時
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectStudent[indexPath.row] = true
    }
    
    /**
    選択解除した時
    */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectStudent[indexPath.row] = false
    }
    
    /**
    選択解除した時
    */
    //    func tableview(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
    //        println("解除")
    //        selectStudent[indexPath.row] = false
    //    }
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
    }
    
    
    @IBAction func pushCorrectButton(sender: AnyObject) {
        sendSE("Seikai")
    }
    @IBAction func pushInCorrectButton(sender: AnyObject) {
        sendSE("Huseikai")
    }
    @IBAction func pushGetUp(sender: AnyObject) {
        sendSE("alarm10s")
    }
    
    
    /**
    SEの通知
    */
    func sendSE(filename: String) {
        var studentUUIDList: [NSUUID] = []
        println(StudentInfoBox.studentInfoBoxInstance.studentList.count)
        for(var i=0; StudentInfoBox.studentInfoBoxInstance.studentList.count > i; i++) {
            if selectStudent[i] {
                //                StudentInfoBox.studentInfoBoxInstance.studentList[i].lock = true
                studentUUIDList.append(StudentInfoBox.studentInfoBoxInstance.studentList[i].UUID!)
            }
        }
        
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.soundEffectUUID, sendData: filename, studentUUIDList: studentUUIDList)
    }
    
}