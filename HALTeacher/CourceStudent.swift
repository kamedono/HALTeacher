//
//  CourceStudent.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/17.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import CoreData

class CourceStudent: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var cource: Cource

}
