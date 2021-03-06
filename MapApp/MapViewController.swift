//
//  ViewController.swift
//  MapApp
//
//  Created by Joshua Winskill on 11/3/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        self.mapView.addGestureRecognizer(longPress)
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("Authorized")
            self.locationManager.startUpdatingLocation()
        case .Denied:
            println("Denied")
        case .NotDetermined:
            println("Not determined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("Restricted")
        default:
            println("Defaulted")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reminderAdded:", name: "REMINDER_ADDED", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            self.locationManager.startUpdatingLocation()
        default:
            println("Some opther authorization status")
        }
    }
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(self.mapView)
            let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            println("latitude: \(touchCoordinate.latitude), longitude: \(touchCoordinate.longitude)")
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Place of Interest"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let mdViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MAP_DETAIL") as MapDetailViewController
        mdViewController.locationManager = self.locationManager
        mdViewController.selectedAnnotation = view.annotation
        self.presentViewController(mdViewController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("great success!")
        if let circularRegion = region as? CLCircularRegion {
            if (UIApplication.sharedApplication().applicationState == UIApplicationState.Background) {
                let notification = UILocalNotification()
                notification.alertAction = "Reminder Triggered"
                notification.alertBody = "You have entered a set area"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("I'm outta here")
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        
        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
        renderer.strokeColor = UIColor.blackColor()
        
        return renderer
    }
    
    func reminderAdded(notification: NSNotification) {
        let userInfo = notification.userInfo
        let geoRegion = userInfo?["region"] as CLCircularRegion
        
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
        self.mapView.addOverlay(overlay)
    }

}

