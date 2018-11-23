//
//  EventDetailViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 21/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import FirebaseFirestore

import EventKit

class EventDetailViewController: UIViewController {
    
    var event_id:String = "empty"
    var event_name:String = "empty"
    
    
    // for next page addr
    var event_addr:GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var locationName:String = "error"
    
    @IBOutlet weak var eventName: UILabel!
    
    
    @IBAction func clickToAddCal(_ sender: Any) {
         checkCalendarAuthorizationStatus()
    }
    
    func requestAccessToCalendar() {
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
//                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionView()
                })
            }
        })
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
//            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            needPermissionView()
        }
    }
    
    func needPermissionView(){
        let alert = UIAlertController(title: "Alert", message: "We need the permission to Your Calendar", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "I'll do it later", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadCalendars(){
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "Test Title"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
    
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
