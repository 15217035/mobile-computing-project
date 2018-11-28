//
//  LoginViewController.swift
//  bookExchangeApp
//
//  Created by 15221407 on 23/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet  weak  var userid: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: userid.text!, password: password.text!) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if let user = user?.user {
                print(user.uid)
                UserDefaults.standard.set(user.email, forKey: "userid")
            }
            
            let alertController = UIAlertController(title: "Login", message: "Successfully", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(alertAction)in  self.navigationController?.popToRootViewController(animated: true)}))
            self.present(alertController, animated: true, completion: nil)
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        
        
        
        
    }
        
    
    
    
        // Do any additional setup after loading the view
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
