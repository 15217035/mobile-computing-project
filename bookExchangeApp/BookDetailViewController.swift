//
//  BookDetailViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 21/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class BookDetailViewController: UIViewController {
    @IBOutlet weak var bookName: UILabel!
    
    @IBOutlet weak var bookAuthor: UILabel!
    
    @IBOutlet weak var bookDetail: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    var book_id:String = "0001"
    
    
    @IBOutlet weak var tableComment: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Books").document(book_id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                
                if let name = document.data()?["name"],
                let image = document.data()?["image"]{
                    self.bookName.text = "\(name)"
                    
                    
                    
                    // load image from firebase Storage
                    let storage = Storage.storage(url:"gs://bookexchangeapp-1d759.appspot.com")
                    let storageRef = storage.reference()
                    
                    let fileName = "\(image)"
                    
                    let ImageRef = storageRef.child("book")
                    
                    let eventImageRef = ImageRef.child(fileName)
                    
                    eventImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("--------------error: \(error.localizedDescription)")
                        } else {
                            let image = UIImage(data: data!)
                            self.bookImage.image = image
                        }
                    }
                    
                }
                
                
            } else {
                print("Document does not exist")
            }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "showComment" {
            
            if let viewController = segue.destination as? CommentTableViewController {
                
                
                
                viewController.book_id = book_id
                
            }
        }
    }
    

}
