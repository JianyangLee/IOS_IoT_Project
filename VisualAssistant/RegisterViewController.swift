//
//  RegisterViewController.swift
//  VisualAssistant
//
//  Created by Lee on 14/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func confirm(_ sender: Any) {
        let email = username.text!
        let psswd = password.text!
             Auth.auth().createUser(withEmail: email, password: psswd){authResult, error in
                 if (error != nil){
                     self.label.text = "Error occurs"
                     print(error)
                     return
                 }
                 self.label.text = "User Created! Please go back to log in."
             }
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
