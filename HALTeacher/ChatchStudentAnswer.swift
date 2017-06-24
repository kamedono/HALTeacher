//
//  ChatchStudentAnswer.swift
//  HALTeacher
//
//  Created by sotuken on 2015/08/05.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class ChatchStudentAnswer :CoreCentralManagerDelegateForCoreData {

    init(){
        CoreCentralManager.coreCentralInstance.delegateForCoreData = self
    }

    //学生からのデータを受信
    func didGetStudentAnswer(answer: [String], student: StudentInfo) {
        var coreDataModule = CoreDataModule()
        var judge = answer[2].toInt()
        coreDataModule.update_question(student.userID, q_id: answer[0], answer: answer[1], judge: judge!)
    }
}
