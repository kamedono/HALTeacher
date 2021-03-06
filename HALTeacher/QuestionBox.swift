//
//  QuestionBox.swift
//  XML_reader
//
//  Created by sotuken on 2015/07/19.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
class QuestionBox : NSObject , NSCoding {
    
    static let questionBoxInstance = QuestionBox()
    
    // 問題の題名setCourceText
    var questionTitle: String = ""
    
    // パースした問題データ
    var questions: [QuestionXML] = []
    
    // 教員が選択した問題
    var selectQuestion: [QuestionXML] = []
    
    // 選択した問題のIDのみの配列（あえて作った
    var questionID :[Int] = []
    
    // シード値 todo
    var seed: Int = 1
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.questions = aDecoder.decodeObjectForKey("questions") as! Array<QuestionXML>
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.questions, forKey: "questions")
    }
    
    // 初期化の代わり
    func setEmpty() {
        self.questionTitle = ""
        self.questions = []
        self.selectQuestion = []
    }
}
