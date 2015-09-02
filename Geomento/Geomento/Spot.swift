//
//  Spot.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Spot: NSManagedObject, MKAnnotation {

// Insert code here to add functionality to your managed object subclass
    
    // MARK: - MKAnnotation
    
    var coordinate: CLLocationCoordinate2D { get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
    }
    
    var title: String? {
        get {
            return self.comments
        }
    }

}
