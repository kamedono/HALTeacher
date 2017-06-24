
//
//  Question.swift
//  XML_reader
//
//  Created by sotuken on 2015/07/19.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
class QuestionXML : NSObject , NSCoding {
    var id :String! = ""
    var name :String! = ""
    var questionNumber: Int = 0
    var question_text :String! = ""
    var question_file :String = ""
    var answers :Array<QuestionAnswer> = []
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey("id") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.questionNumber = aDecoder.decodeObjectForKey("questionNumber") as! Int
        self.question_text = aDecoder.decodeObjectForKey("question_text") as! String
        self.question_file = aDecoder.decodeObjectForKey("question_file") as! String
        self.answers = aDecoder.decodeObjectForKey("answers") as! Array<QuestionAnswer>
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.questionNumber, forKey: "questionNumber")
        aCoder.encodeObject(self.question_text, forKey: "question_text")
        aCoder.encodeObject(self.question_file, forKey: "question_file")
        aCoder.encodeObject(self.answers, forKey: "answers")
    }
}