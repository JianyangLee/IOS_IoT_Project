//
//  ViewController.swift
//  VisualAssistant
//
//  Created by Lee on 13/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var TimeTextView: UILabel!
    @IBOutlet weak var LocationTextView: UILabel!
    @IBOutlet weak var TempTextView: UILabel!
    @IBOutlet weak var PressureTextView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 1.0,target:self,selector: #selector(self.setTime), userInfo: nil, repeats: true )
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
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
    let location = CLLocation(latitude: -37, longitude: 145)
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
        if error == nil {
            let firstLocation = placemarks?[0]
            
            //print(firstLocation!.name, firstLocation!.locality, firstLocation?.administrativeArea, firstLocation!.postalCode)
            
            self.LocationTextView.text = "\((firstLocation!.name)!), \((firstLocation!.locality)!), \((firstLocation!.administrativeArea)!), \((firstLocation!.postalCode)!)"
            
            //completionHandler(firstLocation)
        } else {
            //completionHandler(nil)
        }
    })
    }
}

