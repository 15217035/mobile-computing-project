//
//  NotificationTableViewController.swift
//  bookExchangeApp
//
//  Created by christy on 25/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct message {
    
    var from:String
    var bookname:String
    var book_id: String
    
}

class NotificationTableViewController: UITableViewController {
    var messageArr = [message]()
    
    var myUserID:String = ""
    var book_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myUserID = Auth.auth().currentUser!.uid
        
        let ref = Firestore.firestore().collection("Users")
        let messageRef = ref.document(self.myUserID).collection("message")
         print("MyID: \(self.myUserID)")
        let messagesRef = messageRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.book_id = document.data()["book_id"] as! String
                    
                    if let from = document.data()["from"],
                        let bookname = document.data()["bookname"],
                    let book_id = document.data()["book_id"]{
                    
                        self.messageArr.append(message(from: "\(from)", bookname : "\(bookname)", book_id:"\(book_id)"))
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        cell.textLabel?.text = "\(messageArr[indexPath.row].from) leave a message in \(messageArr[indexPath.row].bookname) chatroom"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showComment" {
            if let viewController = segue.destination as? CommentTableViewController {
                viewController.book_id = self.book_id
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
