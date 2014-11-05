//
//  RemindersViewController.swift
//  MapApp
//
//  Created by Joshua Winskill on 11/4/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class RemindersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var reminders = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setTempRegionForReminder:", name: "REMINDER_ADDED", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setTempDateForReminder:", name: "DATE_FOR_REMINDER", object: nil)
        
        tableView.dataSource = self
    }
    

    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REMINDER_CELL") as UITableViewCell
        let reminder = reminders[indexPath.row]
        return cell
    }

}
