//
//  StudentInfo.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/08/07.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class StudentInfo: NSObject{
    
    var userID: String = ""
    var password : String = ""
    var name: String = ""
    var number : String = ""
    var absent :Bool = false
    var lock :Bool = false
    var UUID: NSUUID?
    var profileImageURL: String = ""
    var profileImage: UIImage?
    
    init(userID: String, name: String, absent: Bool, lock: Bool) {
        self.userID = userID
        self.name = name
        self.absent = absent
        self.lock = lock
    }
    
    /**
    NSDataから元のデータに変換する関数
    */
    init(data: NSData) {
        var dataArray: [AnyObject] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [AnyObject]
        self.userID = dataArray[0] as! String
        self.name = dataArray[1] as! String
        self.number = dataArray[2] as! String
        self.profileImageURL = dataArray[3] as! String
    }
    
    /**
    NSDataに変換する関数
    */
    func archiveNSData() -> NSData {
        var dataArray: [AnyObject] = []
        
        dataArray.append(self.userID)
        dataArray.append(self.name)
        dataArray.append(self.number)
        return NSKeyedArchiver.archivedDataWithRootObject(dataArray)
    }
    
}