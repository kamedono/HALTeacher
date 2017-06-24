//
//  PieGraphView.swift
//  PieGraphDemoSwift
//
//  Created by kitano on 2015/07/10.
//  Copyright (c) 2015年 OneWorld Inc. All rights reserved.
//

import UIKit

extension UIColor {
    class func hexStr (var hexStr : NSString, var alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
    class func navigationColor() -> UIColor {
        return UIColor.hexStr("#FF8C01", alpha: 1)
    }
}


class GraphView: UIView {
    
    var _params: [Dictionary<String,AnyObject>]!
    var _end_angle: CGFloat!
    
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
    var colorList: [UIColor] = [
        UIColor.hexStr("#ff6633", alpha: 1),
        UIColor.hexStr("#ffa54c", alpha: 1),
        UIColor.hexStr("#ffff66", alpha: 1),
        UIColor.hexStr("#ccff99", alpha: 1),
        UIColor.hexStr("#66ff99", alpha: 1),
        UIColor.hexStr("#99ffff", alpha: 1),
        UIColor.hexStr("#3066ff", alpha: 1),
        UIColor.hexStr("#cc99cc", alpha: 1),
    ]
    
    var status = [0]
    
    /**
    storyBoardで呼ばれる時にここに来る（初期化）
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var params = [Dictionary<String,AnyObject>]()
        
        for var i=0; i < status.count; i++ {
            params.append(["value": self.status[i],"color": self.colorList1[i]])
        }
        
        _params = params
        self.backgroundColor = UIColor.clearColor();
        _end_angle = -CGFloat(M_PI / 2.0);
    }
    
    /**
    コードで呼ばれた時にここに来る
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var param = [Dictionary<String,AnyObject>]()
        
        for var i=0; i < status.count; i++ {
            param.append(["value": self.status[i],"color": self.colorList[i]])
        }
        _params = param
        
        self.backgroundColor = UIColor.clearColor()
        _end_angle = -CGFloat(M_PI / 2.0)
    }
    
    /**
    アニメーション
    */
    func update(link:AnyObject){
//        var angle = CGFloat(M_PI*2.0 / 100.0);
        // 一瞬バージョン
        var angle = CGFloat(M_PI*2.0);
        _end_angle = _end_angle +  angle
        if(_end_angle > CGFloat(M_PI*2)) {
            //終了
            link.invalidate()
        } else {
            self.setNeedsDisplay()
        }
    }
    
    
    /**
    グラフの値変更
    更新後、アニメーション関数を実行
    
    :param: status グラフの値
    */
    func changeParams(status: [Int]){
        var param = [Dictionary<String,AnyObject>]()
        
        for var i=0; i < status.count; i++ {
            param.append(["value": status[i],"color": self.colorList[i]])
        }
        
        self._params = param
        
    }
    
    
    /**
    アニメーションの実行
    */
    func startAnimating(){
        _end_angle = -CGFloat(M_PI / 2.0);
        let displayLink = CADisplayLink(target: self, selector: Selector("update:"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context:CGContextRef = UIGraphicsGetCurrentContext();
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/2
        var max:CGFloat = 0;
        for dic : Dictionary<String,AnyObject> in _params {
            var value = CGFloat(dic["value"] as! Float)
            max += value;
        }
        
        var smaller: CGFloat = x
        if x > y {
            smaller = y
        }
        
        var start_angle:CGFloat = -CGFloat(M_PI / 2);
        var end_angle:CGFloat    = 0;
        var radius:CGFloat  = smaller - 10.0;
        for dic : Dictionary<String,AnyObject> in _params {
            var value = CGFloat(dic["value"] as! Float)
            end_angle = start_angle + CGFloat(M_PI*2) * (value/max);
            if(end_angle > _end_angle) {
                end_angle = _end_angle;
            }
            var color:UIColor = dic["color"] as! UIColor
            
            CGContextMoveToPoint(context, x, y);
            CGContextAddArc(context, x, y, radius,  start_angle, end_angle, 0);
            
            //
            //If you comment out this line , the graph will be to fill all .
            //
            //CGContextAddArc(context, x, y, radius/2,  end_angle, start_angle, 1);
            
            
            CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
            CGContextClosePath(context);
            CGContextFillPath(context);
            start_angle = end_angle;
        }
        
    }
    
}
