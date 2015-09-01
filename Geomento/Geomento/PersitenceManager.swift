//
//  Persitence.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import CoreData

class PersitenceManager: NSObject {
    
    static let sharedInstance = PersitenceManager()
    
    var managedObjectContext: NSManagedObjectContext?
    var managedObjectModel: NSManagedObjectModel?
    
}
