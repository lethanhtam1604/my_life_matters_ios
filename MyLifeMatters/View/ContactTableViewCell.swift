//
//  ContactTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
//        self.iconBtn.layer.cornerRadius = 25
//        self.iconBtn.clipsToBounds = true
//        iconBtn.setImage(UIImage(named: "setup_3.jpg"), for: .normal)
        
        let closeIcon = FAKIonIcons.androidCloseIcon(withSize: 25)
        closeIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let closeImg  = closeIcon?.image(with: CGSize(width: 25, height: 25))
        closeBtn.setImage(closeImg, for: .normal)
        closeBtn.tintColor = Global.colorGray
        closeBtn.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
