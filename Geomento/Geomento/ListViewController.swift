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

class ListViewController: SpotsViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "SpotCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SpotDetailsSegueFromList" {
            let spotDetailsVC = segue.destinationViewController as! EditSpotViewController
            let selectedSpot = self.spotList![self.tableView .indexPathForSelectedRow!.row]
            
            spotDetailsVC.spot = selectedSpot
        }
    }
    
    // MARK: - Methods
    
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
