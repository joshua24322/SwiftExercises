//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/2/12.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        // MARK: - thumbnailImageView corner setting
        didSet {
        //didSet就是Swift中的屬性觀察者。
        //每次該圖片視圖被指定，都會呼叫didSet程式區塊內的屬性
            
            //thumbnailImageView.layer.cornerRadius = 30.0
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            //thumbnailImageView.layer.cornerRadius 設定圓角半徑
            //thumbnailImageView.bounds.width  thumbnailImageView圖片矩形的寬度，也就是圓角的直徑
        
            
            thumbnailImageView.clipsToBounds = true //讓圖形修剪為圓角
        }
    }
    
    @IBOutlet weak var accessoryViewImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
