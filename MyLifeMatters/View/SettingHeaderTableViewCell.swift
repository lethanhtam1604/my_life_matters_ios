//
//  SettingHeaderTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/28/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SettingHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var iconUserBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationIconBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLabel.textColor = Global.colorGray
        
        let mapMarkerIcon = FAKFontAwesome.mapMarkerIcon(withSize: 20)
        mapMarkerIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let mapMarkerImg  = mapMarkerIcon?.image(with: CGSize(width: 30, height: 30))
        locationIconBtn.setImage(mapMarkerImg, for: .normal)
        locationIconBtn.tintColor = Global.colorGray
        locationIconBtn.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SettingHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
