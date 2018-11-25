//
//  BookTableViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 15/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

struct Book {
    
    var name:String
    var author:String
    var book_id:String
    var book_image:String
    
}



class BookTableViewController: UITableViewController {
    var bookArr = [Book]()
    
//    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let ref = Firestore.firestore().collection("Books").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {

//                if let d = querySnapshot?.documents[0] {
//                    self.book?.author = d.data()["author"]
//                    print("--------------\(d)")
//                }
                
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")

                    
                    if let name = document.data()["name"],
                    let author = document.data()["author"],
                    let image = document.data()["image"]{
                    
                        
                        self.bookArr.append(Book(name: "\(name)",
                            author: "\(author)",
                            book_id: "\(document.documentID)",
                            book_image:"\(image)"))
                        
                    }
                
                }
                self.tableView.reloadData()
            }
            
        }
        
//        print(self.bookArr[0])
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        print(self.bookArr.count)
        return self.bookArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell3", for: indexPath)
//        cell.textLabel?.text = bookArr[indexPath.row].name
        // Configure the cell...
//        cell.textLabel?.text = bookArray[indexPath.row].name
        
        if let cellImage = cell.viewWithTag(110) as? UIImageView {
            
            // load a list of image from firebase Storage
            let storage = Storage.storage(url:"gs://bookexchangeapp-1d759.appspot.com")
            let storageRef = storage.reference()
            
            let fileName = bookArr[indexPath.row].book_image
            
            let ImageRef = storageRef.child("book")
            
            let eventImageRef = ImageRef.child(fileName)
            
            eventImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else {
//                    self.imageArr.append(UIImage(data: data!)!)
//                    self.tableView.reloadData()
                    cellImage.image = UIImage(data: data!)!
                }
            }

        }
        
        if let cellLabel = cell.viewWithTag(111) as? UILabel {
            print("111")
            cellLabel.text = self.bookArr[indexPath.row].name
        }
        
        if let cellLabel = cell.viewWithTag(112) as? UILabel {
            print("112")
            cellLabel.text = self.bookArr[indexPath.row].author
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showBookDetail" {
            
            if let viewController = segue.destination as? BookDetailViewController {
                
                var selectedIndex = tableView.indexPathForSelectedRow!
                
                viewController.book_id = self.bookArr[selectedIndex.row].book_id
                
            }
        }
    
    
    }
 

}
