//
//  EventTableViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 15/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


struct eventInfo {
    
    var name:String
    var event_id:String
//    var event_image_url:String
    var event_image:String
    
    
}


class EventTableViewController: UITableViewController {
    var eventArr = [eventInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//         eventArray.append( eventInfo(name: "Book Fair", event_id: 1 ) )

//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
        let ref = Firestore.firestore().collection("Events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    // create a list of data
                    if let name = document.data()["name"],
                        let image = document.data()["image"]{
                        
                        // load a list of event array
                        self.eventArr.append(eventInfo(name: "\(name)",  event_id: "\(document.documentID)", event_image:"\(image)"))
                        
                    }
                }
                self.tableView.reloadData()
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
        return eventArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        if let cellImage = cell.viewWithTag(101) as? UIImageView {
            
            
            // load a list of image from firebase Storage
            let storage = Storage.storage(url:"gs://bookexchangeapp-1d759.appspot.com")
            let storageRef = storage.reference()
            
            let fileName = eventArr[indexPath.row].event_image
            
            let ImageRef = storageRef.child("event")
            
            let eventImageRef = ImageRef.child(fileName)
            
            eventImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else {
                    cellImage.image = UIImage(data: data!)!
                }
            }
            
        }

         if let nameLabel = cell.viewWithTag(102) as? UILabel {
            nameLabel.text = eventArr[indexPath.row].name
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
        if segue.identifier == "showEvent" {
            
            if let viewController = segue.destination as? EventDetailViewController {
                
                var selectedIndex = tableView.indexPathForSelectedRow!
                
                viewController.event_id = self.eventArr[selectedIndex.row].event_id
                
            }
        }
      
    }

}
