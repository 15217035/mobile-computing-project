//
//  MapViewController.swift
//  bookExchangeApp
//
//  Created by 15217035 on 21/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var lat:Double = 22.3380838
    var lon:Double = 114.18186
    var name:String = "error"
    var eventName = "error"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        
        let regionRadius: CLLocationDistance = 300
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
//        mapView.showsUserLocation = true
        
        let location = MKPointAnnotation()
        
        location.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        location.title = name
        location.subtitle = eventName
        
        mapView.addAnnotation(location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
