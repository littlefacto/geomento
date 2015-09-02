//
//  SpotsViewController.swift
//  Geomento
//
//  Created by Vincent on 02/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SpotsViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

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
    
    // MARK: - Abstract Methods
    
    func refreshData() {
        
    }
    
    // MARK: - Methods
    
    func fetchPersistedSpotList() {
        let spotListFetchRequest = PersitenceManager.sharedInstance.managedObjectModel?.fetchRequestTemplateForName("GetAllSpots")
        self.spotList = try! (PersitenceManager.sharedInstance.managedObjectContext?.executeFetchRequest(spotListFetchRequest!) as! [Spot])
    }
    
    func addNewSpot() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .FullScreen
        imagePickerController.sourceType = .Camera
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let capturedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = Utils.resizeImage(capturedImage, toSize: CGSizeMake(480, 640))
        let newSpot = NSEntityDescription.insertNewObjectForEntityForName("Spot", inManagedObjectContext: PersitenceManager.sharedInstance.managedObjectContext!) as! Spot
        newSpot.photo = resizedImage
        
        if self.locationManager.location != nil {
            newSpot.latitude = self.locationManager.location!.coordinate.latitude
            newSpot.longitude = self.locationManager.location!.coordinate.longitude
        }
        
        newSpot.creationDate = NSDate()
        newSpot.modificationDate = NSDate()
        
        self.spotList?.insert(newSpot, atIndex: 0)
        self.dismissViewControllerAnimated(true) { () -> Void in
            try! PersitenceManager.sharedInstance.managedObjectContext?.save()
            self.refreshData()
        }
        
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    

}
