//
//  AddNewBookViewController.swift
//  bookExchangeApp
//
//  Created by christy on 24/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AddNewBookViewController: UIViewController {

    @IBOutlet var bookNameTF: UITextField!
    @IBOutlet var authorTF: UITextField!
    
   
   var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userID = Auth.auth().currentUser!.uid
    }
    
    @IBAction func addBookClicked(_ sender: Any) {
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Books").addDocument(data: [
            "name": bookNameTF.text ?? "",
            "author": authorTF.text ?? "",
            "ownerId": self.userID,
            "book_id": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let alertController = UIAlertController(title: "Add New Book", message: "Successfully", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(alertAction)in self.navigationController?.popViewController(animated: true)}))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }


}
