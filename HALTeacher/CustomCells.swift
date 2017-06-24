//
//  CustomCells.swift
//  HALTeacher
//
//  Created by sotuken on 2015/07/15.
//  Copyright (c) 2015年 mycompany. All rights reserved.
//

import UIKit

class CustomCells: UICollectionViewCell {
    
    @IBOutlet var titles:UILabel!
    @IBOutlet var images:UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
