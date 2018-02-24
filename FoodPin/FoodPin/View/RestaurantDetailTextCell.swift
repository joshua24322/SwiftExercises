//
//  RestaurantDetailTextCell.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/2/23.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit

class RestaurantDetailTextCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
