//
//  QuestionAnswers.swift
//  XML
//
//  Created by sotuken on 2015/08/03.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

@objc(QuestionAnswer)
class QuestionAnswer: NSObject{
    
    // 解答文
    var questionText: String = ""
    
    // 正誤判定結果、点数？
    var judge: String = ""
    
    // 回答に対するコメント文
    var feedback: String = ""
    
    // 問題の番号
    var questionNumber: Int = 0
    
    // マーク
    var mark: String = ""
    
    override init(){
        super.init()
        self.questionText = ""
        self.judge = ""
        self.feedback = ""
        self.questionNumber = 0
        self.mark = "未解答"
    }
    
    /**
    NSDataから元のデータに変換する関数
    */
    init(data: NSData) {
        if NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject] != nil {
            var dataArray: Array<AnyObject> = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [AnyObject]
            self.questionText = dataArray[0] as! String
            self.judge = dataArray[1] as! String
            self.feedback = dataArray[2] as! String
            let questionNumberStr = dataArray[3] as! String
            self.questionNumber = questionNumberStr.toInt()!
            self.mark = dataArray[4] as! String
        }
    }
    
    /**
    NSDataに変換する関数
    */
    func archiveNSData() -> NSData{
        var dataArray: [AnyObject] = []
        
        dataArray.append(self.questionText)
        dataArray.append(self.judge)
        dataArray.append(self.feedback)
        dataArray.append(self.questionNumber.description)
        dataArray.append(self.mark)
        
        return NSKeyedArchiver.archivedDataWithRootObject(dataArray)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.questionText = aDecoder.decodeObjectForKey("questionText") as! String
        self.judge = aDecoder.decodeObjectForKey("judge") as! String
//        self.feedback = aDecoder.decodeObjectForKey("feedback") as! String
        self.questionNumber = aDecoder.decodeObjectForKey("questionNumber") as! Int
        self.mark = aDecoder.decodeObjectForKey("mark") as! String
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.questionText, forKey: "questionText")
        aCoder.encodeObject(self.judge, forKey: "judge")
//        aCoder.encodeObject(self.feedback, forKey: "feedback")
        aCoder.encodeObject(self.questionNumber, forKey: "questionNumber")
        aCoder.encodeObject(self.mark, forKey: "mark")
    }
}