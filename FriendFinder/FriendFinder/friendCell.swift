//
//  friendCell.swift
//  FriendFinder
//
//  Created by devloper65 on 2/22/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class friendCell: UITableViewCell {

    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var lblname: UILabel!
    @IBOutlet var btnAddRemove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.layer.borderWidth = 1.0
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
