//
//  RestaurantDetailMapCell.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/2/26.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    
    func configure(location: String) {
        // 取得位置 這裡的location就是restaurant.location， from RestaurantDetailViewController
        let geoCoder = CLGeocoder()

        print(location)
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            /*
             處理錯誤
             If a device is in Airplane mode or the network is currently not configured,
             the geocoder can’t connect to the service it needs and must therefore return an appropriate error.
             */
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // 處理地點座標
            if let placemarks = placemarks {
                let placemark = placemarks[0] //取得第一個地點標記
                let annotation = MKPointAnnotation() //加上標記位置
                if let location = placemark.location {
                    // 顯示標記
                    annotation.coordinate = location.coordinate //將位置經緯度指定給大頭針標記
                    self.mapView.addAnnotation(annotation) // 透過addAnnotation方法將大頭針標記顯示在地圖上
                    
                    // 設定縮放比例
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250) // 調整地圖初始縮放比例為250m半徑範圍
                    self.mapView.setRegion(region, animated: false)
                }
                
            }
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
