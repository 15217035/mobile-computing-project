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
        
      
            if let Label1 = cell.viewWithTag(301) as? UILabel {
                
                if(userLogin){
                    if(indexPath.row == 0){
                        Label1.text = UserDefaults.standard.string(forKey: "userid") ?? "Please login first."
                        if let iconImage = cell.viewWithTag(302) as? UIImageView {
                            iconImage.isHidden = false;
                        }
                    }else if(indexPath.row == 1){
                        Label1.text = "Log out"
                    }else if (indexPath.row == 2){
                        Label1.text = "My book list"
                    }else if (indexPath.row == 3){
                        Label1.text = "Notification"
                    }
                }else {
                if(indexPath.row == 0){
                    Label1.text = "Please login first."
                }else if(indexPath.row == 1){
                        Label1.text = "Log in"
                    }else {
                        Label1.text = ""
                }
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
        
        try! Auth.auth().signOut()
    }

    

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.row == 1){
            if(userLogin){
                accountLogout()
            }else if(!userLogin){
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
        }
        
        if(UserDefaults.standard.string(forKey: "userid") != nil){
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

