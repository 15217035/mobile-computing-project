//
//  CommentTableViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 24/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct comment {
    
    var from:String
    var content:String
    
}

class CommentTableViewController: UITableViewController {
    
    @IBOutlet var commentTF: UITextField!
    @IBOutlet var booknameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    var items: [String] = ["Swift1", "Swift2", "Swift3"]
    
    var commentArr = [comment]()
    
    var book_id:String = "empty"
    
    var myUserID = ""
    var myUsername = ""
    
    var bookname:String = ""
    var author:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let docRef = Firestore.firestore().collection("Books").document(book_id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
             
                if let name = document.data()?["name"],
                    let author = document.data()?["author"]{
                    self.booknameLabel.text  = "Book: \(name)" as? String;
                    self.authorLabel.text = "Author: \(author)" as? String
                }
            }
        
        let ref = Firestore.firestore().collection("Books")
            let commentRef = ref.document(self.book_id).collection("comment")
        let commentsRef = commentRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    if let username = document.data()["from"],
                        let content = document.data()["content"]{
    
                        self.commentArr.append(comment(from: "\(username)",
                            content: "\(content)"))
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        }
    }

    @IBAction func postClicked(_ sender: Any) {
        if(UserDefaults.standard.string(forKey: "userid") == nil){
            let alertController = UIAlertController(title: "Error", message: "Please login first", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            self.myUserID = Auth.auth().currentUser!.uid
            self.myUsername = Auth.auth().currentUser!.email ?? ""
            var ref: DocumentReference? = nil
            ref = Firestore.firestore().document("Books/\(book_id)").collection("comment").addDocument(data: [
                "content": commentTF.text ?? "",
                "userId": self.myUserID,
                "from": self.myUsername
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.commentArr.append(comment(from: "\(self.myUsername)",
                        content: "\(self.commentTF.text ?? "")"))
                    self.commentTF.text = ""
                    self.tableView.reloadData()
                }
            }
           
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        if let fromLabel = cell.viewWithTag(111) as? UILabel {
          fromLabel.text = "From " + commentArr[indexPath.row].from
        }
        
        if let contentLabel = cell.viewWithTag(112) as? UILabel {
            contentLabel.text = commentArr[indexPath.row].content
        }
    
        return cell
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
