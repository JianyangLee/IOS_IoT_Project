//
//  ViewController.swift
//  VisualAssistant
//
//  Created by Lee on 13/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class ViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var TimeTextView: UILabel!
    @IBOutlet weak var LocationTextView: UILabel!
    @IBOutlet weak var TempTextView: UILabel!
    @IBOutlet weak var PressureTextView: UILabel!
    
    var locationManager :CLLocationManager!
    var currentLocation :CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 1.0,target:self,selector: #selector(self.setTime), userInfo: nil, repeats: true )
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
//        locationToAddress ()
//        self.ref = Database.database().reference().root.child("iosassignment-9f7ef").child("Data")
//
//        self.ref?.child(result).observe(.childAdded, with: { (snapshot) in
//            guard let restDict = snapshot.value as? [String: Any] else { return }
//            let something = restDict["temp"] as! Float
//            self.setTemperature(temp: something)
//            self.changeImageColor(red:restDict["red"] as! Int, green: restDict["green"] as! Int, blue: restDict["blue"] as! Int)
//        })
        
        //background
        self.view.layer.contents = UIImage(named:"background")?.cgImage
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        currentLocation = location
        if (location.horizontalAccuracy > 0) {
                    self.locationManager.stopUpdatingLocation()
                    print("latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)")
                    self.locationManager.stopUpdatingLocation()
        }
        locationToAddress ()
    }
    
    @objc func setTime() {
        var date = NSDate()
        var dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier:"en_US") as Locale
        dateformatter.dateFormat = "yyyy-MM-dd \nHH:mm:ss"
        var strNowTime = dateformatter.string(from: date as Date) as String
        TimeTextView.text = strNowTime;
    }

    func locationToAddress ()
    {
        if let currentLocation = currentLocation {
            print(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
            let location = currentLocation
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    
                    print(firstLocation!.name, firstLocation!.locality, firstLocation?.administrativeArea, firstLocation!.postalCode)
                    
                    self.LocationTextView.text = "\((firstLocation!.locality)!)"
                    
                    //completionHandler(firstLocation)
                } else {
                    //completionHandler(nil)
                }
            })
            
        }
        else {
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
        }
    
    }
}

