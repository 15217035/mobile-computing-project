//
//  EventDetailViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 21/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseFirestore

import EventKit

class EventDetailViewController: UIViewController {
    
    var event_id:String = "empty"
    var event_name:String = "empty"
    var start_time:String = "empty"
    var end_time:String = "empty"
    
    
    // for next page addr
    var event_addr:GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var locationName:String = "error"
    
    // for labelUI
    @IBOutlet weak var eventName: UILabel!
    
    
    // for button
    @IBAction func clickToAddCal(_ sender: Any) {
         checkCalendarAuthorizationStatus()
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
                let location = document.data()?["location"],
                let startTime = document.data()?["startTime"],
                let endTime = document.data()?["endTime"],
                let startDate = document.data()?["startDate"],
                let endDate = document.data()?["endDate"]{
                    
                    self.eventName.text = "\(name)"
                    
                    self.event_name = "\(name)"
                    self.start_time = "\(startDate) \(startTime)"
                    self.end_time = "\(endDate) \(endTime)"
                    
                    self.event_addr = document.data()?["address"] as! GeoPoint
                    self.locationName = "\(location)"
                    

                }
                
            } else {
                print("Document does not exist")
            }
        }
        
        
//        // Points to the root reference
//        let storageRef = Storage.storage().reference()
//
//        // Points to "images"
//        let imagesRef = storageRef.child("images")
//
//        // Points to "images/space.jpg"
//        // Note that you can use variables to create child values
//        let fileName = "space.jpg"
//        let spaceRef = imagesRef.child(fileName)
//
//        // File path is "images/space.jpg"
//        let path = spaceRef.fullPath;
//
//        // File name is "space.jpg"
//        let name = spaceRef.name;
//
//        // Points to "images"
//        let images = spaceRef.parent()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // alert to show fail
        let alert = UIAlertController(title: "Alert", message: "We need the permission to Your Calendar", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "I'll do it later", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadCalendars(){
//        let startdate:Date
//        let enddate:Date
//        if let unixTimestamp = Double(start_time){
//         startdate = Date(timeIntervalSince1970: unixTimestamp)
//        }
//
//        if let unixTimestamp2 = Double(end_time){
//         enddate = Date(timeIntervalSince1970: unixTimestamp2)
//        }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: start_time)
        
        let someDateTime2 = formatter.date(from: end_time)
        
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = self.event_name
                event.startDate = someDateTime
                event.endDate = someDateTime2
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
                
                // alert to show success
                let alert = UIAlertController(title: "You have successfully added", message: "Please go to Calendar and check", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
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
