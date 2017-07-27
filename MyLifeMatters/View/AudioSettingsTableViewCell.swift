//
//  AudioSettingsTableViewCell.swift
//  MyLifeMatters
//
//  Created by D on 12/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AudioSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var musicImgView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let resourceUrl = Bundle.main.url(forResource: "music-playing", withExtension: "gif")
//        let iconMusicPlaying = UIImage.animatedImage(withAnimatedGIFURL: resourceUrl!)
//        musicImgView.image = iconMusicPlaying
//        musicImgView.isHidden = true
//        
//        let iosArrowForwardIcon = FAKIonIcons.iosCheckmarkEmptyIcon(withSize: 30)
//        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
//        let iosArrowForwardImg = iosArrowForwardIcon?.image(with: CGSize(width: 30, height: 30))
//        checkBtn.setImage(iosArrowForwardImg, for: .normal)
//        checkBtn.tintColor = Global.colorMain
//        checkBtn.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
}
