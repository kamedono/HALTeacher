//
//  MoodleLogin.swift
//  Student
//
//  Created by sotuken on 2015/07/31.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class MoodleLogin :UIViewController {
    @IBOutlet weak var moodleURL: UITextField!
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moodleURL.text = "http://e-class.center.yuge.ac.jp/login/index.php"
        userID.text = "ap14006"
        password.text = "ap14006"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pushLogin(sender: AnyObject) {
        var url = NSURL(string: moodleURL.text)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "POST";
        var httpBody = String(format:"username=%@&password=%@",userID.text,password.text)
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
            if (error == nil) {
                var result = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println(result)
            } else {
                println(error)
            }
        })
        task.resume()
    }
}
