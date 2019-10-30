//
//  AtHomeViewController.swift
//  VisualAssistant
//
//  Created by George Leigh on 27/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class AtHomeViewController: UIViewController {
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
        let utterance = AVSpeechUtterance(string: "Now, you are arriving at home. The device will continue to monitor your door.")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        self.ref = Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Distance")
        
        self.ref?.observe(.childAdded, with: { (snapshot) in
            guard let restDict = snapshot.value as? [String: Any] else { return }
            let value = restDict["distance"] as! NSNumber
            
            let distance = value as? Float
            
            let utterance = AVSpeechUtterance(string: "Hi, something is near your door, please check.")
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        })
        
        
        //Speak out
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
