//
//  StudentProfileCell.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/09/24.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class StudentProfileCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()

        // 画像を丸く
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.masksToBounds = true

        // Initialization code
        // test
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
