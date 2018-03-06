//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/2/23.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        // MARK: - Solve contextual out of range in nameLabel
        didSet {
            nameLabel.numberOfLines = 0
            /*
             iOS的Label可以多行顯示，將行數改成「0」，
             Label會自動判斷全部的行數來符合它的內容。
             解決Label內因字數太長無法正常顯示的問題。
             */
        }
    }
    @IBOutlet weak var typeLabel: UILabel! {
        // MARK: - Corner of type label setting
        didSet {
            typeLabel.layer.cornerRadius = 5.0 // layer的cornerRadius來設定圓角半徑
            typeLabel.layer.masksToBounds = true // 屬性若被設置為true，會將超過邊筐外的sublayers裁切掉
            // masksToBounds中文解釋: https://www.appcoda.com.tw/calayer-introduction/
        }
    }
    @IBOutlet weak var heartImageView: UIImageView! {
        // MARK: - Allocate icon of "heart-tick" from Assets.xcassets folder
        didSet {
            heartImageView.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
            //以模板模式(alwaysTemplate)來載入才能變更圖片屬性
            heartImageView.tintColor = .white //.tintColor 染色，將"heart-tick"圖片染成白色
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
