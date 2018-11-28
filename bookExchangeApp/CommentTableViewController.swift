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
import Alamofire

struct comment {
    
    var from:String
    var content:String
    
}

class CommentTableViewController: UITableViewController {
    
    @IBOutlet var commentTF: UITextField!
    @IBOutlet var booknameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    var commentArr = [comment]()
    
    var book_id:String = "empty"
    
    var myUserID = ""
    var myUsername = ""
    
    var bookname:String = ""
    var author:String = ""
    var bookOwner:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
        let docRef = Firestore.firestore().collection("Books").document(book_id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.bookOwner = document.data()?["ownerId"] as! String
                self.bookname = document.data()?["name"] as! String
                self.author = document.data()?["author"] as! String
                self.booknameLabel.text  = "Book: \(self.bookname)"
                self.authorLabel.text = "Author: \(self.author)"
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
        }else if (commentTF.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please input message", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
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
                    self.push()
                  
                }
            }
           
        }
    }
    
    func push(){
        
        
        
 var token = ""
        
        
        
        let ref = Firestore.firestore().collection("Users").document("\(self.bookOwner)").getDocument{ (document, error) in
            if let document = document, document.exists {
                if let token1 = document.data()?["token"] {
                     token = "\(token1)"

                    let parameters: [String: AnyObject] = [
                        "token" : token as AnyObject ,
                        "message" : "\(self.myUsername) leave a message in \(self.bookname) chatroom." as AnyObject
                    ]
                    print(parameters)
                    
                    
                    let url = "http://158.182.12.165:1337/Message/received"
                    
                    Alamofire.request(url, method: .post, parameters: parameters).validate().responseJSON { response in
                        
                        print("Result: \(response.result)") // response serialization result
                        
                        switch response.result {
                            
                        case .success(let value):
                            
                            print("JSON: \(value)")     // serialized json response
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            }
            

    }
    
    
    func notification(){
        if self.myUserID == self.bookOwner{
            return
        }
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().document("Users/\(self.bookOwner)").collection("message").addDocument(data: [
            "bookname": self.bookname,
            "from": self.myUsername,
            "book_id" : self.book_id
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.updateCount()
            }
        }
          self.push()
        
        
    }
    
    func updateCount(){
        var count:Int = 0
        
        let docRef = Firestore.firestore().collection("Users").document(self.bookOwner)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                count = document.data()?["count"] as! Int
            }
        }
        
        count = count + 1
       
        Firestore.firestore().collection("Users").document(self.bookOwner).setData([ "count": count], merge: true)
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
