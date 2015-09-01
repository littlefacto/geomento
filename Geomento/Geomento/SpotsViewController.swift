//
//  SpotsViewController.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import CoreData

class SpotsViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource {

    var spotList:[Spot]?
    
    let cellIdentifier = "SpotCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchPersistedSpotList()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)!
        
        cell.textLabel?.text = self.spotList![indexPath.row].comments
        
        return cell
    }
}
