//
//  AccountTableViewController.swift
//  bookExchangeApp
//
//  Created by christy on 20/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import Photos
import Foundation


class AccountTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    var userLogin = false
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var uploadIconBtn: UIButton!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var welcomeText: UILabel!
    
    @IBOutlet var usernameLabel: UILabel!
    
   var icon:UIImage = UIImage()
    
    let iconPicker = UIImagePickerController()
    
     let nav = UINavigationController()
    
    var myUserID:String = ""
    var myUsername:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.string(forKey: "userid") != nil) {
            self.myUsername = UserDefaults.standard.string(forKey: "userid") as! String
            self.userLogin = true
             uploadIconBtn.isHidden = false
            self.myUserID = Auth.auth().currentUser!.uid
            self.setUserIcon()
        }else {
            userLogin = false
            uploadIconBtn.isHidden = true
            self.setDefaultIcon()
        }
        view.reloadInputViews()
        tableView.reloadData()
    }
    // MARK: - Table view data source

    func setUserIcon(){
        let ref = Firestore.firestore().collection("Users").document("\(self.myUserID)").getDocument{ (document, error) in
            if let document = document, document.exists {
                if let icon = document.data()?["icon"] {
                    let storage = Storage.storage(url:"gs://bookcomment-5a437.appspot.com")
                    let storageRef = storage.reference()
                    let fileName = icon
                    
                    let ImageRef = storageRef.child("User")
                    
                    let eventImageRef = ImageRef.child(fileName as! String)
                    
                    eventImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("error: \(error.localizedDescription)")
                        } else {
                            self.iconImage.image = UIImage(data: data!)!
                            self.iconImage.layer.cornerRadius = self.iconImage.frame.height / 2
                            self.iconImage.clipsToBounds = true
                        }
                    }
                }
            }
        }
    }
    
    func setDefaultIcon(){
        let storage = Storage.storage(url:"gs://bookcomment-5a437.appspot.com")
        let storageRef = storage.reference()
        let fileName = "default.jpg"
        
        let ImageRef = storageRef.child("User")
        
        let eventImageRef = ImageRef.child(fileName)
        
        eventImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                self.iconImage.image = UIImage(data: data!)!
                self.iconImage.layer.cornerRadius = self.iconImage.frame.height / 2
                self.iconImage.clipsToBounds = true
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
    
        usernameLabel.text = UserDefaults.standard.string(forKey: "userid") ?? "Visitor"
        
                if(userLogin){
                    if(indexPath.row == 0){
                        cell.textLabel?.text = "Log out"
                    }else if (indexPath.row == 1){
                        cell.textLabel?.text = "My book list"
                    }else if (indexPath.row == 2){
                        cell.textLabel?.text = "Notification"
                    }
                }else {
                if(indexPath.row == 0){
                   cell.textLabel?.text = "Log in"
                }else {
                      cell.textLabel?.text = ""
                }
                }
        
        return cell
    }
    
    func accountLogout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.userLogin = false
            let alertController = UIAlertController(title: "Logout", message: "Successfully", preferredStyle: .alert)
            UserDefaults.standard.set(nil, forKey: "userid")
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            self.setDefaultIcon()
            tableView.reloadData()
           
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        }
    

    

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.row == 0){
            if(userLogin){
                let alertController = UIAlertController(title: "Logout", message: "Are you Sure?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {( alertController: UIAlertAction?) in self.accountLogout()}))
                self.present(alertController, animated: true, completion: nil)
            }else if(!userLogin){
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
        }
        
        if(userLogin){
        if (indexPath.row == 1){
            self.performSegue(withIdentifier: "showBookList", sender: self)
        }else if (indexPath.row == 2 ){
              self.performSegue(withIdentifier: "showMessage", sender: self)
        }
        }
    }
    
    
    
    @IBAction func uploadIconClicked(_ sender: Any) {
        
        
        
                let alert = UIAlertController(title: "Upload Icon", message:"Choose upload method", preferredStyle: .actionSheet)
                let actionOne = UIAlertAction(title:"Photo", style: .default){ (action) in
                                self.uploadIconByLibrary()
                    self.present(self, animated: true, completion: nil)
    
                }
    
    
        //        //second action
       let actionTwo = UIAlertAction(title:"Camera", style: .default){ (action) in
        self.uploadIconByCamera(true)
        self.present(self, animated: true, completion: nil)
        //
        }
     
        //Cancel
        let cancel = UIAlertAction(title:"Cancel", style: .default){  (alertAction: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
            //
        }
        
                alert.addAction(actionOne)
          alert.addAction(actionTwo)
          alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)

    }
    
    func saveIcon(){
        
        let image_set_name:String = "\(self.myUsername).jpg"
        
            let ref = Firestore.firestore().collection("Users").document(self.myUserID)
            ref.updateData([
                "icon":image_set_name
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        
        let imageData: Data = UIImagePNGRepresentation(icon)!

        let storageRef = Storage.storage().reference()
        let folderRef = storageRef.child("User")
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

    func addPhotoFromLibaryGo(){
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        iconPicker.sourceType = .photoLibrary
        iconPicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(iconPicker, animated: true)
     
    }
    
    func addPhotoFromCameraGo(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("camera not supported by this device")
            return
        }
        iconPicker.sourceType = .camera
        iconPicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(iconPicker, animated: true)
   
    }

    func uploadIconByLibrary(){

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
    
    func addAlertForSettings(){
        let alert = UIAlertController(title: "Alert", message: "We need the permission", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "I'll do it later", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func uploadIconByCamera(_ sender: Any) {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status{
        case .authorized: // The user has previously granted access to the camera.
            self.addPhotoFromCameraGo()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.addPhotoFromCameraGo()
                } else {
                    self.addAlertForSettings()
                }
            }
            //denied - The user has previously denied access.
        //restricted - The user can't grant access due to restrictions.
        case .denied, .restricted:
            self.addAlertForSettings()
            return
            
        default:
            break
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.icon = image
        self.iconImage.image = image
        self.iconImage.layer.cornerRadius = self.iconImage.frame.height / 2
        self.iconImage.clipsToBounds = true
        saveIcon()
        picker.dismiss(animated:true, completion: nil)
        
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

