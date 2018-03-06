//
//  MapViewController.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/3/2.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                // 取得第一個地點標記
                let placemarks = placemarks[0]
                
                // 加上標記
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemarks.location {
                    annotation.coordinate = location.coordinate
                    
                    // 顯示標記
                    self.mapView.showAnnotations([annotation], animated: true) // 將標記放到地圖上
                    self.mapView.selectAnnotation(annotation, animated: true) // 選取標記時，轉換為選取狀態，此時標記圖示會放大
                }
                
            }
        }
        mapView.delegate = self
        
        mapView.showsCompass = true // 顯示指南針，從正北開始旋轉後才會出現
        mapView.showsScale = true // 視圖左上角顯示比例尺
        mapView.showsTraffic = true // 在地圖上顯示交通流量大的點
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapViewDelegate methods
    // Returns the view associated with the specified annotation object
    // mapView(_:viewFor:)，這是當標記每次要顯示在地圖上時預設會呼叫的方法，如果沒有實作，標記的顏色會是預設的紅色，圖示預設是大頭針樣式
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        // MKMarkerAnnotationView: An annotation view that displays a balloon-shaped marker at the designated location
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        // 自訂外觀
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = .orange
        
        return annotationView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
