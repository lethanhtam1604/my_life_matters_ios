//
//  ContactCollectionViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/15/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containView.layer.borderWidth = 1
        containView.layer.borderColor = Global.colorGray.cgColor
        containView.layer.cornerRadius = 20
        
        let userIcon = FAKFontAwesome.userIcon(withSize: 15)
        userIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let userImg  = userIcon?.image(with: CGSize(width: 15, height: 15))
        iconBtn.setImage(userImg, for: .normal)
        iconBtn.tintColor = UIColor.white
        iconBtn.imageView?.contentMode = .scaleAspectFit
        iconBtn.backgroundColor = UIColor.red
        iconBtn.layer.cornerRadius = 20
        iconBtn.clipsToBounds = true
    }

}
