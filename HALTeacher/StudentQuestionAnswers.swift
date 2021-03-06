//
//  QuestionAnswerBox.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/08/21.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

/**
学生一人あたりの解答
*/
class StudentQuestionAnswers {
    
    //問題の解答結果を格納
    var studentAnswer: Dictionary<Int, QuestionAnswer> = [:]
    
    //解答のマークを保存（A,B,C,D...）
    var studentAnswerMark: [String] = []
    
    // 解答の集計
    var studentsAnswerMarkCount: [Int] = []
    
    //初期設定
    init() {
        self.studentAnswer = [:]
        //未解答の初期化
        for var i=0; i < QuestionBox.questionBoxInstance.questions.count; i++ {
            studentAnswerMark.append("未解答")
        }
    }
    
    // 初期化の代わり
    func setEmpty() {
        self.studentAnswer = [:]
        self.studentAnswerMark = []
        self.studentsAnswerMarkCount = []
    }
    
    /**
    合計点数を取得
    */
    func getScore() -> Int {
        // 正誤の集計
        var studentCorrectCount: Int = 0
        for answer in self.studentAnswer.values.array {
            studentCorrectCount += answer.judge.toInt()!
        }
        let sumScore = QuestionBox.questionBoxInstance.selectQuestion.count * 100

        if studentCorrectCount != 0 {
            let par = Double(studentCorrectCount) / Double(sumScore)
            let score = Int(par * 100)
            return score / 10
        }
        return 0
    }
}
