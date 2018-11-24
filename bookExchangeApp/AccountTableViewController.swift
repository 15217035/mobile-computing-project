//
//  AccountTableViewController.swift
//  bookExchangeApp
//
//  Created by christy on 20/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountTableViewController: UITableViewController {
 var userLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.string(forKey: "userid") != nil){
            self.userLogin = true
        }
            tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
    
                if(userLogin){
                    if(indexPath.row == 0){
                        cell.textLabel?.text = UserDefaults.standard.string(forKey: "userid") ?? "Please login first."
                        if let iconImage = cell.viewWithTag(302) as? UIImageView {
                            iconImage.isHidden = false;
                        }
                    }else if(indexPath.row == 1){
                        cell.textLabel?.text = "Log out"
                    }else if (indexPath.row == 2){
                        cell.textLabel?.text = "My book list"
                    }else if (indexPath.row == 3){
                        cell.textLabel?.text = "Notification"
                    }
                }else {
                if(indexPath.row == 0){
                    cell.textLabel?.text = "Please login first."
                }else if(indexPath.row == 1){
                     cell.textLabel?.text = "Log in"
                    }else {
                      cell.textLabel?.text = ""
                }
                }
        
        if let iconImage = cell.viewWithTag(302) as? UIImageView {
           
            if(indexPath.row == 0){
                iconImage.isHidden = false;
            }else {
                iconImage.isHidden = true;
            }
        }
        
        
        
       
        return cell
    }
    
    func accountLogout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.userLogin = false
            tableView.reloadData()
            let alertController = UIAlertController(title: "Logout", message: "Successfully", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
           
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        

        }
    

    

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.row == 1){
            if(userLogin){
                let alertController = UIAlertController(title: "Logout", message: "Are you Sure?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {( alertController: UIAlertAction?) in self.accountLogout()}))
                self.present(alertController, animated: true, completion: nil)
            }else if(!userLogin){
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
        }
        
        if(userLogin){
        if (indexPath.row == 2){
            self.performSegue(withIdentifier: "showBookList", sender: self)
        }else if (indexPath.row == 3 ){
            
        }
        }
    }
}



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

