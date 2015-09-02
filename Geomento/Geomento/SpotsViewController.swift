//
//  SpotsViewController.swift
//  Geomento
//
//  Created by Vincent on 02/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import CoreLocation

class SpotsViewController: BaseViewController, CLLocationManagerDelegate {

    var spotList:[Spot]?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchPersistedSpotList()
        self.locationManager.desiredAccuracy = 1
        self.locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchPersistedSpotList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    func fetchPersistedSpotList() {
        let spotListFetchRequest = PersitenceManager.sharedInstance.managedObjectModel?.fetchRequestTemplateForName("GetAllSpots")
        self.spotList = try! (PersitenceManager.sharedInstance.managedObjectContext?.executeFetchRequest(spotListFetchRequest!) as! [Spot])
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }

}
