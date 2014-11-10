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
import CoreData

class MapDetailViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation!
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.context = appDelegate.managedObjectContext!
    
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressReminderButton(sender: AnyObject) {
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 1000.0, identifier: "TEST_REGION")
        self.locationManager.startMonitoringForRegion(geoRegion)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var date = NSDate()
        
        NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region": geoRegion])
        
        var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.context) as Reminder
        newReminder.date = date
        newReminder.latitude = geoRegion.center.latitude
        newReminder.longitude = geoRegion.center.longitude
        newReminder.radius = geoRegion.radius
        
        var error: NSError?
        
        self.context.save(&error)
        if error != nil {
            println(error!.description)
        }
        
    }
    
    
    
}
