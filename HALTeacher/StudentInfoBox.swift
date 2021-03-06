//
//  StudentInfoBox.swift
//  SlideMenuControllerSwift_Test
//
//  Created by sotuken on 2015/08/28.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class StudentInfoBox {
    static let studentInfoBoxInstance = StudentInfoBox()
    
    var studentList: [StudentInfo]

    var selectStudentList: [StudentInfo]
    
    init() {
        self.studentList = []
        self.selectStudentList = []
//        let student = StudentInfo(userID: "ap14005", name: "higaki", absent: false, lock: false)
//        student.UUID = NSUUID(UUIDString: "1D57D189-86B6-04EA-0B52-D24DC69207BA")
//        self.studentList.append(student)
    }
    
    /**
    UUIDから学生の情報を返す
    */
    func getStudentInfoForUUId(uuid: NSUUID) -> StudentInfo? {
        for var i: Int = 0; i<studentList.count; i++ {
            if studentList[i].UUID == uuid {
                return self.studentList[i]
            }
        }
        return nil
    }
    
    
    /**
    名前から学生の情報を返す
    */
    func getStudentInfo(name: String) -> StudentInfo? {
        for var i: Int = 0; i<studentList.count; i++ {
            if studentList[i].name == name {
                return self.studentList[i]
            }
        }
        return nil
    }
    
    /**
    IDから学生の情報を返す
    */
    func getStudentInfoForID(id: String) -> StudentInfo? {
        for var i: Int = 0; i<studentList.count; i++ {
            if studentList[i].userID == id {
                return self.studentList[i]
            }
        }
        return nil
    }
    
    /**
    学生の名前リストを返す
    */
    func getNameList() -> [String] {
        var nameList: [String] = []
        for studentInfo in self.studentList {
            nameList.append(studentInfo.name)
        }
        return nameList
    }
    
    
    /**
    学生のインデックス番号を返す
    */
    func getStudentIndex(uuid: NSUUID) -> Int {
        for var i: Int = 0; i<studentList.count; i++ {
            if studentList[i].UUID == uuid {
                return i
            }
        }
        return -1
    }
    
    
    /**
    学生のインデックス番号を返す
    */
    func getStudentIndex(userID: String) -> Int {
        for var i: Int = 0; i<studentList.count; i++ {
            if studentList[i].userID == userID {
                return i
            }
        }
        return -1
    }
    
    
    /**
    学生のインデックス番号を返す
    */
    func getStudentNameIndex(name: String) -> Int {
        for var i: Int = 0; i<studentList.count; i++ {
            if studentList[i].name == name {
                return i
            }
        }
        return -1
    }
    
    /**
    学生のUUIDリストを返す
    */
    func getUUIDList() -> [NSUUID] {
        var uuidList: [NSUUID] = []
        for studentInfo in self.studentList {
            uuidList.append(studentInfo.UUID!)
        }
        return uuidList
    }

    
    /**
    選択した学生のUUIDリストを返す
    */
    func getSelectUUIDList() -> [NSUUID] {
        var uuidList: [NSUUID] = []
        for studentInfo in self.selectStudentList {
            uuidList.append(studentInfo.UUID!)
        }
        return uuidList
    }
    
    /**
    初期化の代わり
    */
    func setEmpty() {
        self.selectStudentList = []
    }
}
