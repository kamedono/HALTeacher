//
//  MoodleAccess.swift
//  NewHALTitle
//
//  Created by Toshiki Higaki on 2015/09/13.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TeacherMoodleAccessDelegate {
    /**
    アクセスした結果
    */
    optional func accessCheckResult(result: Bool)
    
    /**
    ログインした結果
    */
    optional func loginResult(result: Bool)
    
    /**
    コースの情報取得結果
    */
    optional func myProfileResult(result: Bool)
    
    /**
    コースの問題情報得後
    */
    optional func getedCourceQuestion()
    
    /**
    クリッカー情報取得後
    */
    optional func getedClickerInfo()

    /**
    トークンID取得後
    */
    optional func getedTokenID()
}

class TeacherMoodleAccess : NSObject{
    
    var delegate: TeacherMoodleAccessDelegate!
    
    let httpRegex = "http://"
    
    var userID: String = ""
    var password: String = ""
    var name: String = ""
    var number: String = ""
    
    var moodleURL: String?
    var logoutURL: String = ""
    var myProfileURL: String = ""
    var editMyProfileURL: String = ""
    
    var courceList: [CourceContent] = []
    var selectCourceList: [CourceContent] = []
    var studentList: [String] = []
    
    var sessionCount: Int = 0
    
    //トークンID
    var tokenID: String = ""

    /**
    moodleログインページから情報を取得
    
    :param: url:MoodelのURL
    */
    func checkMoodleAccess(url: String) {
        
        //アクセスするURL(moodleログインページ)
        let deleteTarget = NSCharacterSet.whitespaceCharacterSet
        let urlString = url.stringByTrimmingCharactersInSet(deleteTarget())
        var url = NSURL(string: urlString)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            let regexPageMoodlePage = "moodle/login/index.php"
            if(htmlSource != "") {
                //404じゃないとき
                if(htmlSource!.rangeOfString(regexPageNotFoound).length == 0 && htmlSource!.rangeOfString(regexPageMoodlePage).length != 0) {
                    self.moodleURL = urlString
                    self.delegate?.accessCheckResult?(true)
                }
                else {
                    self.delegate?.accessCheckResult?(false)
                }
            }
            else {
                self.delegate?.accessCheckResult?(false)
            }
        })
        task.resume()
        
    }
    
    /**
    ログインを行う
    
    :param: userID:MoodelのURL
    :param: password:MoodelのURL
    */
    func moodleLogin(userID:String, password:String) {
        //アクセスするURL(moodleログインページ)
        let test = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/login/"
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/login/")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        //マイプロファイルのURL
        var myProfileURL = ""
        
        request.HTTPMethod = "POST"
        request.HTTPBody = "username=\(userID)&password=\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            
            // Todo
            // 条件分岐の追加が必要
            if(htmlSource != "") {
                
                //ユーザ名の取得
                let headRegexUserName = "<div class=\"logininfo\">"
                let tailRegexUserName = "</a>"
                //キャストではダメ。NSMutableStringにappendStringしないと！
                
                //文字列の抽出ができるクラス変数（NSMutableString）
                var regexHTMLSource :NSMutableString = ""
                regexHTMLSource.appendString(String(htmlSource!))
                
                //抽出結果を格納する変数
                var tailRegex :NSString = ""
                
                //検索文字以降の文字列を取得
                var userInfo = regexHTMLSource.substringFromIndex(htmlSource!.rangeOfString(headRegexUserName).location + count(headRegexUserName))
                
                //検索文字より前の文字列を取得
                userInfo = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString(tailRegexUserName).location)
                userInfo = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString("http://").location)
                var userName = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString(">", options:NSStringCompareOptions.BackwardsSearch).location + 1)
                
                println("User Name : \(userName)")
                
                //ユーザのプロファイルURL
                myProfileURL = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString("\"").location)
                println("My Profile URL : \(myProfileURL)")
                
                //出席番号
                var userNumber = ""
                let regexUserNumber = "/user/profile.php?id="
                
                //ログイン成功判定
                if((myProfileURL as NSString).rangeOfString(regexUserNumber).length == 0) {
                    //ログイン失敗した時
                    self.delegate?.loginResult?(false)
                    
                }else{
                    self.delegate?.loginResult?(true)
                }
            }
            else {
                self.delegate?.loginResult?(false)
            }
        })
        task.resume()
    }
    
    /**
    ログインの結果を返す
    
    :param: userID:MoodelのURL
    :param: password:MoodelのURL
    */
    func checkMoodleLogin(userID:String, password:String) {
        //アクセスするURL(moodleログインページ)
        let test = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/login/"
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/login/")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        //マイプロファイルのURL
        var myProfileURL = ""
        
        request.HTTPMethod = "POST"
        request.HTTPBody = "username=\(userID)&password=\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            if(htmlSource != "") {
                
                //ユーザ名の取得
                let headRegexUserName = "<div class=\"logininfo\">"
                let tailRegexUserName = "</a>"
                //キャストではダメ。NSMutableStringにappendStringしないと！
                
                //文字列の抽出ができるクラス変数（NSMutableString）
                var regexHTMLSource :NSMutableString = ""
                regexHTMLSource.appendString(String(htmlSource!))
                
                //抽出結果を格納する変数
                var tailRegex :NSString = ""
                
                //検索文字以降の文字列を取得
                var userInfo = regexHTMLSource.substringFromIndex(htmlSource!.rangeOfString(headRegexUserName).location + count(headRegexUserName))
                
                //検索文字より前の文字列を取得
                userInfo = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString(tailRegexUserName).location)
                userInfo = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString("http://").location)
                var userName = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString(">", options:NSStringCompareOptions.BackwardsSearch).location + 1)
                
                //                println("User Name : \(userName)")
                
                //ユーザのプロファイルURL
                myProfileURL = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString("\"").location)
                //                println("My Profile URL : \(myProfileURL)")
                
                //出席番号
                var userNumber = ""
                let regexUserNumber = "/user/profile.php?id="
                
                //ログイン成功判定
                if((myProfileURL as NSString).rangeOfString(regexUserNumber).length == 0) {
                    //ログイン失敗した時
                    self.delegate?.loginResult?(false)
                    
                }else{
                    //出席番号
                    userNumber = (myProfileURL as NSString).substringFromIndex((myProfileURL as NSString).rangeOfString(regexUserNumber).location + count(regexUserNumber))
                    //                    println("出席番号： \(userNumber)")
                    
                    
                    //コース情報を取得
                    let headRegexMoodleCource = "<a class=\"\""
                    let tailRegexMoodleCource = "</a>"
                    
                    var courceList: [CourceContent] = []
                    
                    let headRegexMoodleLogout = "/login/logout.php?"
                    let tailRegexMoodleLogout = "\">"
                    
                    // ログアウトのURLを取得
                    var logoutURL: String = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexMoodleLogout).location)
                    logoutURL = (logoutURL as NSString).substringToIndex((logoutURL as NSString).rangeOfString(tailRegexMoodleLogout).location)
                    self.logoutURL = logoutURL
                    
                    //検索文字がヒットするまで繰り返し
                    while(htmlSource!.rangeOfString(headRegexMoodleCource).length > 0){
                        //<a class以降の文字列
                        tailRegex = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexMoodleCource).location + count(headRegexMoodleCource))
                        htmlSource = tailRegex.substringFromIndex(tailRegex.rangeOfString(tailRegexMoodleCource).location)
                        
                        var courceSource = (tailRegex as NSString).substringToIndex(tailRegex.rangeOfString(tailRegexMoodleCource).location)
                        
                        let tailRegexCourceURL = "\""
                        
                        //抽出元するデータ
                        var regexURL :NSMutableString = ""
                        
                        //抽出するデータの入れ込み
                        regexURL.appendString(courceSource)
                        
                        //headRegexCourceURL以降のデータ
                        tailRegex = regexURL.substringFromIndex((courceSource as NSString).rangeOfString(self.httpRegex).location)
                        var courceURL = tailRegex.substringToIndex(tailRegex.rangeOfString(tailRegexCourceURL as String, options:NSStringCompareOptions.BackwardsSearch).location)
                        //                        println(courceURL)
                        let headRegexCourceName = ">"
                        let headRegexCourceID = "id="
                        var name = tailRegex.substringFromIndex(tailRegex.rangeOfString(headRegexCourceName as String, options:NSStringCompareOptions.BackwardsSearch).location + count(headRegexCourceName))
                        
                        let number = (courceURL as NSString).substringFromIndex((courceURL as NSString).rangeOfString(headRegexCourceID).location + count(headRegexCourceID))
                        
                        // Moodle情報格納
                        let courceContent = CourceContent(name: name,number: number, url: courceURL)
                        courceList.append(courceContent)
                        
                    }
                    
                    self.courceList = courceList
                    self.myProfileURL = myProfileURL
                    
                    self.number = userNumber
                    self.name = userName
                    self.userID = userID
                    self.password = password
                    
                    self.delegate?.loginResult?(true)
                }
            }
            else {
                self.delegate?.loginResult?(false)
            }
        })
        task.resume()
    }
    
    
    
    /**
    マイプロファイルから情報を取得
    
    :param: url:MoodelのURL
    */
    func getMyProfile(){
        var url = NSURL(string: self.myProfileURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            //プロファイルを編集ページのURL取得
            let regexMyProfileURL = "/user/edit.php"
            //adminユーザはURLが異なるため分岐処理
            if(htmlSource!.rangeOfString(regexMyProfileURL).length != 0){
                //admin以外の場合
                self.delegate?.myProfileResult?(false)
                
            }else{
                //adminユーザの場合
                println("adminユーザです")
                let regexMyProfileURL = "/user/editadvanced.php"
                var editMyProfileInfo = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(regexMyProfileURL).location)
                editMyProfileInfo = (editMyProfileInfo as NSString).substringToIndex((editMyProfileInfo as NSString).rangeOfString("\">").location)
                self.editMyProfileURL = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + editMyProfileInfo
                
                println("プロファイル編集ページのURL： \(self.editMyProfileURL)")
                
                //コース一覧を取得
                let headRegexUserCource = "<a class=\"\""
                let tailRegexUserCource = "</a>"
                
                var selectCourceNameList: [String] = []
                
                while(htmlSource!.rangeOfString(headRegexUserCource).length > 0){
                    var courceInfo = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexUserCource).location + count(headRegexUserCource))
                    htmlSource = courceInfo
                    courceInfo = (courceInfo as NSString).substringToIndex((courceInfo as NSString).rangeOfString(tailRegexUserCource).location)
                    var courceName = (courceInfo as NSString).substringFromIndex((courceInfo as NSString).rangeOfString(">").location + 1)
                    selectCourceNameList.append(courceName)
                }
                
                var selectCourceList: [CourceContent] = []
                
                //受講できるコースリスト作成(教員用)
                for (indexName, selectCourceName) in enumerate(selectCourceNameList) {
                    //moodleコース一覧から受講しているコースのURLを抽出
                    for (indexCource, cource) in enumerate(self.courceList) {
                        if selectCourceName == cource.courceName {
                            selectCourceList.append(cource)
                        }
                    }
                }
                
                self.selectCourceList = selectCourceList
                self.delegate?.myProfileResult?(true)
            }
        })
        task.resume()
    }
    
    
    /**
    選択したコース内のXMLファイルのデータ取得
    */
    func getCourceQuestion(){
        for (index, cource) in enumerate(self.selectCourceList) {
            getSelectCourceQuestion(index, url: cource.courceURL)
            getSelectCourceStudent(index, number: cource.courceNumber)
            getSelectCourceClicker(index, url: cource.courceURL)
        }
        
    }
    
    
    /**
    選択したコース内のXMLファイルのデータ取得
    
    :param: index:courceListの配列番号
    :param: url:courceのURL
    */
    func getSelectCourceQuestion(index: Int, url:String) {
        let test = url
        var url = NSURL(string: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            var userName = ""
            
            var headRegex :NSMutableString = ""
            var tailRegex :NSString = ""
            
            let headRegexFileName = "<span class=\"accesshide \" > ファイル</span>"
            let tailRegexFileName = "<span class=\"instancename\">"
            
            //ファイルパス
            let headRegexFilePath = "/mod/resource/view.php"
            
            var quizInfoList: [QuizInfo] = []
            
            //検索文字列以前の文字列を抽出
            while(htmlSource!.rangeOfString(headRegexFileName).length > 0){
                var backRegex = htmlSource!.substringToIndex(htmlSource!.rangeOfString(headRegexFileName).location)
                var getFileName = (backRegex as NSString).substringFromIndex((backRegex as NSString).rangeOfString(headRegexFilePath).location)
                var getFilePath = (getFileName as NSString).substringToIndex((getFileName as NSString).rangeOfString("\">").location)
                
                getFileName = (getFileName as NSString).substringFromIndex((getFileName as NSString).rangeOfString(tailRegexFileName).location + count(tailRegexFileName))
                
                // コースにあるクイズの情報
                quizInfoList.append(QuizInfo(name: getFileName, url: getFilePath))
                
                
                // 更新作業
                htmlSource = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexFileName).location + count(headRegexFileName))
                
            }
            self.selectCourceList[index].quizInfoList = quizInfoList
            
            if self.sessionCount == self.selectCourceList.count * 3 - 1 {
                self.delegate?.getedCourceQuestion?()
            }
            else {
                self.sessionCount++
            }
            
        })
        task.resume()
    }
    
    /**
    選択したコース内の学生データ取得
    
    :param: index:courceListの配列番号
    :param: number:courceのid番号
    */
    func getSelectCourceStudent(index: Int, number: String) {
        let test = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/enrol/users.php?id=" + number
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/enrol/users.php?id=" + number)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        //        println(test)
        req.HTTPMethod = "POST"
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            var userName = ""
            
            var headRegex :NSMutableString = ""
            var tailRegex :NSString = ""
            
            let headRegexStudentName = "<div class=\"subfield subfield_firstname\">"
            let tailRegexStudentName = "</div>"
            let headRegexStudentRole = "<div class=\"role role_5\">"
            let tailRegexStudentRole = "<a class="
            
            var courceSelectStudent: [String] = []
            
            //検索文字列以前の文字列を抽出
            while(htmlSource!.rangeOfString(headRegexStudentRole).length > 0) {
                
                var getStudentName = htmlSource!.substringToIndex(htmlSource!.rangeOfString(headRegexStudentRole).location)
                getStudentName = (getStudentName as NSString).substringFromIndex((getStudentName as NSString).rangeOfString(headRegexStudentName, options:NSStringCompareOptions.BackwardsSearch).location + count(headRegexStudentName))
                getStudentName = (getStudentName as NSString).substringToIndex((getStudentName as NSString).rangeOfString(tailRegexStudentName).location )
                courceSelectStudent.append(getStudentName)
                //                println("取得しているデータ\(getStudentName)")
                
                // 更新作業
                htmlSource = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexStudentRole).location + count(headRegexStudentRole))
                
            }
            self.selectCourceList[index].studentList = courceSelectStudent
            
            if self.sessionCount == self.selectCourceList.count * 3 - 1 {
                self.delegate?.getedCourceQuestion?()
            }
            else {
                self.sessionCount++
            }
        })
        task.resume()
    }
    
    /**
    選択したコース内のクリッカーデータ取得
    
    :param: index:courceListの配列番号
    :param: url:clickerDBのURL
    */
    func getSelectCourceClicker(index: Int, url: String) {
        let test = url
        var url = NSURL(string: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            //クリッカーDBの検索
            let headRegexClikerName = "<span class=\"accesshide \" > データベース</span>"
            let tailRegexClikerName = "<span class=\"instancename\">"
            
            let headRegexClikerPath = "/mod/data/"
            let tailRegexClikerPath = "\">"
            
            var clickerURLList: [String] = []
            
            while(htmlSource!.rangeOfString(headRegexClikerName).length > 0){
                var backRegex = htmlSource!.substringToIndex(htmlSource!.rangeOfString(headRegexClikerName).location)
                //URLの取得
                var getDBPath = (backRegex as NSString).substringFromIndex((backRegex as NSString).rangeOfString(headRegexClikerPath, options:NSStringCompareOptions.BackwardsSearch).location + count(headRegexClikerPath))
                getDBPath = (getDBPath as NSString).substringToIndex((getDBPath as NSString).rangeOfString(tailRegexClikerPath).location)
                clickerURLList.append(headRegexClikerPath+getDBPath)
                
                //名前の取得
                var getDBName = (backRegex as NSString).substringFromIndex((backRegex as NSString).rangeOfString(tailRegexClikerName, options:NSStringCompareOptions.BackwardsSearch).location + count(tailRegexClikerName))
                htmlSource = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexClikerName).location + count(headRegexClikerName))
            }
            
            // クリッカーのURLだけを保存
            for(var i=0; clickerURLList.count > i; i++ ){
                //クリッカー問題を保存するインスタンス
                var clickerContent = ClickerContent()
                clickerContent.clickerDBURL = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + clickerURLList[i] + "&perpage=1000"
                self.selectCourceList[index].clickerContentList.append(clickerContent)
                //                self.getClickerDB((self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + clickerURLList[i] + "&perpage=1000", index: index)
            }
            
            // デリゲートの設定
            if self.sessionCount == self.selectCourceList.count * 3 - 1 {
                self.delegate?.getedCourceQuestion?()
            }
            else {
                self.sessionCount++
            }
        })
        task.resume()
    }
    
    
    /**
    クリッカー情報の取得
    
    :param: index:courceListの配列番号
    :param: url:clickerDBのURL
    */
    func getClickerDB(index: Int, url: String){
        let urlString = url
        var url = NSURL(string: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            //テーブル情報の取得
            let headRegexClickerQuestion = "<br /><div class=\"defaulttemplate\"><table class=\"mod-data-default-template\">"
            let tailRegexClickerQuestion = "</tbody>"
            
            //テーブルの各項目を検索
            let headRegexContent = "<td class=\"template-token cell c1 lastcol\" style=\"\">"
            let tailRegexContent = "</td>"
            
            // クリッカーのDBのIDを取得
            let headRegexClickerDBID = "mod/data/view.php?d="
            let tailRegexClickerDBID = "&"
            var clickerDBID = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexClickerDBID).location + count(headRegexClickerDBID))
            clickerDBID = (clickerDBID as NSString).substringToIndex((clickerDBID as NSString).rangeOfString(tailRegexClickerDBID).location)
            
            //クリッカー問題を保存するインスタンス
            var clickerContent = ClickerContent()
            clickerContent.clickerDBURL = urlString
            clickerContent.clickerDBID = clickerDBID
            
            while(htmlSource!.rangeOfString(headRegexClickerQuestion).length > 0){
                var headRegex = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexClickerQuestion).location)
                htmlSource = (headRegex as NSString).substringFromIndex((headRegex as NSString).rangeOfString(tailRegexClickerQuestion).location)
                
                //一問分の情報を取得
                headRegex = (headRegex as NSString).substringToIndex((headRegex as NSString).rangeOfString(tailRegexClickerQuestion).location + count(headRegexClickerQuestion))
                
                //クリッカー問題を保存するインスタンス
                var clickerSubject = ClickerSubject()
                clickerSubject.clickerDBID = clickerDBID
                
                // 結果があるかどうか
                var resultEmpty = false
                
                var tagCount = 0
                
                while((headRegex as NSString).rangeOfString(headRegexContent).length > 0){
                    var contents = (headRegex as NSString).substringFromIndex((headRegex as NSString).rangeOfString(headRegexContent).location + count(headRegexContent))
                    headRegex = contents
                    contents = (contents as NSString).substringToIndex((contents as NSString).rangeOfString(tailRegexContent).location)
                    
                    switch(tagCount) {
                        // タイトルの処理
                    case 0:
                        clickerSubject.origneTitle = contents
                        while((contents as NSString).rangeOfString("<p>").length > 0) {
                            var tmptitle = contents.stringByReplacingOccurrencesOfString("<p>", withString: "", options: nil, range: nil)
                            contents = tmptitle.stringByReplacingOccurrencesOfString("</p>", withString: "\n", options: nil, range: nil)
                        }
                        //タイトル末尾の改行を削除
                        if((contents as NSString).rangeOfString("\n").length > 0) {
                            contents = (contents as NSString).substringToIndex((contents as NSString).rangeOfString("\n", options:NSStringCompareOptions.BackwardsSearch).location)
                        }
                        
                        clickerSubject.title = contents
                        
                        
                        // 選択肢の処理
                    case 1:
                        while((contents as NSString).rangeOfString("<p>").length > 0) {
                            contents = (contents as NSString).substringFromIndex((contents as NSString).rangeOfString("<p>").location + 3)
                            var selectContent = (contents as NSString).substringToIndex((contents as NSString).rangeOfString("</p>").location)
                            clickerSubject.answerList.append(selectContent)
                        }
                        
                    default:
                        if (contents as NSString).rangeOfString("<p>").length > 0 {
                            resultEmpty = true
                        }
                    }
                    
                    tagCount++
                }
                
                // 結果がない場合とユーザ情報がない問題を選択する
                if !resultEmpty {
                    clickerContent.clickerSubjectList.append(clickerSubject)
                }
                
            }
            MoodleInfo.moodleInfoInstance.selectCource.clickerContentList.append(clickerContent)
            self.delegate?.getedClickerInfo?()
            println("END")
            
        })
        task.resume()
    }
    
    /**
    トークンIDの取得
    
    :param: service:webサービスの名前
    */
    func getTokenID(service:String) {

    let accessURL = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + "/login/token.php"

        //アクセスするURL(moodleログインページ)
        var url = NSURL(string: accessURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"

        //POSTパラメータセット
        req.HTTPBody = "username=\(self.userID)&password=\(self.password)&service=\(service)".dataUsingEncoding(NSUTF8StringEncoding)
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            var headRegexTokenID = "\"token\":\""

            //htmlソースの頭部分の切り取り
            self.tokenID = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexTokenID).location + count(headRegexTokenID))
            
            //完成したトークンID
            self.tokenID = (self.tokenID as NSString).substringToIndex((self.tokenID as NSString).rangeOfString("\"}").location)
            self.delegate?.getedTokenID?()
        })
        task.resume()
    }
    
    /**
    ログアウト
    */
    func logout(){
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL) + self.logoutURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        var task = session.dataTaskWithRequest(req)
        task.resume()
        
    }
    
    /**
    データをcoredataに保存
    */
    func setMoodleInfo() {
        
        UserInfo.userInfoInstance.setInfo(self.userID, password: self.password, name: self.name, number: self.number)
        
        MoodleInfo.moodleInfoInstance.moodleURL = self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL
        MoodleInfo.moodleInfoInstance.myProfileURL = self.myProfileURL
        MoodleInfo.moodleInfoInstance.editMyProfileURL = self.editMyProfileURL
        MoodleInfo.moodleInfoInstance.tokenID = self.tokenID
        
        MoodleInfo.moodleInfoInstance.courceList = self.selectCourceList
    }
    
}
