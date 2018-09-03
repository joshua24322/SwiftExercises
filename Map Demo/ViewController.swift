//
//  ViewController.swift
//  Map Demo
//
//  Created by Joshua Chang on 2018/8/30.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

/*
 //設置定位服務的精確度
 
 //導航最高精確，需要使用GPS。例如：汽車導航時使用。  ※此狀態非常耗電，因精準度越高越耗電。
 locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
 
 //高精確
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 
 //10米，10米附近的精準度可能是GPS & WiFi混用
 locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
 
 //百米，百米附近的精準度只用 WiFi
 locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
 
 //千米
 locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
 
 //三公里，1～3公里內用基地台來確認位置
 locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
 
 //※和基地台通訊（使用通話功能）耗電非常低，使用 WiFi耗電量中等，WiFi透過三角定位來確認位置。
 // GPS定位最精準但最耗電，在有遮蔽物或地下時無法使用。
 */

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var location: CLLocationCoordinate2D?
    let annotation = MKPointAnnotation()
    var counter = 0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func updateUserCenterCoordinate(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            self.theMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
        
        mapView.delegate = self
        mapView.showsCompass = true // 顯示指南針，從正北開始旋轉後才會出現
        mapView.showsScale = true // 視圖左上角顯示比例尺
        mapView.showsTraffic = true // 在地圖上顯示交通流量大的點
        mapView.mapType = .standard // 標準地圖
    }
    
    // ???: -
    //let coordinate = locationManager.location?.coordinate
    func coordinate(_ lhs: CLLocationDegrees?, _ rhs: CLLocationDegrees?) {
        guard let lhs = lhs, let rhs = rhs else { return }
        location = CLLocationCoordinate2D(latitude: lhs, longitude: rhs)
    }
    
    func annotationTitleParameter(_ lhs: String?, _ rhs: String?) {
        guard let lhs = lhs, let rhs = rhs else { return }
        annotation.title = lhs
        annotation.subtitle = rhs
    }
    
    // MARK: - MapView setup
    func theMap() {
        //guard let location = locationManager.location?.coordinate else { return }
        let latDelta: CLLocationDegrees = 0.0030
        let lonDelta: CLLocationDegrees = 0.0030
        let zoomSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        guard let location = location else { return }
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: zoomSpan)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true //display the user’s location
        defaultAnnotation()
        annotationWithLongPressGesture()
    }
    
    // MARK: - Default Annotation
    func defaultAnnotation() {
        // annotation - coordinate
        guard let location = location else { return }
        annotation.coordinate = location
        // convert type CLLocationCoordinate2D to type CLLocation, for CLGeocoder() class
        let annotationLocation: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(annotationLocation) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemark = placemarks?[0] else { return }
            // annotation - title & subtitle
            self.annotationTitleParameter(placemark.locality, placemark.name)
            // placemark.locality: The city associated with the placemark
            // placemark.name: The name of the placemark (address)
        }
        
        // add annotation instance to map view
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Customize Annotation with long press gesture
    func annotationWithLongPressGesture() {
        // initial a instance of long press, use UILongPressGestureRecognizer class, meanwhile perform him delegate
        let screenLongPress = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        screenLongPress.delegate = self
        
        // The minimum period fingers must press on the view for the gesture to be recognized.
        screenLongPress.minimumPressDuration = 2
        
        // Attaches a gesture recognizer to the view
        mapView.addGestureRecognizer(screenLongPress)
        
    }
    
    @objc func addPin(_ sender: UILongPressGestureRecognizer) {
        /*due to long press gesture has several events involve begin and end, gesture one time will get two events respone by default
        via UIGestureRecognizerState.begin detect the long press gesture begin event*/
        guard sender.state == UIGestureRecognizerState.began else { return }
        // annotation send to screen coordinate from user touch
        let touchPoint = sender.location(in: mapView)
        // Converts a point in the specified view’s coordinate system to a map coordinate.
        let touchPointCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        // annotation - coordinate
        annotation.coordinate = touchPointCoordinate // 將物理座標賦予給Annotation的座標
        
        // convert type CLLocationCoordinate2D to type CLLocation, for CLGeocoder() class
        let annotationLocation: CLLocation = CLLocation(latitude: touchPointCoordinate.latitude, longitude: touchPointCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(annotationLocation) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemark = placemarks?[0] else { return }
            // annotation - title & subtitle
            self.annotationTitleParameter(placemark.locality, placemark.name)
        }
        
        // add annotation instance to map view
        mapView.addAnnotation(annotation)
        
        // verify the gesture response
        counter += 1
        print("Long Press Counter: \(counter), Coordinate: (\(touchPoint.x), \(touchPoint.y))")
    }
    
    // MARK: - CLLAuthorizationStatus
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        // rawValue:0. 還沒有詢問過用戶以獲得權限
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        // rawValue:2. 用戶不同意
        case .denied:
            let alert = UIAlertController(title: "Location services were previously denied.", message: "Please enable location services for this app in Settings.", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)
        // rawValue:3. 用戶永遠允許定位
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        // rawValue:4. 用戶僅允許App使用期間定位
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("This app is not authorized to use location services.")
            return
        }
        print("Authorization Status: \(status.rawValue)")
    }
    
    // MARK: - CLLUpdateLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation:CLLocation = locations.first else { return }
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        coordinate(latitude, longitude)
        locationManager.stopUpdatingLocation() // stop update user coordinate
        //locationManager.delegate = nil
        theMap()
    }
    
}

