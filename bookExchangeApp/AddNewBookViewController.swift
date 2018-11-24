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
import Photos

class AddNewBookViewController: UIViewController {

    @IBOutlet var bookNameTF: UITextField!
    @IBOutlet var authorTF: UITextField!
    
    @IBOutlet weak var checkPhotoUpload: UILabel!
    @IBOutlet weak var photoUploadImage: UIImageView!
    
    var userID = ""
    
    var image:UIImage = UIImage()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userID = Auth.auth().currentUser!.uid
    }
    
    @IBAction func addBookClicked(_ sender: Any) {
        let image_set_name:String = "\(self.userID) \(bookNameTF.text ?? "123").jpg"
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Books").addDocument(data: [
            "name": bookNameTF.text ?? "",
            "author": authorTF.text ?? "",
            "ownerId": self.userID,
            "book_id": "",
            "image": image_set_name
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
        
       

        let imageData: Data = UIImagePNGRepresentation(image)!
//        UIImage(data:imageData,scale:1.0)
        
        // Create a reference to the file you want to upload
        let storageRef = Storage.storage().reference()
        let folderRef = storageRef.child("book")
        let riversRef = folderRef.child(image_set_name)
        
        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putData(imageData, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
    }

    @IBAction func addPhotoFromLibary(_ sender: Any) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
            case .authorized:
                self.addPhotoFromLibaryGo()
                print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)")
                    if newStatus == PHAuthorizationStatus.authorized {
                        print("success")
                        self.addPhotoFromLibaryGo()
                    }
                })
            case .restricted:
                print("User do not have access to photo album.")
            case .denied:
                print("User has denied the permission.")
            
        }
        
    }
        
    func addPhotoFromLibaryGo(){
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
              print("can't open photo library")
              return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    // unfinished
    @IBAction func addPhotoFromCamera(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("camera not supported by this device")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }
    
}

extension AddNewBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        defer {
//            picker.dismiss(animated: true)
//        }
//
//        print(info)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.image = image
        self.photoUploadImage.image = image
        
        print("---------hihihi i hihihi_______")
        self.checkPhotoUpload.text = "You have uploaded"
        
        
        picker.dismiss(animated:true, completion: nil)
        
    }
}
