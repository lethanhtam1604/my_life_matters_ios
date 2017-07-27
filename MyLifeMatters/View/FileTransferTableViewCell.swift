//
//  FileTransferTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 2/8/17.
//  Copyright © 2017 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class FileTransferTableViewCell: UITableViewCell {

    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let chatbubbleWorkingIcon = FAKIonIcons.chatbubbleWorkingIcon(withSize: 25)
        chatbubbleWorkingIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let chatbubbleWorkingImg  = chatbubbleWorkingIcon?.image(with: CGSize(width: 25, height: 25))
        iconBtn.setImage(chatbubbleWorkingImg, for: .normal)
        iconBtn.tintColor = UIColor.white
        iconBtn.imageView?.contentMode = .scaleAspectFit
        iconBtn.layer.cornerRadius = 20
        iconBtn.backgroundColor = Global.colorMain
        iconBtn.clipsToBounds = true
        
        let androidMoreVerticalIcon = FAKIonIcons.androidMoreVerticalIcon(withSize: 25)
        androidMoreVerticalIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let androidMoreVerticalImg  = androidMoreVerticalIcon?.image(with: CGSize(width: 25, height: 25))
        shareBtn.setImage(androidMoreVerticalImg, for: .normal)
        shareBtn.tintColor = Global.colorGray
        shareBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
