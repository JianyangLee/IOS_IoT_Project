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
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set gif image
        homeImageView.loadGif(name: "house")
        
        //Set round button content
        roundButton()
        
        //Speak out the information
        let utterance = AVSpeechUtterance(string: "It is monitoring your home.")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        //get system sound
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        //format the date for firebase
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
        //User need wear the devices then power on the device. If user wears the devices with power on, it will create some wrong error message. We clean those massage here in case use use it in a wrong way and get wrong warnings
    FirebaseDatabase.Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Motion").removeValue()
        
        //Monitor the firebase
        self.ref = Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Motion")
        self.ref?.observe(.childAdded, with: { (snapshot) in
            guard let restDict = snapshot.value as? [String: Any] else { return }
            self.displayMessage(withTitle: "Warning", message: "Be care, somebody is in your house.")
        })
        
        //Set background
        self.view.layer.contents = UIImage(named:"stayhome")?.cgImage
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
          //Remove all observers when quit the page.
          self.ref.removeAllObservers()
      }
    
    //Set alert when the sensor detect the theif
    func displayMessage(withTitle: String, message: String){
        for _ in 1...3 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            usleep(600000)
        }
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert,animated: true,completion: nil)
        AudioServicesPlaySystemSound (1008)
        sleep(2)
        let utterance = AVSpeechUtterance(string: "Be care, somebody is entering into your house.")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
            
         }
    
    //Change the button content
    func roundButton(){
        var arr = [UIImage]()
        let w : CGFloat = 200
        for i in 0 ..< 200 {
          UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: w), false, 0)
          let context = UIGraphicsGetCurrentContext()!
          context.setFillColor(UIColor.red.cgColor)
          let ii = CGFloat(i)
          let rect = CGRect(x: ii, y:ii, width: w-ii*2, height: w-ii*2)
          context.addEllipse(in: rect)
          context.fillPath()
          let im = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()
          arr.append(im)
        }
        let im = UIImage.animatedImage(with: arr, duration: 3)
        self.startButton.setImage(im, for: .normal)
    }
    
//    func displaySoundsAlert() {
//        let alert = UIAlertController(title: "Warning", message: nil, preferredStyle: UIAlertController.Style.alert)
//        for _ in 1...3 {
//                       AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//                       usleep(600000)
//                   }
//        alert.addAction(UIAlertAction(title: "Be care, somebody is in your house.", style: .default, handler: {_ in
//            AudioServicesPlayAlertSound(UInt32(1008))
//            self.displaySoundsAlert()
//        }))
//
//        AudioServicesPlaySystemSound (1008)
//        sleep(2)
//        let utterance = AVSpeechUtterance(string: "Be care, somebody is in your house.")
//        let synth = AVSpeechSynthesizer()
//        synth.speak(utterance)
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    
}
