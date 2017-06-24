//
//  SecondWindow.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class SecondWindow: UIWindow {
    static var secondWindowInstance = SecondWindow()
    var secondWindowState:String = ""
    
    var screenWidth: CGFloat?
    var secondScreenWidth: CGFloat?
    var screenHeight: CGFloat?
    var secondScreenHeight: CGFloat?

    //セカンビューの状態をセット
    func setSecondViewState(state:String){
        secondWindowState = state
    }
    
    func changeSecondWindow(secondScreen:UIScreen,startViewController:UIViewController) {
        self.screen = secondScreen
        var x:CGFloat = self.screen.bounds.origin.x
        var y:CGFloat = self.screen.bounds.origin.y
        
        var width:CGFloat = self.screen.bounds.width
        var height:CGFloat = self.screen.bounds.height
        
        println(startViewController.description)
        
        var frame:CGRect = CGRect(x: x, y: y, width: width, height: height)
        startViewController.view.frame = CGRectMake(0, 0, self.screen.bounds.width, self.screen.bounds.height)
        
        self.screenWidth = self.screen.bounds.width
        self.secondScreenWidth = startViewController.view.bounds.width
        
        self.screenHeight = self.screen.bounds.height
        self.secondScreenHeight = startViewController.view.bounds.height
        
        println("ディスプレイの幅\(self.screen.bounds.width)")
        println("セカンドビューの幅\(startViewController.view.bounds.width)")
        //        secondViewController
        self.makeKeyAndVisible()
        self.addSubview(startViewController.view)
        
        // windowKeyの取得？
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.window?.makeKeyAndVisible()
    }
    
}