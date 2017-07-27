//
//  CivilTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CivilTableViewCell: UITableViewCell {
    
    @IBOutlet weak var worldView: UIView!
    @IBOutlet weak var worldIconBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.worldView.layer.cornerRadius = 20
        self.worldView.clipsToBounds = true
        self.worldView.layer.borderWidth = 0
        self.worldView.layer.borderColor = UIColor.white.cgColor
        self.worldView.backgroundColor = Global.colorMain
        
        let globeIcon = FAKFontAwesome.globeIcon(withSize: 20)
        globeIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let globeImg  = globeIcon?.image(with: CGSize(width: 20, height: 20))
        worldIconBtn.setImage(globeImg, for: .normal)
        worldIconBtn.tintColor = UIColor.white
        worldIconBtn.imageView?.contentMode = .scaleAspectFit
        
        let closeIcon = FAKIonIcons.androidCloseIcon(withSize: 25)
        closeIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let closeImg  = closeIcon?.image(with: CGSize(width: 25, height: 25))
        closeBtn.setImage(closeImg, for: .normal)
        closeBtn.tintColor = Global.colorGray
        closeBtn.imageView?.contentMode = .scaleAspectFit
        
        let phoneIcon = FAKFontAwesome.phoneIcon(withSize: 20)
        phoneIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let phoneImg  = phoneIcon?.image(with: CGSize(width: 20, height: 20))
        phoneBtn.setImage(phoneImg, for: .normal)
        phoneBtn.tintColor = Global.colorMain
        phoneBtn.imageView?.contentMode = .scaleAspectFit
        
        let envelopeIcon = FAKFontAwesome.envelopeIcon(withSize: 20)
        envelopeIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let envelopeImg  = envelopeIcon?.image(with: CGSize(width: 20, height: 20))
        emailBtn.setImage(envelopeImg, for: .normal)
        emailBtn.tintColor = Global.colorMain
        emailBtn.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
