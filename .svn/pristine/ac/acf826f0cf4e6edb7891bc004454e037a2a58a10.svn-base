//
//  GoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

//ZoomUpMonitoringViewControllerに行ったことを記憶
var zoomUpMonitoringViewControllerFlag:Bool = false

class MonitoringViewController: UIViewController, NSURLSessionDownloadDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CoreCentralManagerDelegate {
    
    // 戻るボタンの宣言
    var backdButton: UIBarButtonItem!
    
    // 更新ボタン
    var refreshButton: UIBarButtonItem!
    
    //選択した学生の配列番号を保存
    var selectStudentNumber:Int!
    
    //CollevtionViewの宣言
    @IBOutlet weak var collectionView: UICollectionView!
    
    //ダウンロードした回数を記憶
    var downloadCount = 0
    let serverURL:String = MoodleInfo.moodleInfoInstance.moodleURL + "/screenShot/"
    
    //ダウンロードした画像データを保持
    var screenShotDataBox :[NSData] = []
    
    //接続失敗した時の画像
    let failImageData:NSData = UIImagePNGRepresentation(UIImage(named: "notConectionIconx900.png"))

    //ダウンロード確認フラグ(ダウンロード失敗しているハズなのになぜかdownloadTaskが呼ばれる問題対策)
    var downloadSuccessCheck:Bool = false

    //ダウンロード中のalertView
    var downloadingAlertView :UIAlertController!
    
    //indexPathを記憶
    var indexPathList :[NSIndexPath] = []
    
    //更新したいindexPathを記憶
    var reloadIndexPath :[NSIndexPath] = [NSIndexPath(index: 0)]
    
    //ダウンロード完了のフラグ
    var downloadImageFlag = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーのタイトルを設定
        self.title = "モニター画面"
        
        // ナビゲーションバーにあるバックボタンの作成
        backdButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "pushBuckButton")

        // 更新ボタン
        refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "pushRefreshButton")
        
        // ナビゲーションバーのサイズを変更
        self.navigationController?.navigationBar.frame.size.height = 44.0
        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()

        // UIBarButtonItemをナビゲーションバーの左側に設置
        self.navigationItem.leftBarButtonItem = backdButton
        self.navigationItem.rightBarButtonItem = refreshButton
        
        zoomUpMonitoringViewControllerFlag = true
        println("studentList :\(StudentInfoBox.studentInfoBoxInstance.studentList.count)")
        
        // Screenshotの配列を初期化
        for(var i=0; i<StudentInfoBox.studentInfoBoxInstance.studentList.count; i++){
            screenShotDataBox.append(failImageData)
            indexPathList.append(NSIndexPath(index: 0))
        }
        
        // Delegate設定
        CoreCentralManager.coreCentralInstance.delegate = self

        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if(zoomUpMonitoringViewControllerFlag == false){
//            //            createAlertView()
////            startDownloadImage()
//        }
//        zoomUpMonitoringViewControllerFlag = false
        //        collectionView.reloadData()
        
        
        // SSアップロード通知
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.monitoringUUID, sendData: nil)
    }
    
    
//    func startDownloadImage(){
//        // カウンターを0にする
//        downloadCount = 0
//        
//        // NSURLの通信コンフィグ設定
//        let myConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        
//        // Sessionを作成する.
//        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
//        
//        // ダウンロード先のURLからリクエストを生成.
//        let myURL:NSURL = NSURL(string: serverURL+StudentInfoBox.studentInfoBoxInstance.studentList[0].userID+".jpg")!
//        let myRequest:NSURLRequest = NSURLRequest(URL: myURL)
//
//        // ダウンロードタスクを生成.
//        let myTask:NSURLSessionDownloadTask = mySession.downloadTaskWithRequest(myRequest)
//
//        // タスクを実行.
//        myTask.resume()
//    }
    
    
    /**
    実装用
    */
    func ssUploadFinish(userID:String){
        // 学生のindex番号を取得
        let studentNumber = StudentInfoBox.studentInfoBoxInstance.getStudentIndex(userID)

        // NSURLの通信コンフィグ設定
        let myConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()

        // Sessionを作成する.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        // ダウンロード先のURLからリクエストを生成.
        let myURL:NSURL = NSURL(string: serverURL+userID+".jpg")!
        let myRequest:NSURLRequest = NSURLRequest(URL: myURL)
        
        // ダウンロードタスクを生成.
        let myTask: NSURLSessionDownloadTask = mySession.downloadTaskWithRequest(myRequest, completionHandler: {
            (data: NSURL!, response: NSURLResponse!, error: NSError!) in
            if error == nil {
                println("ダウンロードが成功しました")
                let getData: NSData = NSData(contentsOfURL: data, options: NSDataReadingOptions.DataReadingMappedAlways, error: nil)!
                self.screenShotDataBox[studentNumber] = getData
            }else{
                println("ダウンロードが失敗しました")
                self.screenShotDataBox[studentNumber] = self.failImageData
            }
            //更新させるのは一つずつ
            self.reloadIndexPath[0] = self.indexPathList[studentNumber]
            //ダウンロード完了
            self.downloadImageFlag = true
            //ダウンロードしたセルだけリロード
            self.collectionView.reloadItemsAtIndexPaths(self.reloadIndexPath)
            
        })
        
        // タスクを実行.
        myTask.resume()
    }
    
    /*
    [実装用]
    ダウンロード終了時に呼び出されるデリゲート.(成功した時にしか呼ばれないハズ！)
    ダウンロードした画像データをscreenShotDataBoxに保存する
    */
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
//        var data:NSData = NSData(contentsOfURL: location, options: NSDataReadingOptions.DataReadingMappedAlways, error: nil)!
//        downloadSuccessCheck = true
//        //screenShotDataBox.append(data)
//        screenShotDataBox[StudentNumber] = data
//        println("location \(location)")
//        println("ダウンロード完了")
    }

    /**
    [実装用]
    ダウンロード結果が成功・失敗したことを知らせる
    基本didFinishの後に呼ばれる（探すデータがない場合は順番が入れ替わる時がある）
    */
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
//        if error == nil {
//            println("ダウンロードが成功しました")
//        }else{
//            println("ダウンロードが失敗しました")
//            screenShotDataBox[StudentNumber] = failImageData
//        }
//
//        //更新させるのは一つずつ
//        reloadIndexPath[0] = indexPathList[StudentNumber]
//        //ダウンロード完了
//        downloadImageFlag = true
//        //ダウンロードしたセルだけリロード
//        self.collectionView.reloadItemsAtIndexPaths(reloadIndexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pushRefreshButton() {
        //全学生にスクショ取らせる
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.monitoringUUID, sendData: nil)
    }
    
    /*
    Cellが選択された際に呼び出される
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        println("Num: \(indexPath.row)")
        selectStudentNumber = indexPath.row
        zoomUpMonitoringViewControllerFlag = true
        self.performSegueWithIdentifier("ZoomUpMonitoringViewControllerSegue", sender: self)
    }
    
    /*
    Cellの総数を返す
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenShotDataBox.count
    }
    
    /*
    Cellに値を設定する
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : MonitoringViewControllerCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MonitoringViewControllerCell
        
        //indicatorの作成
        var indicator :UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        //indicatorの位置決め
        indicator.center = CGPointMake(cell.frame.width/2 ,cell.frame.height/2)
        
        //配列番号を記憶
        indexPathList[indexPath.row] = indexPath
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            //indicatorを回す
            if(self.downloadImageFlag){
                indicator.stopAnimating()
            }else{
                //indicatorを回す
                indicator.startAnimating()
                cell.addSubview(indicator)
            }
            // 画像リサイズ
            var image = UIImage(data: self.screenShotDataBox[indexPath.row])
            let resizedSize = CGSizeMake(263 , 210)
            UIGraphicsBeginImageContext(resizedSize)
            image?.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
            let resizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            image = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                cell.scrrenShotImage.image = resizedImage
                //StudentInfoBox.studentInfoBoxInstance.studentInfoBox[indexPath.row].userID
                cell.nameLabel.text = StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].userID+"   "+StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].name
                if(StudentInfoBox.studentInfoBoxInstance.studentList[indexPath.row].lock){
                    cell.lockLabel.text = "ロック中"
                }else{
                    cell.lockLabel.text = ""
                }
                cell.layer.borderWidth = 1
            })
        })
        return cell
    }
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
    }
    
    /**
    セグエ移動の値渡し
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ZoomUpMonitoringViewControllerSegue") {
            
            let zoomUpMonitoringViewController : ZoomUpMonitoringViewController = segue.destinationViewController as!  ZoomUpMonitoringViewController
            zoomUpMonitoringViewController.selectStudentNumber = selectStudentNumber
            zoomUpMonitoringViewController.screenShotImageData = screenShotDataBox[selectStudentNumber]
        }
    }
    
}