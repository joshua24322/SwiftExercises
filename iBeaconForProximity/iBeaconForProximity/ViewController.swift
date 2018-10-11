//
//  ViewController.swift
//  iBeaconForProximity
//
//  Created by Joshua Chang on 2018/10/12.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

// 1. Create LocationManager Object
// 2. set a reason for that in the Info.plist
// 3. Request authorization on this device
// 4. CLRegion - All the Beacon's data
// 5. If the user's authorizated, start ranging for the beacon which set up
// 6. Read the porximity property on the beacon as it's ranged and changd the screen color base on that

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func rangeBeacon() {
        let uuid = UUID().uuidString // Get device uuid
        print("Device UUID: \(uuid)")
        
        let major: CLBeaconMajorValue = 31745 // Type represents the most significant value in a beacon
        let minor: CLBeaconMinorValue = 64019 // Type represents the least significant value in a beacon
        let identifier = "sampleBeaconDetect"
        
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuid)!, major: major, minor: minor, identifier: identifier)
        
        locationManager.startRangingBeacons(in: region) // Start calculating ranges for beacons in the specified region
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoveredBeaconProximity = beacons.first?.proximity else {
            print("Couldn't find the Beacon!")
            displayAlert(title: "Couldn't find the Beacon!", message: "Please make sure the beacon is in vicinity")
            return
        }
        
        let backgroundColor: UIColor = {
            // Constants that reflect the relative distance to a beacon
            switch discoveredBeaconProximity {
            case .immediate:
                return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .near:
                return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case .far:
                return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            case .unknown:
                return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }()
        view.backgroundColor = backgroundColor
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        // rawValue:0. 還沒有詢問過用戶以獲得權限
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        // rawValue:2. 用戶不同意
        case .denied:
            let alert = UIAlertController(title: "Location services were previously denied.", message: "Please enable location services for this app in Settings.", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)
        // rawValue:3. 用戶永遠允許定位
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            rangeBeacon()
        // rawValue:4. 用戶僅允許App使用期間定位
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            rangeBeacon()
        default:
            print("This app is not authorized to use location services.")
            return
        }
        print("Authorization Status: \(status.rawValue)")
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

