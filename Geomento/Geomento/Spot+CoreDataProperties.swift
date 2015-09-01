//
//  Spot+CoreDataProperties.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Spot {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var photo: NSObject?
    @NSManaged var comments: String?

}
