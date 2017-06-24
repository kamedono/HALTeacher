//
//  CourceXMLParser.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/08/08.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//


import Foundation

protocol CourceXMLParserDelegate{
    func finishCourceParse()
}

class CourceXMLParser: NSObject, NSURLSessionDataDelegate, NSXMLParserDelegate{
    
    static var courceXMLParserInstance = CourceXMLParser()
    
    override init() {
        super.init()
    }
    
    //構造体の宣言
    var courceContent: CourceContent!
    
    //コースを保存する配列
    var courceList: [CourceContent] = []
    
    //コースの番号
    var courceNumber :Int = 0
    
    //事前に読んだタグを記憶する
    var tagName = ""
    
    //デリゲート宣言
    var delegate: CourceXMLParserDelegate!
    
    
    
    //ダウンロードしたXMLデータを保持
    var downloadedData: NSData!
    
    // xmlパーサの初期化
    var xmlParser: NSXMLParser!
    
    //courceXMLParserDelegate.delegate = self
    
    
    /**
    配列の中身を消す関数
    */
    func setEmpty(){
        self.courceList = []
        self.courceNumber = 0
    }
    
    /**
    コースXMLのDLとパース
    */
    func getCource(xmlURL: String) {
        
        //        var xmlPath = "http://www.yuge.ac.jp/home/~ap14006/procon/courceList.xml"
        
        // 通信のコンフィグを用意.
        //        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession")
        let myConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // Sessionを作成する.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        // ダウンロード先のURLからリクエストを生成.
        let myURL: NSURL = NSURL(string: xmlURL)!
        
        let myRequest:NSURLRequest = NSURLRequest(URL: myURL)
        
        // ダウンロードタスクを生成.
        let myTask:NSURLSessionDataTask = mySession.dataTaskWithRequest(myRequest)
        
        //        let myTask:NSURLSessionDownloadTask = mySession.downloadTaskWithRequest(myRequest)
        
        // タスクを実行.
        myTask.resume()
        
    }
    
    
    /*
    ダウンロード終了時に呼び出される
    DLしたファイルを
    XMLパースする
    */
    //    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
    //        //XMLデータのNSData化
    //        downloadedData = NSData(contentsOfURL: location, options: NSDataReadingOptions.DataReadingMappedAlways, error: nil)!
    //
    //        session.invalidateAndCancel()
    //    }
    
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        //XMLデータのNSData化
        //        downloadedData = NSData(contentsOfURL: location, options: NSDataReadingOptions.DataReadingMappedAlways, error: nil)!
        self.downloadedData = data
    }
    
    /*
    通信タスク終了時に呼び出されるデリゲート.
    */
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        session.invalidateAndCancel()
        if error == nil {
            println("ダウンロードが成功しました")
            //parserにセット
            self.xmlParser = NSXMLParser(data: downloadedData)
            self.xmlParser.delegate = self
            
            //XML解析開始
            self.xmlParser.parse()
            
        } else {
            println("ダウンロードが失敗しました")
        }
    }
    
    
    // 開始タグの読み取り　1
    func parserDidStartDocument(parser: NSXMLParser)
    {
        println("xml読み込み開始")
    }
    
    //タグ名の取得 2
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]){
        
        //タグの名前を記憶
        tagName = elementName
        switch elementName {
        case "cource":
            courceContent = CourceContent()
        default:
            break
        }
    }
    
    //タグの中身を見る 3
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        switch tagName{
        case "name":
            courceContent.courceName = string!
        case "url":
            courceContent.courceURL = string!
        default:
            break
        }
        
    }
    
    //タグの最後で呼ばれる 4
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if(elementName == "cource"){
            //コースリストに追加
            self.courceList.append(courceContent)
        }
        //タグの名前を保存する変数の初期化
        tagName = ""
    }
    
    //XML読み込み完了時に呼ばれます
    func parserDidEndDocument(parser: NSXMLParser)
    {
        println("コースの読み取り完了")
        self.delegate.finishCourceParse()
    }
}