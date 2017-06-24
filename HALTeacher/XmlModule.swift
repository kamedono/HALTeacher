//
//  XmlModule.swift
//  XML
//
//  Created by sotuken on 2015/07/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//
//
//  ViewController.swift
//  ConnectionClasses008
//

import UIKit
import Foundation

protocol XmlModuleDelegate{
    /**
    セルを内容を変更する
    */
    func finishRead()
    
    /**
    セルを内容を変更する
    */
    func downloadFailed()
}

class XmlModule: NSObject, NSURLSessionDataDelegate, NSXMLParserDelegate {
    
    //タグの現在位置
    var pwd : Array<String> = []
    
    //読み込み条件のフラグ
    var textFlag: Bool = false
    var answerFlag: Bool = false
    var fileFlag: Bool = false
    var idFlag: Bool = false
    var questionNumber: Int = -1
    
    var delegate : XmlModuleDelegate!
    
    //questionの作成
    var question: QuestionXML!
    
    //answerの作成
    var questionAnswer :QuestionAnswer!
    
    //各タグの内容を読み取る 3
    var parserCounter :Int = 0
    var answerNum :Int = 0
    
    // ダウンロードしたデータを元にパーサを生成するための変数
    var xmlParser: NSXMLParser!
    
    var downloadedData: NSData!
    
    /*
    初期化の代わり
    */
    func setEmpty(){
        self.pwd = []
        questionNumber = -1
        parserCounter = 0
        answerNum = 0
    }
    
    /*
    問題作成
    XMLのDL
    XMLのパース
    */
    func createQuestion(url: String) {

        //        self.setEmpty()
//        // 通信のコンフィグを用意.
//        let myConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        //        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession")
//        
//        // Sessionを作成する.
//        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
//        
//        // ダウンロード先のURLからリクエストを生成.
//        let myURL:NSURL = NSURL(string: url)!
//        
//        let myRequest:NSURLRequest = NSURLRequest(URL: myURL)
//        
//        // ダウンロードタスクを生成.
//        let myTask:NSURLSessionDataTask = mySession.dataTaskWithRequest(myRequest)
//        //        let myTask:NSURLSessionDownloadTask = mySession.downloadTaskWithRequest(myRequest)
//        
//        // タスクを実行.
//        myTask.resume()
        
        var url = NSURL(string: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            // 成功時
            println("ダウンロードが成功しました")
            self.downloadedData = data
            self.xmlParser = NSXMLParser(data: self.downloadedData)
            self.xmlParser.delegate = self
            
            //XML解析開始
            self.xmlParser.parse()
            
        })
        task.resume()
        
    }
    
    
    /*
    ダウンロード終了時に呼び出される
    DLしたファイルを
    XMLパースする
    */
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        //XMLデータのNSData化
        //        downloadedData = NSData(contentsOfURL: location, options: NSDataReadingOptions.DataReadingMappedAlways, error: nil)!
        self.downloadedData = data
//        println(data)
    }
    
    
    /*
    通信タスク終了時に呼び出されるデリゲート.
    */
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error == nil {
            println("ダウンロードが成功しました")
            self.xmlParser = NSXMLParser(data: self.downloadedData)
            self.xmlParser.delegate = self
            
            //XML解析開始
            self.xmlParser.parse()
        }
        else {
            println("ダウンロードが失敗しました")
            self.delegate.downloadFailed()
        }
    }
    
    
    // 開始タグの読み取り　1
    func parserDidStartDocument(parser: NSXMLParser){
        // Itemオブジェクトを格納するItems配列の初期化など
        //println("xml読み込み開始")
    }
    
    //タグ名の取得 2
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]){
        var pwdNum :Int = pwd.endIndex
        
        pwd.append(elementName)
        
        if elementName == "text" && pwd[pwdNum] == "answer" {
            //println("回答読み込むき満々"+pwd[p_num-2])
            answerFlag = true
        }
        
        if elementName == "answer"{
            questionAnswer = QuestionAnswer()
            questionAnswer.judge = attributeDict["fraction"] as! String
        }
        
        if elementName == "text"{
            textFlag = true
            parserCounter = 0
        } else if elementName == "question"{
            question = QuestionXML()
            answerNum = 0
            // 問題番号の設定、answerに追加したため必要
            self.questionNumber++
            
            // 問題番号追加
            question.questionNumber = questionNumber
        } else if elementName == "file" {
            fileFlag = true
        }else  if elementName == "id" {
            idFlag = true
        }
    }
    
    //タグの中身を見る 3
    func parser(parser: NSXMLParser, foundCharacters string: String?){
        var index = pwd.count-2
        
        if(index >= 0){
            //問題名の取得
            if  pwd[index] == "name" && textFlag {
                //１回以上
                if (parserCounter>0){
                    //結合させる
                    question.name! += string!
                }else{
                    question.name = string!
                }
            }
            
            //問題内容の取得
            if pwd[index] == "questiontext" && textFlag{
                if (parserCounter>0){
                    //結合させる
                    question.question_text! += string!
                }
                question.question_text = string!
                textFlag = false
            }
            
            //添付データの保存
            if fileFlag{
                question.question_file += string!
            }
            //IDの取得
            if idFlag{
                question.id = string!
            }
            
            //回答群の取得
            if pwd[index] == "answer" && textFlag{
                if (parserCounter>0){
                    //結合させる
                    questionAnswer.questionText += string!
                }else{
                    questionAnswer.questionText = string!
                }
            }
            
            //フィードバック
            if pwd[index] == "feedback" && textFlag{
                if (parserCounter>0){
                    //結合させる
                    questionAnswer.feedback += string!
                }else{
                    questionAnswer.feedback = string!
                }
            }
            
        }
        parserCounter += 1
    }
    
    //タグの最後で呼ばれる 4
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        pwd.removeLast()
        parserCounter = 0
        textFlag = false
        
        if elementName == "answer" {
            // 問題番号追加
            questionAnswer.questionNumber = self.questionNumber
            self.question.answers.append(questionAnswer)
        }
        else if elementName == "question" && !question.name.isEmpty{
            QuestionBox.questionBoxInstance.questions.append(question)
            self.question = nil
        }
        else if elementName == "text" {
            textFlag = false
        }else if elementName == "file" {
            fileFlag = false
        }else if elementName == "id" {
            idFlag = false
        }
    }
    
    //XML読み込み完了時に呼ばれます
    func parserDidEndDocument(parser: NSXMLParser)
    {
        self.delegate.finishRead()
        
    }
}
