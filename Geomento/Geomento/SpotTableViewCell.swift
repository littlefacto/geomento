//
//  SpotTableViewCell.swift
//  Geomento
//
//  Created by Vincent on 02/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
