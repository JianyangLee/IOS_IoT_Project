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
import AudioToolbox

class ViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var TimeTextView: UILabel!
    @IBOutlet weak var LocationTextView: UILabel!
    @IBOutlet weak var TempTextView: UILabel!
    @IBOutlet weak var PressureTextView: UILabel!
    @IBOutlet weak var StayHomeUIButton: UIButton!
    @IBOutlet weak var OutsideUIButton: UIButton!
    @IBOutlet weak var SpeakingUIButton: UIButton!
    
    var locationManager :CLLocationManager!
    var currentLocation :CLLocation!
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Set the animations to the elements
        animations()
        
        //Set background
        self.view.layer.contents = UIImage(named:"bghome")?.cgImage
        
        //Read the information for the users
        speakOnHomepage()
        
        //Make the label operatable
        speakLabel()
        
        //refresh time every seconds
        Timer.scheduledTimer(timeInterval: 1.0,target:self,selector: #selector(self.setTime), userInfo: nil, repeats: true )
        
        //Reformat the date for firebase
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
        //Fire base listener
        self.ref = Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("tempAndPressure")
        sleep(4)
        self.ref?.observe(.childAdded, with: { (snapshot) in
            guard let restDict = snapshot.value as? [String: Any] else { return }
            let temp = restDict["temp"] as! NSNumber
            let press = restDict["pressure"] as! NSNumber
            let value = temp as? Int
            if (value! < 20){
                //vibration
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.displayMessage(withTitle: "Cold Weather", message: "Please wearing more clothes.")
                let utterance = AVSpeechUtterance(string: "The temperature is below 20°C, " + "Please wearing more clothes.")
                let synth = AVSpeechSynthesizer()
                synth.speak(utterance)
            }
            let pressure = NumberFormatter.localizedString(from: press, number: .decimal)
            self.TempTextView.text = "\(temp) °C "
            self.PressureTextView.text = "\(pressure) kPa"
        })
    }
    
    //Setting the time TapGestureRecognizer
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        let date = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier:"en_US") as Locale
        dateformatter.dateFormat = "HH:mm:ss"
        let strNowTime = dateformatter.string(from: date as Date) as String
        let utterance = AVSpeechUtterance(string: "Your current time is " + strNowTime)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
      }
   
    //Setting the location TapGestureRecognizer
    @objc
    func currentLoc(sender:UITapGestureRecognizer) {
        let utterance = AVSpeechUtterance(string: "You are now in the " + LocationTextView.text! + " currently")
           let synth = AVSpeechSynthesizer()
           synth.speak(utterance)
         }
    
    //Speak the text with devices speaker
    @IBAction func speechOut(_ sender: Any) {
        let text1 = "Current temperature is" + TempTextView.text!
        let text2 = " and current air pressure is" + PressureTextView.text!
        let text = text1 + text2
        let utterance = AVSpeechUtterance(string: text)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    //Add UITapGestureRecognizer on the location and time label
    func speakLabel(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        TimeTextView.isUserInteractionEnabled = true
        TimeTextView.addGestureRecognizer(tap)
        
        let loc = UITapGestureRecognizer(target: self, action: #selector(ViewController.currentLoc))
        LocationTextView.isUserInteractionEnabled = true
        LocationTextView.addGestureRecognizer(loc)
    }
    
    //Read the information for the users after they login
    func speakOnHomepage()
    {
        let utterance = AVSpeechUtterance(string: "Press left side monitor your house and press right side to detect the object. ")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    //Add animations in the home page element
    func animations ()
    {
        //Removew element first
        TimeTextView.center.y  -= view.bounds.height
        LocationTextView.center.y  -= view.bounds.height
        TempTextView.center.x -= view.bounds.width
        PressureTextView.center.x += view.bounds.width
        StayHomeUIButton.center.x += view.bounds.width
        OutsideUIButton.center.x -= view.bounds.width
        SpeakingUIButton.center.y  -= view.bounds.height
        
        //move the elements back
        UIView.animate(withDuration: 2 , delay: 0 , usingSpringWithDamping: 0.3 , initialSpringVelocity: 8 , options: [] , animations: {
            self.TimeTextView.center.y += self.view.bounds.height
            self.LocationTextView.center.y += self.view.bounds.height
            self.TempTextView.center.x += self.view.bounds.width
            self.PressureTextView.center.x -= self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 1) {
            self.SpeakingUIButton.center.y += self.view.bounds.height
            self.StayHomeUIButton.center.x -= self.view.bounds.width
            self.OutsideUIButton.center.x += self.view.bounds.width
        }
        
    }
    
    //Get the longitude and latitude from devices
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        currentLocation = location
        if (location.horizontalAccuracy > 0) {
                    self.locationManager.stopUpdatingLocation()
                    print("latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)")
                    self.locationManager.stopUpdatingLocation()
        }
        //Call the method transfer the longtitude and latitude to address
        locationToAddress ()
    }
    
    //Set the time on TimeTextView
    @objc func setTime() {
        var date = NSDate()
        var dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier:"en_US") as Locale
        dateformatter.dateFormat = "yyyy-MM-dd \nHH:mm:ss"
        var strNowTime = dateformatter.string(from: date as Date) as String
        TimeTextView.text = strNowTime;
    }

    //Transfer the longitude and latitude to address
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
    
    //Display the alert message
    func displayMessage(withTitle: String, message: String){
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
}

