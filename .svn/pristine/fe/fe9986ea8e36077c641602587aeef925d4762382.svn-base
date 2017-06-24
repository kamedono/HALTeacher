//
//  File.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/25.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

@objc protocol DrawClickerBarGraphViewDelegate {
    optional func pushBarGraph(markNumber: Int)
}

class DrawClickerBarGraphView: UIView {
    
    var delegate: DrawClickerBarGraphViewDelegate!
    
    //UIボタンの宣言
    var selectButton: UIButton!
    
    //ボタンの入力を記憶する
    var buttonTapCount: [Int] = ClickerInfo.clickerInfoInstance.buttonTapCount
    
    //色の中身
    var colorBox :[CGColor] = [
        UIColor.hexStr("#ff1e1e", alpha: 1).CGColor,
        UIColor.hexStr("#f39800", alpha: 1).CGColor,
        UIColor.hexStr("#ffff28", alpha: 1).CGColor,
        UIColor.hexStr("#adff2f", alpha: 1).CGColor,
        UIColor.hexStr("#00ff00", alpha: 1).CGColor,
        UIColor.hexStr("#00bfff", alpha: 1).CGColor,
        UIColor.hexStr("#0000cd", alpha: 1).CGColor,
        UIColor.hexStr("#962dff", alpha: 1).CGColor,]
    
    //ボタン番号
    var buttonNum = 0
    
    
    /**
    グラフのパラメータ変更
    値を追加する
    */
    func setButtonNumber(buttonNumber:Int){
        println("ボタンナンバー書き込み中\(buttonNumber)")
        buttonNum = buttonNumber
        ClickerInfo.clickerInfoInstance.buttonTapCount[buttonNumber] += 1
    }
    
    /**
    グラフのパラメータ変更
    値を変更する
    */
    func changeButtonNumber(beforeNumber:Int,afterNumber:Int){
        ClickerInfo.clickerInfoInstance.buttonTapCount[beforeNumber]--
        ClickerInfo.clickerInfoInstance.buttonTapCount[afterNumber]++
    }
    
    /**
    ボタンカウンターの初期化
    ボタンの数だけ呼ばれる
    */
    func setButtonCounter(){
        ClickerInfo.clickerInfoInstance.buttonTapCount.append(0)
    }
    
    /**
    割合を出す
    */
    func makePercentage(buttonNum:Int) -> Double{
        var topSum = 0
        for(var i=0 ;i<ClickerInfo.clickerInfoInstance.buttonTapCount.count ;i++) {
            topSum += ClickerInfo.clickerInfoInstance.buttonTapCount[i]
        }
        if topSum != 0 {
            return Double(ClickerInfo.clickerInfoInstance.buttonTapCount[buttonNum])*100.0/Double(topSum)
        }
        return 0
    }
    
    override func drawRect(rect: CGRect) {
        for(var i=0 ;i<ClickerInfo.clickerInfoInstance.buttonTapCount.count ;i++){
            //コンテキスト取得
            let cgContext = UIGraphicsGetCurrentContext()
            //ラインの太さ
            CGContextSetLineWidth(cgContext, 2.0)
            //枠の色設定
            CGContextSetStrokeColorWithColor(cgContext, colorBox[i])
            //塗りつぶす色の設定
            CGContextSetFillColorWithColor(cgContext, colorBox[i])
            
            var percentage = makePercentage(i)
            println("番号\(i)　　割合\(Int(makePercentage(i)))")
            
            // タッチするためのViewを作成
            var barView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            
            //割合0.0 = 押してない
            if(percentage != 0.0){
                switch ClickerInfo.clickerInfoInstance.buttonTapCount.count {
                case 2:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 260+(i*350), y: 700 - Int(percentage)*7, width: 145, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 260+(i*350), y: 700 - Int(percentage)*7, width: 145, height: Int(percentage)*7))
                case 3:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 200+(i*250), y: 700 - Int(percentage)*7, width: 120, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 200+(i*250), y: 700 - Int(percentage)*7, width: 120, height: Int(percentage)*7))
                case 4:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 160+(i*200), y: 700 - Int(percentage)*7, width: 100, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 160+(i*200), y: 700 - Int(percentage)*7, width: 100, height: Int(percentage)*7))
                case 5:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 135+(i*170), y: 700 - Int(percentage)*7, width: 80, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 135+(i*170), y: 700 - Int(percentage)*7, width: 80, height: Int(percentage)*7))
                case 6:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 120+(i*145), y: 700 - Int(percentage)*7, width: 60, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 120+(i*145), y: 700 - Int(percentage)*7, width: 60, height: Int(percentage)*7))
                case 7:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 100+(i*130), y: 700 - Int(percentage)*7, width: 40, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 100+(i*130), y: 700 - Int(percentage)*7, width: 40, height: Int(percentage)*7))
                case 8:
                    //座標
                    CGContextFillRect(cgContext, CGRect(x: 90+(i*115), y: 700 - Int(percentage)*7, width: 40, height: Int(percentage)*7))
                    barView = UIView(frame: CGRect(x: 90+(i*115), y: 700 - Int(percentage)*7, width: 40, height: Int(percentage)*7))
                    
                default:
                    break
                }
                barView.tag = i
                
                // タッチされた時の処理
                let gesture = UITapGestureRecognizer(target:self, action: "didClickBarView:")
                
                barView.addGestureRecognizer(gesture)
                
                self.addSubview(barView)
                //描画
                CGContextFillPath(cgContext)
                CGContextStrokePath(cgContext)
            }
        }
    }
    
    /**
    棒グラフをタッチされた時の処理
    */
    func didClickBarView(recognizer: UIGestureRecognizer) {
        if recognizer.view?.tag != nil {
            println(recognizer.view?.tag)
            self.delegate?.pushBarGraph?(recognizer.view!.tag)
        }
    }
    
    /**
    選択肢ごとのデータを返す
    */
    func getMarkCount(markNumber:Int) -> Int{
        return ClickerInfo.clickerInfoInstance.buttonTapCount[markNumber]
    }
    
    /**
    Viewをタッチした時のデリゲート
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        super.touchesEnded(touches, withEvent: event)
        
        for touch: AnyObject in touches {
        }
    }
    
}