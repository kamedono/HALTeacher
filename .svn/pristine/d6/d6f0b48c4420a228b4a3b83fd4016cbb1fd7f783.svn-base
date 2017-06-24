//
//  TeacherInfo.swift
//  NewHALTitle
//
//  Created by Toshiki Higaki on 2015/09/16.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class UserInfo: NSObject{
    // todo coreDataからとって来ましょう
    static let userInfoInstance = UserInfo()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var userID: String? {
        get { return defaults.stringForKey("userID") ?? ""  }
        set { defaults.setObject(newValue, forKey: "userID") }
    }
    
    var password: String? {
        get { return defaults.stringForKey("password") ?? ""  }
        set { defaults.setObject(newValue, forKey: "password") }
    }
    
    var name: String? {
        get { return defaults.stringForKey("name") ?? ""  }
        set { defaults.setObject(newValue, forKey: "name") }
    }
    
    var number: String? {
        get { return defaults.stringForKey("number") ?? ""  }
        set { defaults.setObject(newValue, forKey: "number") }
    }
    
    override init(){
        super.init()
    }
    
    func setInfo(userID: String, password: String, name: String, number: String) {
        self.userID = userID
        self.password = password
        self.name = name
        self.number = number
    }
    
    
    /**
    NSDataに変換する関数
    */
    func archiveNSData() -> NSData{
        var dataArray: [AnyObject] = []
        
        dataArray.append(self.userID!)
        dataArray.append(self.password!)
        dataArray.append(self.name!)
        dataArray.append(self.number!)
        return NSKeyedArchiver.archivedDataWithRootObject(dataArray)
    }
}