//
//  MapDetailViewController.swift
//  MapApp
//
//  Created by Joshua Winskill on 11/3/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapDetailViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addRegionButtonPressed(sender: AnyObject) {
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 100.0, identifier: "TEST_REGION")
        self.locationManager.startMonitoringForRegion(geoRegion)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
