//
//  MapViewController.swift
//  iReserve
//
//  Created by Igor Kimieciki on 07/05/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    //@IBOutlet weak var distanceLabel: UILabel!
    var beacons: [CLBeacon]?
    var point = MKPointAnnotation()
    
    let locationManager = CLLocationManager()
    let storeCoordinate = CLLocationCoordinate2DMake(-30.0549214, -51.1869173)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        map.delegate = self
        point.coordinate = storeCoordinate
        point.title = "Loja"
        point.subtitle = "Vários Produtos Aqui"
        map.addAnnotation(point)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            locationManager.startMonitoringSignificantLocationChanges()
            
            map.showsUserLocation = true
            var newRegion = MKCoordinateRegion()
            
        }else {println("Nope")}
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let distance = locationManager.location.distanceFromLocation(CLLocation(latitude: storeCoordinate.latitude, longitude: storeCoordinate.longitude))
        println("distance to store = \(distance)")

        
        var newRegion = MKCoordinateRegion()
        
        newRegion.center.latitude = self.locationManager.location.coordinate.latitude
        newRegion.center.longitude = self.locationManager.location.coordinate.longitude
        
        newRegion.span.latitudeDelta = 0.05
        newRegion.span.longitudeDelta = 0.05
        map.setRegion(newRegion, animated: true)
        //distanceLabel.text = String(Int(distance)) + "m"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("viewForAnnotation - @", annotation.title)
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Red
            
            var calloutButton = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            pinView!.rightCalloutAccessoryView = calloutButton
            
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            println("toProducts!")
            self.performSegueWithIdentifier("toProducts", sender: self)
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
        println("Pin clicked");
        println(view.annotation.title)
        
        
        if (locationManager.location != nil) {
            let distance = locationManager.location.distanceFromLocation(CLLocation(latitude: storeCoordinate.latitude, longitude:      storeCoordinate.longitude))
            println("distance to store = \(distance)")
            //point.title = "Loja - " + String(Int(distance)) + "m"
            point.title = "Loja"
        
            var distanceM = String(Int(distance)) + "m"
            var distanceKM = String(Int(distance/1000)) + "." + String(Int(distance%1000/100)) + "km"
        
            if(distance<1000){
                point.subtitle = distanceM}
            else{
                point.subtitle = distanceKM
            }
        }
        //println(distanceM + " - " + distanceKM)
        
        
        //distanceLabel.text = String(Int(distance)) + "m"
        
        
    }
}
