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
import AVFoundation

class ViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var TimeTextView: UILabel!
    @IBOutlet weak var LocationTextView: UILabel!
    @IBOutlet weak var TempTextView: UILabel!
    @IBOutlet weak var PressureTextView: UILabel!
    
    var locationManager :CLLocationManager!
    var currentLocation :CLLocation!
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        TimeTextView.isUserInteractionEnabled = true
        TimeTextView.addGestureRecognizer(tap)
        
        let loc = UITapGestureRecognizer(target: self, action: #selector(ViewController.currentLoc))
        LocationTextView.isUserInteractionEnabled = true
        LocationTextView.addGestureRecognizer(loc)
        
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
        self.ref = Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("tempAndPressure")

        self.ref?.observe(.childAdded, with: { (snapshot) in
            guard let restDict = snapshot.value as? [String: Any] else { return }
            let temp = restDict["temp"] as! NSNumber
            let press = restDict["pressure"] as! NSNumber
            
            let pressure = NumberFormatter.localizedString(from: press, number: .decimal)
            self.TempTextView.text = "\(temp) °C "
            self.PressureTextView.text = "\(pressure) kPa"
        })
        //
        //background
        self.view.layer.contents = UIImage(named:"background")?.cgImage
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier:"en_US") as Locale
        dateformatter.dateFormat = "HH:mm:ss"
        let strNowTime = dateformatter.string(from: date as Date) as String
        let utterance = AVSpeechUtterance(string: "Current time is " + strNowTime)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
      }
   
    @objc
    func currentLoc(sender:UITapGestureRecognizer) {
        let utterance = AVSpeechUtterance(string: "You are now in the " + LocationTextView.text! + " currently")
           let synth = AVSpeechSynthesizer()
           synth.speak(utterance)
         }
    
    @IBAction func speechOut(_ sender: Any) {
        let text1 = "Current temperature is" + TempTextView.text!
        let text2 = " and current air pressure is" + PressureTextView.text!
        let text = text1 + text2
        let utterance = AVSpeechUtterance(string: text)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
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

