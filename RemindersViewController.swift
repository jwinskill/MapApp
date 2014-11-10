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

class RemindersViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reminders"
        tableView.dataSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.context = appDelegate.managedObjectContext!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
        
        var fetchRequest = NSFetchRequest(entityName: "Reminder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        var error : NSError?
        if !self.fetchedResultsController.performFetch(&error) {
            println(error?.description)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REMINDER_CELL") as UITableViewCell
        let reminder = self.fetchedResultsController.fetchedObjects?[indexPath.row] as Reminder
        cell.textLabel.text = reminder.date.description
        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    func didGetCloudChanges(notification: NSNotification) {
        self.context.mergeChangesFromContextDidSaveNotification(notification)
    }

}
