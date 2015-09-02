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

class ListViewController: SpotsViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "SpotCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SpotDetailsSegueFromList" {
            let spotDetailsVC = segue.destinationViewController as! DetailSpotViewController
            let selectedSpot = self.spotList![self.tableView .indexPathForSelectedRow!.row]
            
            spotDetailsVC.spot = selectedSpot
        }
    }
    
    // MARK: - Methods
    
    override func refreshData() {
        self.fetchPersistedSpotList()
        self.spotList!.sortInPlace { (firstElement, secondElement) -> Bool in
            return firstElement.creationDate!.compare(secondElement.creationDate!) == .OrderedDescending
        }
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    // MARK: - IBAction
    
    @IBAction func addButton(sender: AnyObject) {
        self.addNewSpot()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spotList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)!
        let spot = self.spotList![indexPath.row]
        
        cell.textLabel?.text = spot.title
        cell.detailTextLabel?.text = spot.subtitle
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.image = spot.photo as? UIImage
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
