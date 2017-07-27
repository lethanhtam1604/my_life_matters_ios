//
//  CivilHeaderTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class CivilHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CivilHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
