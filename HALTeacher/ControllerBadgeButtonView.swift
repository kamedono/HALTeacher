//
//  ControllerBadgeButton.swift
//  SlideMenuControllerSwift_Test
//
//  Created by sotuken on 2015/08/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

struct BadgeParamator {
    var label = UILabel()
    //バッジの数値
    var badgeNumber = 0
    //badgeの文字の大きさ
    var fontSize:CGFloat = 15
    //円の大きさ
    var CircleSize:CGFloat = 20
}

class ControllerBadgeButtonView: UIButton, ControllerBadgeButtonControllerDelegate{
    
    var badge = BadgeParamator()
    var badgeNumber = ControllerBadgeButtonController.controllerBadgeButtonControllerInstance.badgeNumber
    
    /**
    ストーリーボードのサブクラスにした場合のinit
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        badge.label.layer.position = CGPoint(x: self.layer.bounds.width/2+5, y: -5)
        //バッジナンバーが0以上なら出力
        if(badgeNumber>0){
            createBadge()
        }
    }
    
    /**
    バッジ作成を行うメソッド
    */
    func createBadge() {
        //バッジ作成
        badge.label.text = String(badgeNumber)
        badge.label.font = UIFont.systemFontOfSize(badge.fontSize)
        badge.label.layer.backgroundColor = UIColor.redColor().CGColor
        badge.label.textColor = UIColor.whiteColor()
        badge.label.layer.cornerRadius = 10
        badge.label.textAlignment = NSTextAlignment.Center
        var frame:CGRect = badge.label.frame
        frame.size.height = badge.CircleSize
        frame.size.width = badge.CircleSize
        badge.label.frame = frame
        self.addSubview(badge.label)
    }
    
    /**
    ポッパービューを作成するメソッド
    */
    func createPopoverViewController(studentName: String) {
        dispatch_async(dispatch_get_main_queue(), {
            println("setButtonBadgeNumber")
            // ポッパーとなるViewControllerを生成.
            //let showViewController = PopoverControllerViewController()
            var showViewController: UIViewController = UIViewController()
            // ViewControllerのサイズを指定.
            showViewController.preferredContentSize = CGSizeMake(200, 100)
            //コンテンツViewControllerの背景を青色に設定
            showViewController.view.backgroundColor = UIColor.whiteColor()
            //接続を切った学生の情報を表示するラベル
            var absenceStudentLabel = UILabel(frame: CGRectMake(10,10,170,200))
            absenceStudentLabel.text = "\(studentName)\nと接続が切れました"
            absenceStudentLabel.numberOfLines = 10
            absenceStudentLabel.sizeToFit()
            showViewController.view.addSubview(absenceStudentLabel)
            
            // PopverControllerを生成してコンテンツViewControllerをセット.
            let popover = UIPopoverController(contentViewController: showViewController)
            
            // Popverの条件をそれぞれ指定.
            popover.presentPopoverFromRect(
                // 大きさを指定.
                CGRectMake(5, self.bounds.height/2, 5, 10),
                // 表示するViewを指定.
                inView: self,
                // 矢印の向きを指定.
                permittedArrowDirections: UIPopoverArrowDirection.Up,
                // アニメーション.
                animated: true)
        })
    }
    
    
    /**
    ポッパービューを作成するメソッド
    */
    func createPopoverViewController(studentName: String, type: String) {
        dispatch_async(dispatch_get_main_queue(), {
            // ポッパーとなるViewControllerを生成.
            //let showViewController = PopoverControllerViewController()
            var showViewController: UIViewController = UIViewController()
            // ViewControllerのサイズを指定.
            showViewController.preferredContentSize = CGSizeMake(200, 100)
            //コンテンツViewControllerの背景を青色に設定
            showViewController.view.backgroundColor = UIColor.whiteColor()
            //接続を切った学生の情報を表示するラベル
            var absenceStudentLabel = UILabel(frame: CGRectMake(10,10,170,200))
            if type == "pushHome" {
                absenceStudentLabel.text = "\(studentName)\nがホームボタンを押しました"
            }
            else {
                absenceStudentLabel.text = "\(studentName)\nがアプリを終了しました"
            }
            absenceStudentLabel.numberOfLines = 10
            absenceStudentLabel.sizeToFit()
            showViewController.view.addSubview(absenceStudentLabel)
            
            // PopverControllerを生成してコンテンツViewControllerをセット.
            let popover = UIPopoverController(contentViewController: showViewController)
            
            // Popverの条件をそれぞれ指定.
            popover.presentPopoverFromRect(
                // 大きさを指定.
                CGRectMake(5, self.bounds.height/2, 5, 10),
                // 表示するViewを指定.
                inView: self,
                // 矢印の向きを指定.
                permittedArrowDirections: UIPopoverArrowDirection.Up,
                // アニメーション.
                animated: true)
        })
    }
    
    func setButtonBadgeNumber(number: Int, studentName: String) {
        badgeNumber = number
        createBadge()
        if number != 0 {
            var viewController = getTopViewController()
            viewController.rigahtTablesViewReload()
            
            createPopoverViewController(studentName)
        }
    }
    
    func setButtonBadgeNumberType(number: Int, studentName: String, type: String) {
        badgeNumber = number
        createBadge()
        if number != 0 {
            var viewController = getTopViewController()
            viewController.rigahtTablesViewReload()
            
            createPopoverViewController(studentName, type: type)
        }
    }
    
}