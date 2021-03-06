//
//  MyLocationContainerViewController.swift
//  PhotoClash
//
//  Created by Cole Conte on 7/14/16.
//  Copyright © 2016 Cole Conte. All rights reserved.
//

import UIKit
import MapKit

class MyLocationContainerViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var didUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.tintColor = UIColor.orange
        map.showsUserLocation = true
        let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
        locationManager!.delegate = self


    }
    
    func addRadiusCircle(_ location: CLLocation){
        map.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 80000 as CLLocationDistance) //50 mi
        map.add(circle)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didUpdate{
            let location = locations.last!
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegionMakeWithDistance(center, 160000, 160000)
            map.setRegion(region, animated: true)
            addRadiusCircle(location)
            didUpdate = true
        }


    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.orange
            circle.fillColor = UIColor.orange.withAlphaComponent(0.2)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    

    
}
