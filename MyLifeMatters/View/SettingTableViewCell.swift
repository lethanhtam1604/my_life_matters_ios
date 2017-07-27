//
//  SettingTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/27/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let iosArrowForwardIcon = FAKIonIcons.iosArrowForwardIcon(withSize: 30)
        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let iosArrowForwardImg  = iosArrowForwardIcon?.image(with: CGSize(width: 30, height: 30))
        nextBtn.setImage(iosArrowForwardImg, for: .normal)
        nextBtn.tintColor = Global.colorGray
        nextBtn.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(setting: Setting) {
        iconBtn.setImage(setting.icon, for: .normal)
        iconBtn.tintColor = Global.colorGray
        iconBtn.imageView?.contentMode = .scaleAspectFit
        
        nameLabel.text = setting.title
    }
    
}
