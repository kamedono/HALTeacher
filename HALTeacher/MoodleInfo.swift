//
//  MoodleInfo.swift
//  NewHALTitle
//
//  Created by Toshiki Higaki on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

/**
各コースにあるクリッカーのタイトルと選択肢の構造体
*/
struct ClickerSubject {
    var origneTitle: String
    var title: String
    var answerList: [String]
    var clickerDBID: String
    
    init() {
        self.origneTitle = ""
        self.title = ""
        self.answerList = []
        self.clickerDBID = ""
    }
}

/**
各コースにあるクリッカーの構造体
*/
struct ClickerContent {
    var clickerDBURL: String
    var clickerDBName: String
    var clickerDBID: String
    var clickerSubjectList: [ClickerSubject]
    
    init() {
        self.clickerDBURL = ""
        self.clickerDBName = ""
        self.clickerDBID = ""
        self.clickerSubjectList = []
    }
    
    init(url: String, name: String, id: String) {
        self.clickerDBURL = url
        self.clickerDBName = name
        self.clickerDBID = id
        self.clickerSubjectList = []
    }
}


/**
各コースにあるクイズの構造体
*/
struct QuizInfo {
    var quizName: String
    var quizURL: String
    
    init(name: String, url: String) {
        self.quizName = name
        self.quizURL = url
    }
    
    init(){
        self.quizName = ""
        self.quizURL = ""
    }
}


/**
各コースの構造体
*/
struct CourceContent {
    // コースの名前
    var courceName: String
    
    // コースのID番号
    var courceNumber: String
    
    // コースのURL
    var courceURL: String
    
    // コースを選択している学生の名前リスト
    var studentList: [String]
    
    // コースに登録されているクイズの情報リスト
    var quizInfoList: [QuizInfo]
    
    // コースに登録されているクリッカーの情報リスト
    var clickerContentList: [ClickerContent]
    
    init(name: String, number: String, url: String) {
        self.courceName = name
        self.courceNumber = number
        self.courceURL = url
        self.studentList = []
        self.quizInfoList = []
        self.clickerContentList = []
    }
    
    init(){
        self.courceName = ""
        self.courceNumber = ""
        self.courceURL = ""
        self.studentList = []
        self.quizInfoList = []
        self.clickerContentList = []
    }
    
}


/**
Moodleの情報
*/
class MoodleInfo: NSObject {
    
    static var moodleInfoInstance = MoodleInfo()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let coreData = CoreDataModule()
    
    var autoFlag: Bool {
        get { return defaults.boolForKey("autoFlag") ?? true }
        set { defaults.setObject(newValue, forKey: "autoFlag") }
    }
    
    //構造体の宣言
    var moodleURL: String {
        get { return defaults.stringForKey("moodleURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "moodleURL") }
    }
    
    //マイプロファイルのURL
    var myProfileURL: String {
        get { return defaults.stringForKey("myProfileURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "myProfileURL") }
    }
    
    //マイプロファイル編集ページのURL
    var editMyProfileURL: String {
        get { return defaults.stringForKey("editMyProfileURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "editMyProfileURL") }
    }

    // トークンを保存
    var tokenID: String {
        get { return defaults.stringForKey("tokenID") ?? "" }
        set { defaults.setObject(newValue, forKey: "tokenID") }
    }
    
    // トークンを保存
    var selectButton: Int {
        get { return defaults.integerForKey("selectButton") ?? 0 }
        set { defaults.setObject(newValue, forKey: "selectButton") }
    }
    
    //ボタンのテキスト
    var buttonText: [[String]] = [["A","B","C","D","E","F","G","H"],["あ","い","う","え","お","か","き","く"],["①","②","③","④","⑤","⑥","⑦","⑧"]]
    
    // コースリストを別で保存
    var courceListTemp: [CourceContent] = []
    
    // 選択したコースリストを保存
    var selectCource: CourceContent!
    
    // コースを保存する配列
    var courceList: [CourceContent] {
        get { return courceListTemp }
        set {
            // コースの情報を削除
            coreData.deleteCource()
            
            // Coredataに書き込む
            for cource in newValue {
                coreData.addCource(cource.courceName, number: cource.courceNumber, url: cource.courceURL)
                
                // コースを登録している学生を保存
                for student in cource.studentList {
                    coreData.addCourceStudent(student, courceNumber: cource.courceNumber)
                }
                
                // コースに登録してあるクイズを保存
                for quiz in cource.quizInfoList {
                    coreData.addQuiz(quiz.quizName, quizURL: quiz.quizURL, courceNumber: cource.courceNumber)
                }
                
                // コース内のクリッカー情報を保存
                for clicker in cource.clickerContentList {
                    coreData.addClicker(clicker.clickerDBName, clickerURL: clicker.clickerDBURL, clickerID: clicker.clickerDBID, courceNumber: cource.courceNumber)
                }
                
            }
            self.courceListTemp = newValue
        }
    }
    
    override init(){
        self.courceListTemp = coreData.getCourceNameList()
        
    }
    
    /**
    選択したコースのクリッカー情報をすべて取得
    */
    func getClickerSubjectList() -> [ClickerSubject] {
        var subjectList: [ClickerSubject] = []
        for clickerContent in self.selectCource.clickerContentList {
            for clickerSubject in clickerContent.clickerSubjectList {
                subjectList.append(clickerSubject)
            }
        }
        return subjectList
    }
    
}