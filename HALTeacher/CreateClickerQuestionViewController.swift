//
//  File.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class CreateClickerQuestionViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var choicePicker: UIPickerView!
    
    @IBOutlet weak var questionShowLabel: UILabel!
    @IBOutlet weak var choiceShowLabel: UILabel!
    
    var pickerItemTextField: [UITextField]!
    let choiceList = ["2","3","4","5","6"]
    
    var keepList = ["","","","","",""]
    
    var setLoop: Int = 2
    var delLoop: Int = 0
    
    var beforeLoop = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerItemTextField = [UITextField](count: 6, repeatedValue: UITextField())
        
        //ピッカーを黒枠で囲む
        choicePicker.layer.borderColor = UIColor.blackColor().CGColor
        choicePicker.layer.borderWidth = 1
        
        choicePicker.dataSource = self
        choicePicker.delegate = self
        
        questionTextField.delegate = self
        
        //テキストフィールドが空白のとき
        //questionTextField.placeholder = ""
        
        
        //初期値
        choiceShowLabel.text = "2"
        
        setInit()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        //ラベルに反映、変数に保存
        questionShowLabel.text = "問題：" + questionTextField.text
        
        
        // returnでキーボードが閉じる
        questionTextField.resignFirstResponder()
        
        //        pickerItemTextField.resignFirstResponder()
        
        return true
    }
    
    func setInit() {
        for(var i=0; i<setLoop; i++) {
            // UITextFieldを作成する.
            pickerItemTextField[i] = UITextField(frame: CGRectMake(0,0,200,30))
            
            // Delegateを設定する.
            pickerItemTextField[i].delegate = self
            
            // 枠を表示する.
            pickerItemTextField[i].borderStyle = UITextBorderStyle.RoundedRect
            
            // UITextFieldの表示する位置を設定する.
            pickerItemTextField[i].layer.position = CGPoint(x: self.view.bounds.width/2+250,y: CGFloat(100+45*i));
            
            // Viewに追加する.
            self.view.addSubview(pickerItemTextField[i])
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent compontent: Int) -> Int {
        return choiceList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return choiceList[row]
    }
    
    //
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dispatch_async(dispatch_get_main_queue(), {
            self.choiceShowLabel.text = self.choiceList[row]
            
            self.setLoop = self.choiceList[row].toInt()!
            println("ピッカーの値\(self.setLoop)")
            
            // 前の値より大きかったら追加
            if self.beforeLoop < self.setLoop {
                for(var i=self.beforeLoop; i<self.setLoop; i++) {
                    
                    //初期化が始まる前までに処理を済ませないと新たに初期化されてしまう
                    self.keepList[i] = self.pickerItemTextField[i].text
                    
                    
                    // UITextFieldを作成する.
                    self.pickerItemTextField[i] = UITextField(frame: CGRectMake(0,0,200,30))
                    
                    // Delegateを設定する.
                    self.pickerItemTextField[i].delegate = self
                    
                    // 枠を表示する.
                    self.pickerItemTextField[i].borderStyle = UITextBorderStyle.RoundedRect
                    
                    // UITextFieldの表示する位置を設定する.
                    self.pickerItemTextField[i].layer.position = CGPoint(x: self.view.bounds.width/2+250,y: CGFloat(100+45*i));
                    
                    // View  let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
                    
                    
                    
                    
                    //一つのキューに処理をまとめて書かないとダメっぽい
                    println("追加するよ\(i)")
                    self.view.addSubview(self.pickerItemTextField[i])
                    
                    //保存しておいたテキストをフィールドに追加
                    self.pickerItemTextField[i].text = self.keepList[i]
                }
            }
                // 前の値より小さかったら削除
            else {
                //                self.delLoop = self.setLoop
                for(var i=self.choiceList.count; i>=self.setLoop; i--) {
                    self.pickerItemTextField[i].removeFromSuperview()
                    println("削除するよ\(i)")
                }
            }
        })
        self.beforeLoop = self.setLoop
        
        
        println("ListCount:"+"\(choiceList.count)")
        println("subView:"+"\(self.view.subviews)")
        
        
    }
    
    
    
    
    @IBAction func startButton(sender: UIButton) {
        
        let alertController = UIAlertController(title: "クリッカーを始めます", message: "よろしいですか？", preferredStyle: .Alert)
        
        let startAction = UIAlertAction(title: "はじめる", style: .Cancel) {
            action in println("はじめる")
        }
        
        let canselAction = UIAlertAction(title: "キャンセル", style: .Default) {
            action in println("キャンセル")
        }
        
        alertController.addAction(startAction)
        alertController.addAction(canselAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}


