//
//  AtHomeViewController.swift
//  VisualAssistant
//
//  Created by George Leigh on 27/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import AVFoundation

class AtHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let utterance = AVSpeechUtterance(string: "Now, you are arriving at home")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
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
