//
//  SpotsViewController.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SpotsViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    var spotList:[Spot]?
    var locationManager = CLLocationManager()
    
    let cellIdentifier = "SpotCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    
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
        
        self.refreshData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SpotDetailsSegue" {
            let spotDetailsVC = segue.destinationViewController as! EditSpotViewController
            let selectedSpot = self.spotList![self.tableView .indexPathForSelectedRow!.row]
            
            spotDetailsVC.spot = selectedSpot
        }
    }
    
    // MARK: - Private Methods
    
    func fetchPersistedSpotList() {
        let spotListFetchRequest = PersitenceManager.sharedInstance.managedObjectModel?.fetchRequestTemplateForName("GetAllSpots")
        self.spotList = try! (PersitenceManager.sharedInstance.managedObjectContext?.executeFetchRequest(spotListFetchRequest!) as! [Spot])
    }
    
    func refreshData() {
        self.fetchPersistedSpotList()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    // MARK: - IBAction
    
    @IBAction func addButton(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .CurrentContext
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
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spotList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)! as! SpotTableViewCell
        let spot = self.spotList![indexPath.row]
        
        cell.photoView.image = spot.photo as? UIImage
        cell.label.text = spot.comments
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deletedSpot = self.spotList!.removeAtIndex(indexPath.row)
            PersitenceManager.sharedInstance.managedObjectContext?.deleteObject(deletedSpot)
            try! PersitenceManager.sharedInstance.managedObjectContext?.save()
            self.refreshData()
        }
    }
}
