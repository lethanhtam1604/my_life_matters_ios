//
//  EmergencyTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/6/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class EmergencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ttyIcon = FAKFontAwesome.ttyIcon(withSize: 25)
        ttyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let ttyImg  = ttyIcon?.image(with: CGSize(width: 25, height: 25))
        iconBtn.setImage(ttyImg, for: .normal)
        iconBtn.tintColor = UIColor.white
        iconBtn.imageView?.contentMode = .scaleAspectFit
        iconBtn.layer.cornerRadius = 20
        iconBtn.backgroundColor = Global.colorMain
        iconBtn.clipsToBounds = true
        
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
