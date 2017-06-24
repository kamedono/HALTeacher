//
//  SomeViewController.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/12.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//
import Foundation
import UIKit

var menuElemSelector: Selector = Selector("menuElem")

extension UIViewController {
    
    var menu: MenuElem {
        get {
            return objc_getAssociatedObject(self, &menuElemSelector) as! MenuElem
        }
        set {
            objc_setAssociatedObject(self, &menuElemSelector, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) ;
        }
    }
}


class SomeViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        self.label.text = self.menu.name()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
