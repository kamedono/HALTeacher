//
//  GoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit



class FinishSubjectViewController: UIViewController {
    // 戻るボタンを用意
    var backdButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "授業強制終了画面"
        //初期化
        backdButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "pushBuckButton")
        //UIBarButtonItemをナビゲーションバーの左側に設置
        self.navigationItem.leftBarButtonItem = backdButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /**
    戻るボタンをタップした時のアクション
    */
    func pushBuckButton() {
        self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.rightViewController as! RightViewController).prevViewController , close: true)
    }
}