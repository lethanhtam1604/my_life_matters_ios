//
//  CallTableViewCell.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/14/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class CallTableViewCell: UITableViewCell {

    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberView.layer.cornerRadius = 22.5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
