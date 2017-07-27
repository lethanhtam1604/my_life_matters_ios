//
//  AlarmTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var songIconBtn: UIButton!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.songView.layer.cornerRadius = 25
        self.songView.clipsToBounds = true
        self.songView.layer.borderWidth = 0
        self.songView.layer.borderColor = UIColor.white.cgColor
        self.songView.backgroundColor = Global.colorMain
        
        let iosMusicalNotesIcon = FAKIonIcons.iosMusicalNotesIcon(withSize: 25)
        iosMusicalNotesIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosMusicalNotesImg  = iosMusicalNotesIcon?.image(with: CGSize(width: 25, height: 25))
        songIconBtn.setImage(iosMusicalNotesImg, for: .normal)
        songIconBtn.tintColor = UIColor.white
        songIconBtn.imageView?.contentMode = .scaleAspectFit
        
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
