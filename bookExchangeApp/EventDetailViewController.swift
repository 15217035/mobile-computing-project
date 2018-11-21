//
//  EventDetailViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 21/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseFirestore



class EventDetailViewController: UIViewController {
    
    var event_id:String = "empty"
    var event_name:String = "empty"
    
    
    // for next page addr
    var event_addr:GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var locationName:String = "error"
    
    @IBOutlet weak var eventName: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Events").document(event_id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                
                if let name = document.data()?["name"],
                    let location = document.data()?["location"]{
                    
                    self.eventName.text = "\(name)"
                    
                    self.event_name = "\(name)"
                    
                    self.event_addr = document.data()?["address"] as! GeoPoint
                    self.locationName = "\(location)"
                    

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
        
        if segue.identifier == "showAddress" {
            
            if let viewController = segue.destination as? MapViewController {
                
                
                viewController.lat = event_addr.latitude
                viewController.lon = event_addr.longitude
                viewController.name = locationName
                viewController.eventName = event_name
                
                
            }
        }
    }
    

}
