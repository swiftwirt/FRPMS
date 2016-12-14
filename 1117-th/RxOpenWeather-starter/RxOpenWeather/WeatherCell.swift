//
//  WeatherCell.swift
//  RxOpenWeather
//
//  Created by fnord on 12/14/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setLabels(date: String, tempRange: String, description: String){
        dateLabel.text = date
        tempRangeLabel.text = tempRange
        descriptionLabel.text = description
    }

}
