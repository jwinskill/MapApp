//
//  Reminder.swift
//  MapApp
//
//  Created by Joshua Winskill on 11/4/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var radius: NSNumber

}
