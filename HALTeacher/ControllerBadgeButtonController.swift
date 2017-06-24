//
//  ControllerBadgeButton.swift
//  SlideMenuControllerSwift_Test
//
//  Created by sotuken on 2015/08/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

/**
制御ボタンのバッジ変更をするプロトコル
*/
protocol ControllerBadgeButtonControllerDelegate {
    func setButtonBadgeNumber(number: Int, studentName: String)
    func setButtonBadgeNumberType(number: Int, studentName: String, type: String)
}

class ControllerBadgeButtonController: NSObject {
    //singleton作成
    static var controllerBadgeButtonControllerInstance = ControllerBadgeButtonController()

    //delegate作成
    var delegate: ControllerBadgeButtonControllerDelegate?
    
    //バッジの番号
    var badgeNumber = 0
 
    /**
    学生のがホームボタンなどを押した時
    */
    func addBadgeNumber(studentName: String) {
        println("メソッド呼ばれてる")
        badgeNumber++
        self.delegate?.setButtonBadgeNumber(self.badgeNumber, studentName: studentName)
    }
    

    /**
    学生のがホームボタンなどを押した時
    */
    func addBadgeNumber(studentName: String, type: String) {
        println("メソッド呼ばれてる")
        badgeNumber++
        self.delegate?.setButtonBadgeNumberType(self.badgeNumber, studentName: studentName, type: type)
    }
//    func deleteBadgeNumber(){
//        badgeNumber--
//        self.delegate?.setButtonBadgeNumber(badgeNumber)
//    }
    
    /**
    教員が確認した際のリセット
    */
    func resetBadgeNumber(studentName: String) {
        badgeNumber = 0
        self.delegate?.setButtonBadgeNumber(badgeNumber, studentName: studentName)
    }
    
    
}