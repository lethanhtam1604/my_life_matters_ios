//
//  CivilFooterTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

protocol FooterDelegate {
    func addBtnClicked()
}

class CivilFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addIconBtn: UIButton!
    
    let footerBorder = UIView()
    var footerDelegate: FooterDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let plusCircleIcon = FAKFontAwesome.plusCircleIcon(withSize: 45)
        plusCircleIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let plusCircleImg  = plusCircleIcon?.image(with: CGSize(width: 45, height: 45))
        addIconBtn.setImage(plusCircleImg, for: .normal)
        addIconBtn.tintColor = Global.colorMain
        addIconBtn.imageView?.contentMode = .scaleAspectFit
        addIconBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)

        self.addSubview(footerBorder)
        footerBorder.backgroundColor = Global.colorBg
        
        footerBorder.autoPinEdge(toSuperviewEdge: .left)
        footerBorder.autoPinEdge(toSuperviewEdge: .right)
        footerBorder.autoPinEdge(toSuperviewEdge: .top)
        footerBorder.autoSetDimension(.height, toSize: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addBtnClicked() {
        if footerDelegate != nil {
            footerDelegate.addBtnClicked()
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CivilFooterTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
