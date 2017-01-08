//
//  PresentsTableViewCell.swift
//  PresentBase
//
//  Created by Brian Advent on 24/12/2016.
//  Copyright © 2016 Brian Advent. All rights reserved.
//

import UIKit

class PresentsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
