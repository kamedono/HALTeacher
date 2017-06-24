//
//  ImportMoodleScore.swift
//  HALTeacher
//
//  Created by sotuken on 2015/10/04.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class ImportMoodleScore: NSObject {
    /**
    小テストの結果を登録する
    
    :param: token:トークン
    :param: courceID:コースのID
    :param: studentID:学生のID
    :param: quizName:小テストの名前
    :param: grade:点数
    */
    func uploadQuizScore(token:String, courseID:Int, studentID:Int, quizName:String, grade:Int){
        //        let accessURL =   "http://192.168.113.234/moodle/ImportMoodleScore/importQuizScore.php"
        let accessURL =   MoodleInfo.moodleInfoInstance.moodleURL + "/ImportMoodleScore/importQuizScore.php"
        //アクセスするURL(moodleログインページ)
        var url = NSURL(string: accessURL) //localhostURL + accessURL
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        
        //トークンID
        var tokenID = ""
        //POSTパラメータセット
        req.HTTPBody = "token=\(token)&courseID=\(courseID)&studentID=\(studentID)&quizName=\(quizName)&grade=\(grade)".dataUsingEncoding(NSUTF8StringEncoding)
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(htmlSource)
        })
        task.resume()
        
    }
    
    /**
    クリッカーの結果を登録する
    
    :param: databaseID:データベースのID
    :param: questionText:クリッカーの問題文
    :param: clickerResult:クリッカーの集計結果
    :param: clickerEachResult:学生の入力結果
    */
    func uploadClickerResult(databaseID:Int, questionText:String, clickerResult:String, clickerEachUserResult:String){
        let accessURL =   MoodleInfo.moodleInfoInstance.moodleURL + "/ImportMoodleScore/importClicker.php"
        //アクセスするURL(moodleログインページ)
        var url = NSURL(string: accessURL) //localhostName + accessURL
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        //POSTパラメータセット
        req.HTTPBody = "databaseID=\(databaseID)&questionText=\(questionText)&clickerResult=\(clickerResult)&clickerEachUserResult=\(clickerEachUserResult)".dataUsingEncoding(NSUTF8StringEncoding)
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(htmlSource)
        })
        task.resume()
    }
}