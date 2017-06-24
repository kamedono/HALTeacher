//
//  HTMLParser.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/08/29.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit


/**
htmlの文字を消す

:param: part 対象の文字列
*/
func htmlParse(part: String)->String{
    
    var parsedText = ""
    var startFlag = false
    var endFlag = false
    //<p>タグの有無を確認
    if(part.rangeOfString("<p>")?.isEmpty == false) {
        startFlag = true
    }
    if(part.rangeOfString("</p>")?.isEmpty == false){
        endFlag = true
    }
    
    parsedText = part
    
    while(startFlag == true || endFlag == true ) {
        
        parsedText = parsedText.stringByReplacingOccurrencesOfString("<p>", withString: "", options: nil, range: nil)
        parsedText = parsedText.stringByReplacingOccurrencesOfString("</p>", withString: "\n", options: nil, range: nil)
        parsedText = parsedText.stringByReplacingOccurrencesOfString("<br>", withString: "", options: nil, range: nil)
        parsedText = parsedText.stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: nil, range: nil)
        
        //他にもタグがあるか確認
        if(parsedText.rangeOfString("<p>")?.isEmpty == false) {
            startFlag = true
        }else{
            startFlag = false
        }
        if(parsedText.rangeOfString("</p>")?.isEmpty == false){
            endFlag = true
        }else{
            endFlag = false
        }
    }
    return parsedText
}

/**
マークから配列番号を返す

:param: mark マーク
*/
func getMarkNumber(mark: String) -> Int{
    switch(mark) {
    case "A":
        return 0
    case "B":
        return 1
    case "C":
        return 2
    case "D":
        return 3
    case "E":
        return 4
    case "F":
        return 5
    case "G":
        return 6
    case "H":
        return 7
    default:
        return -1
    }
}

/**
マークから配列番号を返す

:param: mark マーク
*/
func getMark(number: Int) -> String {
    switch(number) {
    case 0:
        return "A"
    case 1:
        return "B"
    case 2:
        return "C"
    case 3:
        return "D"
    case 4:
        return "E"
    case 5:
        return "F"
    case 6:
        return "G"
    case 7:
        return "H"
    default:
        return "nil"
    }
}

/**
現在の一番上のviewを取得
*/
func getTopMostController() -> UIViewController {
    // windowKeyの取得？
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDel.window?.makeKeyAndVisible()

    var topController: UIViewController = (UIApplication.sharedApplication()).keyWindow!.rootViewController!
    
    while ((topController.presentedViewController) != nil) {
        topController = topController.presentedViewController!
    }
    
    return topController
}


/**
現在の一番上のviewControllerを取得
*/
func getTopViewController() -> UIViewController {
    // windowKeyの取得？
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDel.window?.makeKeyAndVisible()

    let a = (UIApplication.sharedApplication()).keyWindow
    let b = a?.rootViewController
    var topController: UIViewController = (UIApplication.sharedApplication()).keyWindow!.rootViewController!
    var topViewController: UIViewController = (UIApplication.sharedApplication()).keyWindow!.rootViewController!
    var i=0
    
    while ((topController.presentedViewController) != nil) {
        topController = topController.presentedViewController!
        if topController as? UIAlertController == nil {
            topViewController = topController
        }
    }
    
    return topViewController
}


/**
AlertViewの作成
*/
func lockAlertView(viewController: UIViewController) {
    //indicator宣言
    var indicator :UIActivityIndicatorView!

    //ダウンロード中のalertView
    var downloadingAlertView :UIAlertController!
    
    //indicatorの初期化
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    var alertView = UIAlertController(title: "アラートじゃああああ", message:"アラートかああ？？？", preferredStyle: .Alert)
    
    var okAction = UIAlertAction(title: "ダウンロード", style: UIAlertActionStyle.Default) {
        UIAlertAction in
        
        //前のalertviewの削除（意味ないかも）
        alertView.dismissViewControllerAnimated(true, completion: nil)

        //AlertController作成
        downloadingAlertView = UIAlertController(title: "ダウンロード中", message: "\n\n", preferredStyle: .Alert)
        //indicatorの位置決め
        indicator.center = CGPointMake(alertView.view.frame.size.width/2 ,downloadingAlertView.view.frame.size.height/15)
        
        //indicatorを回す
        indicator.startAnimating()
        
        //AlertControllerにindicatorを追加させる
        downloadingAlertView.view.addSubview(indicator)
        
        //Viewを見せる
        viewController.presentViewController(downloadingAlertView, animated: true, completion: nil)
    }
    
    var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
        UIAlertAction in
    }
    
    // Add the actions
    alertView.addAction(okAction)
    alertView.addAction(cancelAction)
    
    // Present the controller
    viewController.presentViewController(alertView, animated: true, completion: nil)
}


/**
AlertViewの削除
*/
func dismissLockAlertView(viewController: UIViewController) {
    for subview in viewController.view.subviews {
        println("subview\(subview)")
        if let alertView = subview as? UIAlertController {
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}


// 色パターン１
var colorList1: [UIColor] = [
    UIColor.hexStr("#ff1e1e", alpha: 1),
    UIColor.hexStr("#f39800", alpha: 1),
    UIColor.hexStr("#ffff28", alpha: 1),
    UIColor.hexStr("#adff2f", alpha: 1),
    UIColor.hexStr("#00ff00", alpha: 1),
    UIColor.hexStr("#00bfff", alpha: 1),
    UIColor.hexStr("#0000cd", alpha: 1),
    UIColor.hexStr("#962dff", alpha: 1),
]

// 色パターン2
var colorList2: [UIColor] = [
    UIColor.hexStr("#ff6633", alpha: 1),
    UIColor.hexStr("#ffa54c", alpha: 1),
    UIColor.hexStr("#ffff66", alpha: 1),
    UIColor.hexStr("#ccff99", alpha: 1),
    UIColor.hexStr("#66ff99", alpha: 1),
    UIColor.hexStr("#99ffff", alpha: 1),
    UIColor.hexStr("#3066ff", alpha: 1),
    UIColor.hexStr("#cc99cc", alpha: 1),
]