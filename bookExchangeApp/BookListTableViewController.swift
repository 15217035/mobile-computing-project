//
//  BookListTableViewController.swift
//  bookExchangeApp
//
//  Created by 15221407 on 23/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct myBook {
    
    var name:String
    var author:String
    var book_id:String
    
}

class BookListTableViewController: UITableViewController {
 var userLogin = false
var bookArr = [myBook]()
    var userID = ""
    var ownerId = ""
 
    override func viewDidLoad() {
    super.viewDidLoad()
        let ref = Firestore.firestore().collection("Books").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    self.ownerId = document.data()["ownerId"] as! String
                    self.userID = Auth.auth().currentUser!.uid
                    self.bookArr.removeAll()
                    if self.ownerId == self.userID {
                        if let name = document.data()["name"],
                            let author = document.data()["author"]{
                            self.bookArr.append(myBook(name: "\(name)",  author: "\(author)", book_id: "\(document.documentID)"))
                        }
                    }
                }
            }
        }
        tableView.reloadData()
}


    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.string(forKey: "userid") != nil){
            self.userLogin = true
        }
        self.userID = Auth.auth().currentUser!.uid
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1
        }else{
             return bookArr.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath)
        if(userLogin){
            if(indexPath.row == 0 && indexPath.section == 0){
                cell.textLabel?.text = "+ Add new book"
            }else {
                cell.textLabel?.text = self.bookArr[indexPath.row].name
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        if(userLogin){
            if (indexPath.row == 0){
                self.performSegue(withIdentifier: "showAddBook", sender: self)
            }else if (indexPath.row == 3 ){
                self.performSegue(withIdentifier: "showMyBookDetail", sender: self)
            }
        }
    }



override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "showMyBookDetail" {
        
        if let viewController = segue.destination as? BookDetailViewController {
            
            var selectedIndex = tableView.indexPathForSelectedRow!
            
            viewController.book_id = self.bookArr[selectedIndex.row-1].book_id
            
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

