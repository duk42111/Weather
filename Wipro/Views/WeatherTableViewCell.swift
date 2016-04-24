//
//  WeatherTableViewCell.swift
//  Wipro
//
//  Created by Mladen Despotovic on 24/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var date:UILabel?
    @IBOutlet var temperature:UILabel?
    @IBOutlet var weatherDescription:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
