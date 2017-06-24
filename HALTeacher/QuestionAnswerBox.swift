//
//  QuestionAnswerBox.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/08/21.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

/**
全学生の解答
*/
class QuestionAnswerBox {
    
    static let questionAnswerBoxInstance = QuestionAnswerBox()

    // 問題の解答結果を格納
    var studentsAnswer: Dictionary<NSUUID, StudentQuestionAnswers> = [:]
    
    // 解答の集計<問題番号, 集計配列>
    var questionAnswerCount: Dictionary<Int, [Int]> = [:]
    
    // 正誤の集計<問題番号, 正解数配列>
    var questionCorrectCount: Dictionary<Int, [Int]> = [:]
    
    
    //初期設定
    init() {
        self.studentsAnswer = [:]
    }
    
    // 初期化の代わり
    func setEmpty() {
        self.studentsAnswer = [:]
        self.questionAnswerCount = [:]
        self.questionCorrectCount = [:]
    }
}