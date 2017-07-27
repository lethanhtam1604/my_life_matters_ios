//
//  IntroPage.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/24/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class IntroPage: UIView {

    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    let gradientView = GradientView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getStartedBtn.setTitleColor(UIColor.white, for: .normal)
        getStartedBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        getStartedBtn.insertSubview(gradientView, at: 0)
        getStartedBtn.layer.cornerRadius = 5
        getStartedBtn.isHidden = true
        getStartedBtn.clipsToBounds = true
        
        gradientView.autoPinEdge(toSuperviewEdge: .left)
        gradientView.autoPinEdge(toSuperviewEdge: .right)
        gradientView.autoPinEdge(toSuperviewEdge: .top)
        gradientView.autoSetDimension(.height, toSize: 40)
    }
}
