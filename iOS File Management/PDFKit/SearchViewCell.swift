//
//  SearchViewCell.swift
//  TinyApps
//
//  Created by Thanh Minh on 11/22/17.
//  Copyright © 2017 Thanh Minh. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var resultTextLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
