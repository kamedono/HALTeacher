//
//  WebInfo.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/10/06.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

@objc(WebInfo)
class WebInfo : NSObject , NSCoding {
    static let webInfoInstance = WebInfo()
    var lockStatus: String? = "unlock"
    var url: String?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()

        self.lockStatus = aDecoder.decodeObjectForKey("lockStatus") as! String?
        self.url = aDecoder.decodeObjectForKey("url") as! String?
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lockStatus, forKey: "lockStatus")
        aCoder.encodeObject(self.url, forKey: "url")
    }
}