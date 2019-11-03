//
//  LoginViewController.swift
//  VisualAssistant
//
//  Created by Lee on 13/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth
import AudioToolbox

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var control: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self     
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //
        return true
    }
    
    @IBAction func btnLogin(_ sender: Any) {
         let email = username.text!
         let passwd = password.text!
                Auth.auth().signIn(withEmail: email, password: passwd){
                    [weak self] user, error in
                    guard let strongSelf = self else { return }
                    if (error != nil){
                        strongSelf.statusLabel.text = "Error, Check your user email and password"
                        self!.username.text = ""
                        self!.password.text = ""
                        print(error)
                        return
                    }
                    self!.button.setTitle("Confirm", for: .normal)
                    strongSelf.statusLabel.text = "Verification done!"
                    self!.control = true
                    //Alert enter
                    //Before going to home page
                    //entering ID
                    self!.alertEnter()
        //            self!.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
    }
    
    func alertEnter(){
        let alertController = UIAlertController(title: "Enter device ID", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter unique ID"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
           
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
      

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destination = segue.destination as! ViewController
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
          if identifier == "loginSegue"{
              if control {
                  return true
              }
              return false
          }
          return true
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
