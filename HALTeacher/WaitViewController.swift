//
//  WaitViewController.swift
//  HALTeacher
//
//  Created by マイコン部 on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import Foundation

class WaitViewController: UIViewController {

    static var waitViewControllerInctance = WaitViewController()
    
    @IBOutlet weak var waitImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image1 = UIImage(named:"halTaitl.png")
        waitImage.image = image1
    }
}
