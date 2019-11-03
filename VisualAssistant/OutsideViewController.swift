//
//  OutsideViewController.swift
//  VisualAssistant
//
//  Created by George Leigh on 27/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class OutsideViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var detectingGifImageView: UIImageView!
    @IBOutlet weak var warningText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectingGifImageView.loadGif(name: "detecting")
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
    FirebaseDatabase.Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Distance").removeValue()
        
        let utterance = AVSpeechUtterance(string: "Now, it is detecting the object in front of you.")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        
        self.ref = Database.database().reference().root.child("assignment3-7cbb8").child("Data").child("10001").child(result).child("Distance")
            //Once the new child is added (which measn the distance is less than 1.5 meter, the warning message is spoken out.
        self.ref?.observe(.childAdded, with: { (snapshot) in
            guard let restDict = snapshot.value as? [String: Any] else { return }
//            let value = restDict["distance"] as! NSNumber
            self.displayMessage(withTitle: "Watch out!", message: "Watch out the obstacle.")
//            let distance = value as? Float
            let utterance = AVSpeechUtterance(string: "Watch out.")
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
            
            for _ in 1...5 {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                usleep(600000)
            }         
        })
        self.view.layer.contents = UIImage(named:"outsidebg")?.cgImage
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
           let alert = UIAlertController(title: withTitle, message: message, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert,animated: true,completion: nil)
       }

}
