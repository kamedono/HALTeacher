//
//  WebViewController.swift
//  HALWKWebView
//
//  Created by マイコン部 on 2015/09/17.
//  Copyright (c) 2015年 マイコン部. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WKNavigationDelegate, WKUIDelegate, RightViewControllerDelegate, CoreCentralManagerDelegate {
    
    
    @IBOutlet weak var webToolBar: UIToolbar!
    
    //戻るボタン
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    
    //進むボタン
    @IBOutlet weak var forwardButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var keyButton: UIBarButtonItem!
    
    // 制御ボタン
    @IBOutlet weak var controllerButton: ControllerBadgeButtonView!
    
    //Web内容を表示
    var webview : WKWebView?
    
    var urlBar : UIView?
    var urlBarForm : UIView?
    var urlTextField : UITextField?
    
    //再読み込みボタン
    var reloadButton : UIButton?
    
    //読み込み停止ボタン
    var stopButton : UIButton?
    
    //URLテキストフィールド消去ボタン
    var textDeleteButton : UIButton?
    
    //ブックマーク管理
    var bookMarkButton : UIButton?
    var bookMarkFlag: Bool = false
    
    
    //学習制御
    //    var keyCloseButton : UIButton?
    //    var keyOpenButton : UIButton?
    
    //cellをviewをするときに使う
    var cellControll : Int = 0
    
    
    //進捗状況
    var estimatedProgress: Double = 0.0
    
    //ProgressViewの宣言
    var testProgressView: UIProgressView!
    
    
    //encodeしたい文字列を入れる変数
    var encodeInput: String = ""
    
    //encodeした文字列を入れる変数
    var encoded: String = ""
    
    //URLとかTitleとか
    var list : WKBackForwardList!
    
    // userDefault
    let historyDefaults = NSUserDefaults.standardUserDefaults()
    let favoriteDefaults = NSUserDefaults.standardUserDefaults()
    
    let favoriteURLDefaults = NSUserDefaults.standardUserDefaults()
    
    //Tableの表示非表示フラグ
    var historyFlag: Int = 0
    var favoriteFlag: Int = 0
    
    var keyFlag : Int = 0
    
    // ロックフラグ
    var lock = false
    
    var historyItems: [String]! {
        get { return (historyDefaults.stringArrayForKey("history") as? [String]) ?? [] }
        set { historyDefaults.setObject(newValue, forKey: "history") }
    }
    
    var favoriteTitleList: [String]! {
        get { return (favoriteDefaults.stringArrayForKey("favoriteTitle") as? [String]) ?? [] }
        set { favoriteDefaults.setObject(newValue, forKey: "favoriteTitle") }
    }
    
    var favoriteURLList: [String]! {
        get { return (favoriteURLDefaults.stringArrayForKey("favoriteURL") as? [String]) ?? [] }
        set { favoriteURLDefaults.setObject(newValue, forKey: "favoriteURL") }
    }
    
    //    var historyItems : Array<String>!
    
    
    //履歴テーブル
    var historyTable: UITableView!
    
    //お気に入りテーブル
    var favoriteTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationBarを消す
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //  デバイスのCGRectを取得
        var deviceBound : CGRect = UIScreen.mainScreen().bounds
        
        
        
        
        // ----------テーブルビューの設定----------
        //生成
        historyTable = UITableView(frame: CGRectMake(0, 0, deviceBound.size.width/3, deviceBound.size.height))
        favoriteTable = UITableView(frame: CGRectMake(0, 0, deviceBound.size.width/3, deviceBound.size.height))
        
        //スタート位置にtableviewをセット
        self.historyTable.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)
        self.favoriteTable.transform = CGAffineTransformMakeTranslation(0 - self.view.frame.width/1.5, 60)
        
        // Cell名の登録をおこなう.
        historyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        favoriteTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        
        // DataSourceの設定をする.
        historyTable.dataSource = self
        favoriteTable.dataSource = self
        
        // Delegateを設定する.
        historyTable.delegate = self
        favoriteTable.delegate = self
        
        //tag追加 (一応、他のタグとかぶらないようにしとく)
        historyTable.tag = 55
        favoriteTable.tag = 66
        
        
        //tableviewを追加する
        self.view.addSubview(favoriteTable)
        self.view.addSubview(historyTable)
        
        
        
        
        // ----------webViewの設定----------
        
        
        //  WKWebView
        //Viewの大きさ
        self.webview = WKWebView(frame: CGRectMake(0, 60, deviceBound.size.width, deviceBound.size.height - 60))
        
        //navigationのデリゲート設定
        self.webview?.navigationDelegate = self
        
        //viewにwebを出す
        self.webview?.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.google.co.jp")!))
        self.view.addSubview(self.webview!)
        
        //UIDelegateを継承
        self.webview!.UIDelegate = self
        
        
        
        
        // ----------URLのテキストボックス設定----------
        
        //URLBarの大きさ、色透過具合
        self.urlBar = UIView(frame: CGRectMake(deviceBound.size.width/6, 20, deviceBound.size.width/1.7, 40))
        let urlBarBorderColor : CGColorRef = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0).CGColor
        let urlBarBorder : CALayer = CALayer()
        urlBarBorder.frame = CGRectMake(deviceBound.size.width/6, 39.5, deviceBound.size.width/1.7, 0.5)
        urlBarBorder.backgroundColor = urlBarBorderColor
        self.urlBar?.layer.addSublayer(urlBarBorder)
        self.view.addSubview(self.urlBar!)
        
        //  URLBarのテキストフォーム背景
        self.urlBarForm = UIView(frame: CGRectMake(10, 2, deviceBound.size.width/1.7 , 30))
        self.urlBarForm?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        //はしっこの角丸の度合い
        self.urlBarForm?.layer.cornerRadius = 6
        self.urlBarForm?.clipsToBounds = true
        self.urlBar?.addSubview(self.urlBarForm!)
        
        //  URLBarのテキストフォーム,テキストフォームのwidthを変更することで入力できる範囲を制御
        self.urlTextField = UITextField(frame: CGRectMake(32, 1, self.urlBarForm!.frame.width - 86, self.urlBarForm!.frame.height))
        //フォントサイズ
        self.urlTextField?.font = UIFont.systemFontOfSize(16)
        
        
        //TextFieldのデリゲート設定
        urlTextField?.delegate = self
        
        //TextFieldの文字はセンターに
        urlTextField?.textAlignment = .Center
        
        //TextFieldに何も書かれてないとき
        urlTextField?.placeholder = "URLまたは検索語句を入力してください"
        
        //キーボードの種類
        self.urlTextField?.keyboardType = .URL
        
        //バーフォームにテキストフィールドを置く
        self.urlBarForm?.addSubview(self.urlTextField!)
        
        //ボタンの設置
        buttonFormat()
        
        
        // ----------読み込みバーの設定----------
        
        //estimatedProgress
        webview?.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        
        // ProgressViewを作成する、バーの長さ
        testProgressView = UIProgressView(frame: CGRectMake(deviceBound.size.width/6+10, 50, deviceBound.size.width/1.7, 10))
        
        //色
        testProgressView.progressTintColor = UIColor.blueColor()
        testProgressView.trackTintColor = UIColor.grayColor()
        
        // 座標を設定する、バーの位置
        //        testProgressView.layer.position = CGPoint(x: deviceBound.size.width/2, y: 50)
        
        // バーの高さを設定する(横に1.0倍,縦に2.0倍).
        testProgressView.transform = CGAffineTransformMakeScale(1.0, 1.5)
        
        // Viewに追加する.
        self.urlBarForm?.addSubview(testProgressView)
        
        
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        //historyTable = UITableView(frame: CGRect(x: deviceBound.size.width/1.5, y: 60, width: deviceBound.size.width/3, height: deviceBound.size.height))
        
    }
    
    /**
    ボタンの登録
    */
    func buttonFormat(){
        
        //  ReloadButton
        let reloadImage : UIImage? = UIImage(named: "reloadButton.png")
        self.reloadButton = UIButton(frame: CGRectMake(self.urlBarForm!.frame.minX, 6, 20, 20))
        self.reloadButton?.setImage(reloadImage, forState: .Normal)
        self.reloadButton?.addTarget(self, action: "touchReloadButton:", forControlEvents: .TouchUpInside)
        self.urlBarForm?.addSubview(self.reloadButton!)
        
        
        //読み込み停止ボタン
        let stopImage : UIImage? = UIImage(named: "batuButton.png")
        self.stopButton = UIButton(frame: CGRectMake(self.urlBarForm!.frame.minX, 6, 20, 20))
        self.stopButton?.setImage(stopImage, forState: .Normal)
        self.stopButton?.addTarget(self, action: "touchStopButton:", forControlEvents: .TouchUpInside)
        
        
        //テキスト消去ボタン
        let textDelImage : UIImage? = UIImage(named: "textDeleteButton.png")
        self.textDeleteButton = UIButton(frame: CGRectMake(self.urlBarForm!.frame.width - 57, 6, 20, 20))
        self.textDeleteButton?.setImage(textDelImage, forState: .Normal)
        self.textDeleteButton?.addTarget(self, action: "touchTextDeleteButton:", forControlEvents: .TouchUpInside)
        self.urlBarForm?.addSubview(self.textDeleteButton!)
        
        
        // ブックマークボタン
        let bookMarkOnImage : UIImage? = UIImage(named: "bookMarkOnButton.png")
        self.bookMarkButton = UIButton(frame: CGRectMake(self.urlBarForm!.frame.width - 35, 2, 35, 25))
        self.bookMarkButton?.setImage(bookMarkOnImage, forState: .Normal)
        self.bookMarkButton?.addTarget(self, action: "touchBookMarkOnButton:", forControlEvents: .TouchUpInside)
        self.urlBarForm?.addSubview(self.bookMarkButton!)
        
        
        //        let bookMarkOffImage : UIImage? = UIImage(named: "bookMarkOffButton.png")
        //        self.bookMarkOffButton = UIButton(frame: CGRectMake(self.urlBarForm!.frame.width - 25, 4, 20, 20))
        //        self.bookMarkOffButton?.setImage(bookMarkOffImage, forState: .Normal)
        //        self.bookMarkOffButton?.addTarget(self, action: "touchBookMarkOffButton:", forControlEvents: .TouchUpInside)
        
        
        //学生リンク制御ボタン
        //        let keyCloseImage : UIImage? = UIImage(named: "keyCloseButton.png")
        //        self.keyCloseButton = UIButton(frame: CGRectMake(self.webToolBar!.frame.width - 40, 20, 32, 32))
        //        self.keyCloseButton?.setImage(keyCloseImage, forState: .Normal)
        //        self.keyCloseButton?.addTarget(self, action: "touchKeyCloseButton:", forControlEvents: .TouchUpInside)
        //        self.webToolBar?.addSubview(self.keyCloseButton!)
        //
        //
        //        let keyOpenImage : UIImage? = UIImage(named: "keyOpenButton.png")
        //        self.keyOpenButton = UIButton(frame: CGRectMake(self.webToolBar!.frame.width - 40, 20, 32, 32))
        //        self.keyOpenButton?.setImage(keyOpenImage, forState: .Normal)
        //        self.keyOpenButton?.addTarget(self, action: "touchKeyOpenButton:", forControlEvents: .TouchUpInside)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // 制御のポッパーを出すためのデリゲート
        ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.delegate = self.controllerButton
        
        CoreCentralManager.coreCentralInstance.delegate = self
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rightViewController?.delegate = self
    }
    
    //estimeのパス
    deinit {
        webview?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    //Pathを受け取ったときの処理
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        switch keyPath {
        case "estimatedProgress":
            if let progress = change[NSKeyValueChangeNewKey] as? Double {
                
                //現在の状態を取得
                estimatedProgress = progress
                testProgressView.setProgress(Float(webview!.estimatedProgress), animated: true)
            }
            
        default:
            break
        }
    }
    
    //  リロードボタンが押された時の処理
    func touchReloadButton(button : UIButton) {
        self.webview?.reload()
        
        //一応
        reloadButton?.removeFromSuperview()
        self.urlBarForm?.addSubview(self.stopButton!)
        
        println("Reload Start!")
    }
    
    //ストップボタンが押された時の処理
    func touchStopButton(button : UIButton) {
        self.webview?.stopLoading()
        
        stopButton?.removeFromSuperview()
        self.urlBarForm?.addSubview(self.reloadButton!)
        
        // ステータスバーから読み込み中表示を消す
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //Progeress0
        estimatedProgress = 0
        
        //progressViewも消す
        testProgressView.removeFromSuperview()
        
        println("Reload Stop!")
    }
    
    //テキストデリートボタンが押された時の処理
    func touchTextDeleteButton(button : UIButton) {
        
        urlTextField?.text = ""
        println("URL Text Delete!")
    }
    
    
    // ブックマークONボタン
    func touchBookMarkOnButton(button : UIButton) {
        cellControll = 0
        let bookMarkOffImage : UIImage? = UIImage(named: "bookMarkOffButton.png")
        
        // ブックマークされている場合
        if bookMarkFlag == true {
            println("とうろくかいじょ！")
            let bookMarkOnImage : UIImage? = UIImage(named: "bookMarkOnButton.png")
            
            
            if (list.currentItem != nil) {
                let title = self.list.currentItem!.title!
                
                // listの中にある同じタイトルを取得し、削除
                for (index, favoriteTitle) in enumerate(self.favoriteTitleList) {
                    if title == favoriteTitle {
                        self.favoriteTitleList.removeAtIndex(index)
                        self.favoriteURLList.removeAtIndex(index)
                        //                        self.favoriteTitleList.removeAtIndex(index)
                        
                        //画像切り替え
                        self.bookMarkButton?.setImage(bookMarkOnImage, forState: .Normal)
                        bookMarkFlag = false
                        
                        break
                    }
                }
            }
        }
            // ブックマークされていない場合
        else {
            println("とうろく！")
            // 現在開いてるページ
            if (list?.currentItem != nil) {
                self.favoriteTitleList.insert(self.list.currentItem!.title!, atIndex: 0)
                self.favoriteURLList.insert(self.list.currentItem!.URL.description, atIndex: 0)
                println(self.list.currentItem!.title!)
                
                //画像切り替え
                self.bookMarkButton?.setImage(bookMarkOffImage, forState: .Normal)
                bookMarkFlag = true
            }
        }
        
        favoriteTable.reloadData()
        // 画像変更
        //        self.bookMarkButton?.setImage(bookMarkOnImage, forState: .Normal)
        
        //        self.bookMarkButton?.setImage(bookMarkOffImage, forState: .Normal)
        
        
        //        bookMarkButton?.removeFromSuperview()
        //        self.urlBarForm?.addSubview(self.bookMarkButton!)
        
    }
    
    // 学生ロック
    @IBAction func keyButtonAction(backSender: UIBarButtonItem) {
        if(keyFlag == 0) {
            self.keyButton.image = UIImage(named: "keyOpenButton.png")
            self.keyButton.tintColor = UIColor.hexStr("#FFFE51", alpha: 1)
            
            self.lock = true
            keyFlag = 1
            
            WebInfo.webInfoInstance.lockStatus = "lock"
            CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.webUUID, sendData: nil)
        }
            
        else {
            self.keyButton.image = UIImage(named: "keyCloseButton.png")
            self.keyButton.tintColor = UIColor.hexStr("#9DA09F", alpha: 1)
            
            self.lock = false
            keyFlag = 0
            
            WebInfo.webInfoInstance.lockStatus = "unlock"
            CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.webUUID, sendData: nil)
        }
    }
    
    // 制御ボタン
    @IBAction func pushControllerButton(sender: AnyObject) {
        self.toggleRight()
    }
    
    // 戻るボタン
    @IBAction func backButtonItem(backSender: UIBarButtonItem) {
        
        //ブラウザ戻るお
        webview!.goBack()
        println("Go Back!")
    }
    
    // 進むボタン
    @IBAction func forwardBarButtonItem(forwardSender: UIBarButtonItem) {
        
        //ブラウザ進むお
        webview!.goForward()
        println("Go Forward!")
    }
    
    // ホームボタン
    @IBAction func homeButtonItem(sender: UIBarButtonItem) {
        
        //ここを空のページにしたい
        self.webview?.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.yuge.ac.jp")!))
        
        println("Go Home!")
    }
    
    
    //ブックマーク一覧を開く
    @IBAction func bookMarkButtonItem(sender: UIBarButtonItem) {
        cellControll = 0
        
        //開く
        if(favoriteFlag == 0) {
            //tableViewを最前面にする
            self.view.bringSubviewToFront(self.favoriteTable)
            UIView.animateWithDuration(0.2,
                animations: {() -> Void in self.favoriteTable.transform =
                    CGAffineTransformMakeTranslation(0, 60)},
                completion: {(Bool) -> Void in println("addView")})
            
            favoriteFlag = 1
        }
            
            //閉じる
        else if(favoriteFlag == 1) {
            
            UIView.animateWithDuration(0.2,
                animations: {() -> Void in self.favoriteTable.transform =
                    CGAffineTransformMakeTranslation(0 - self.view.frame.width/1.5, 60)},
                completion: {(Bool) -> Void in println("DeleteView!")})
            
            favoriteFlag = 0
        }
    }
    
    
    //履歴
    @IBAction func historyButtonItem(sender: UIBarButtonItem) {
        cellControll = 1
        
        //開く
        if(historyFlag == 0) {
            //Viewを最前面にする
            self.view.bringSubviewToFront(self.historyTable)
            UIView.animateWithDuration(0.2,
                animations: {() -> Void in self.historyTable.transform =
                    CGAffineTransformMakeTranslation(self.view.frame.width/1.5, 60)},
                completion: {(Bool) -> Void in println("addView")})
            
            historyFlag = 1
        }
            
            //閉じる
        else if(historyFlag == 1) {
            //self.historyTable.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)
            
            UIView.animateWithDuration(0.2,
                animations: {() -> Void in self.historyTable.transform =
                    CGAffineTransformMakeTranslation(self.view.frame.width, 60)},
                completion: {(Bool) -> Void in println("DeleteView!")})
            
            historyFlag = 0
        }
    }
    
    
    // 学生にURLを送信
    @IBAction func sendURLButtonAction(sender: AnyObject) {
        WebInfo.webInfoInstance.url = self.list.currentItem!.URL.description
        CoreCentralManager.coreCentralInstance.sendWritingRequest(CoreCentralManager.coreCentralInstance.webUUID, sendData: nil)
        WebInfo.webInfoInstance.url = nil
        
    }
    
    //ボタンコントロール
    func buttonItemControl() {
        
        //ブラウザが戻れるとき
        if webview!.canGoBack {
            backBarButtonItem.enabled = true
            println("Can Go Back!")
        }
            
        else {
            backBarButtonItem.enabled = false
            println("Cannot Go Back!")
        }
        
        
        //ブラウザが進めるとき
        if webview!.canGoForward {
            forwardButtonItem.enabled = true
            println("Can Go Forward!")
        }
            
        else {
            forwardButtonItem.enabled = false
            println("Cannot Go Forward!")
        }
        
        println("buttonItem Control!")
        println("------------------------")
    }
    
    //エンコード
    func encodes() {
        
        println("Let's Encodeee!")
        encodeInput = urlTextField!.text
        
        //エンコードした結果を用意した変数に代入
        encoded = encodeInput.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        //encodeしたURLを生成
        urlTextField!.text = "https://www.google.co.jp/search?q=" + encoded
        
        //生成したURLで検索
        self.webview!.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField!.text)!))
    }
    
    
    //戻りURL取得
    func WKBFList() {
        list = self.webview!.backForwardList
        
        //戻る履歴
        if (list.backItem != nil) {
            //println("url",list.backItem!.URL)
            self.historyItems.insert(self.list.backItem!.URL.description, atIndex: 0)
            cellControll = 1
            //println("title",list.backItem!.title)
            //historyItems[historyCount] = "\(list.backItem!.URL)"
            //self.historyItems.append("\(list.backItem!.URL)")
            //println(list.backItem!.initialURL)
        }
    }
    
    
    
    
    //ページ移動したときなどでブックマークに登録されているかチェックしてされてなければブックマークを受け入れる
    func bookMarkCheck() {
        //        cellControll = 0
        
        let bookMarkOnImage : UIImage? = UIImage(named: "bookMarkOnButton.png")
        let bookMarkOffImage : UIImage? = UIImage(named: "bookMarkOffButton.png")
        
        var title = ""
        if self.list != nil {
            title = self.list.currentItem!.title!
        }
        
        // listの中にある同じタイトルを取得し移動先のページがブックマーク登録されているかチェックする
        for (index, favoriteTitle) in enumerate(self.favoriteTitleList) {
            
            if title == favoriteTitle {
                
                bookMarkFlag = true
                break
            }
                
            else {
                bookMarkFlag = false
            }
        }
        
        // 移動先のページがブックマークされている場合
        if bookMarkFlag == true {
            
            println("ブックマーク済みです！")
            //画像切り替え
            self.bookMarkButton?.setImage(bookMarkOffImage, forState: .Normal)
            bookMarkFlag = true
        }
            
            // 移動先のページがブックマークされていない場合
        else {
            
            println("ブックマークされてません！")
            //画像切り替え
            self.bookMarkButton?.setImage(bookMarkOnImage, forState: .Normal)
            bookMarkFlag = false
        }
    }
    
    /**
    開いたリストを一括で閉じる
    */
    func leaveList() {
        
        //お気に入りリスト
        UIView.animateWithDuration(0.2,
            animations: {() -> Void in self.favoriteTable.transform =
                CGAffineTransformMakeTranslation(0 - self.view.frame.width/1.5, 60)},
            completion: {(Bool) -> Void in println("DeleteView!")})
        
        //履歴リスト
        UIView.animateWithDuration(0.2,
            animations: {() -> Void in self.historyTable.transform =
                CGAffineTransformMakeTranslation(self.view.frame.width, 60)},
            completion: {(Bool) -> Void in println("DeleteView!")})
    }
    
    /**
    画面のどこかを触った時
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("aaa")
        //        UIView.animateWithDuration(0.2,
        //            animations: {() -> Void in
        //                self.studentListTableView.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 60)},
        //            completion: {(Bool) -> Void in
        //                println("DeleteView!")
        //        })
        
    }
    
    
    // --------デリゲート宣言--------
    
    /**
    cellの数
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cellControll == 0) {
            //            return self.favoriteItems.count
            return self.favoriteTitleList.count
        }
            
        else {
            return self.historyItems.count
        }
    }
    
    
    
    /**
    cellに値を格納
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //一旦、viewの状態で取得
        var historyView = self.view.viewWithTag(55) // tagからviewを取り出す。
        var favoriteView = self.view.viewWithTag(66) // tagからviewを取り出す。
        
        //tableViewに変換
        var historyTableView = historyView as! UITableView
        var favoriteTableView = favoriteView as! UITableView
        
        
        
        var cell : UITableViewCell!
        
        if(cellControll == 0) {
            cell = favoriteTableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel!.text = self.favoriteTitleList[indexPath.row]
        }
            
        else {
            // 再利用するCellを取得する.
            cell = historyTableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as! UITableViewCell
            
            // Cellに値を設定する.
            cell.textLabel!.text = self.historyItems[indexPath.row]
            
        }
        
        return cell
        
    }
    
    /**
    Cellが選択された際に呼び出されるデリゲートメソッド
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if(cellControll == 0) {
            
            
            urlTextField!.text = self.favoriteURLList[indexPath.row]
            webview!.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField!.text)!))
            
            leaveList()
            favoriteFlag = 0
        }
            
            
        else {
            urlTextField!.text = self.historyItems[indexPath.row]
            webview!.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField!.text)!))
            
            leaveList()
            historyFlag = 0
        }
    }
    
    
    /**
    ページの読み込みを開始したとき
    */
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        cellControll = 1
        leaveList()
        
        reloadButton?.removeFromSuperview()
        self.urlBarForm?.addSubview(self.stopButton!)
        
        // ステータスバーに読み込み中表示をする
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //読み込みが開始したらViewを出す
        view.addSubview(testProgressView)
        
        //読み込み中にURLを消させない
        textDeleteButton!.removeFromSuperview()
        
        println("Page Read Start!")
        
    }
    
    
    /**
    ページの読み込みが完了した時の処理
    */
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        
        //遷移先のページのURLをテキストフィールドに挿入
        self.urlTextField?.text = self.webview?.URL?.absoluteString
        
        stopButton?.removeFromSuperview()
        self.urlBarForm?.addSubview(self.reloadButton!)
        
        // ステータスバーから読み込み中表示を消す
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //Progeress終了
        testProgressView.setProgress(0.0, animated: false)
        
        //progressViewも消す
        testProgressView.removeFromSuperview()
        
        //URL削除ボタン再表示
        self.urlBarForm?.addSubview(self.textDeleteButton!)
        
        println("Page Read Finish!")
        
        
        buttonItemControl()
        WKBFList()
        
        bookMarkCheck()
        
        
        historyTable.reloadData()
    }
    
    
    // open link with target="_blank" in the same view(もしリンク先が新規タブを開く設定だったら)
    /* もし新規タブで開く設定のサイトを開こうとした際にViewでは開こうとはするがリクエストがnilになってviewが動作しない
    そこでnilのときもう一度リクエストを送信することで開くという原理のようだ */
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.loadRequest(navigationAction.request)
        }
        return nil
    }
    
    
    /**
    returnkeyが押されたとき
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        //どちらか片方で良い気がする
        var url:String! = String(stringInterpolationSegment: urlTextField!.text)
        var urlS:String! = String(stringInterpolationSegment: urlTextField!.text)
        
        
        //httpかhttpsが含まれないものはエンコード
        //URLにhttp://が含まれており始めの7文字がhttp://のとき
        if let found = url.rangeOfString("http://"){
            if (url as NSString).substringToIndex(7) == "http://" {
                println("OK! Search Start!")
                self.webview!.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField!.text)!))
            }
                
                //最初の条件を満たして次の条件を満たしていなかったときの処理
            else {
                encodes()
            }
        }
            
            //URLにhttps://が含まれており始めの8文字がhttps://のとき
        else if let foundS = urlS.rangeOfString("https://"){
            if (urlS as NSString).substringToIndex(8) == "https://" {
                println("OK! Search Start!")
                self.webview!.loadRequest(NSURLRequest(URL: NSURL(string: urlTextField!.text)!))
            }
                
            else {
                encodes()
            }
        }
            
        else {
            encodes()
            
        }
        
        //キーボードを閉じる
        return true
    }
    
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
    
}

