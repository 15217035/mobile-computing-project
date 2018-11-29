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
import FirebaseAuth

class BookDetailViewController: UIViewController {
    @IBOutlet weak var bookName: UILabel!
    
    @IBOutlet weak var bookAuthor: UILabel!
    
    @IBOutlet weak var bookDetail: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    var bookNameString:String = ""
   var bookDetailsString:String = ""
 
    var userLogin = false
    
    var book_id:String = "0001"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        
        let docRef = db.collection("Books").document(book_id)
        
        self.hideKeyboardWhenTappedAround()
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                
               if let name = document.data()?["name"],
                let image = document.data()?["image"],
                let author = document.data()?["author"],
                let detail = document.data()?["detail"]
                {
                    self.bookName.text = "\(name)"
                     self.bookAuthor.text = "\(author)"
                     self.bookDetail.text = "\(detail)"
                    
                    self.bookNameString = "\(name)"
                    self.bookDetailsString = "\(detail)"
                    // load image from firebase Storage
                    let storage = Storage.storage(url:"gs://bookcomment-5a437.appspot.com")
                    let storageRef = storage.reference()
                    
                    let fileName = "\(image)"
                    
                    let ImageRef = storageRef.child("Book")
                    
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

    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.string(forKey: "userid") != nil){
            self.userLogin = true
        }else{
            self.userLogin = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func shaerdBtnClicked(_ sender: Any) {
        
        let content = "\(self.bookNameString) is an amazing book. \(self.bookDetailsString)"
        let activityController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
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
