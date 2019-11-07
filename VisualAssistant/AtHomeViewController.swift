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
        homeImageView.loadGif(name: "house")
        animate()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
    FirebaseDatabase.Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Motion").removeValue()
        let utterance = AVSpeechUtterance(string: "It is monitoring your home.")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        self.ref = Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Motion")

        self.ref?.observe(.childAdded, with: { (snapshot) in
            guard let restDict = snapshot.value as? [String: Any] else { return }
            
            self.displayMessage(withTitle: "Warning", message: "Be care, somebody is in your house.")

        })
        
        self.view.layer.contents = UIImage(named:"stayhome")?.cgImage
        //Speak out
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
          //Remove all observers when quit the page.
          self.ref.removeAllObservers()
      }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        let utterance = AVSpeechUtterance(string: "Be care, somebody is enter into your house.")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
            
         }
    func animate(){
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
