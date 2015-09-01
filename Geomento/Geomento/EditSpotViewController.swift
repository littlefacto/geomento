//
//  SpotViewController.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import MapKit

class EditSpotViewController: BaseViewController, UITextViewDelegate {
    
    var spot:Spot?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        self.spot?.comments = self.textView.text
    }

    // MARK: - IBAction

    @IBAction func cancelButton(sender: AnyObject) {
        
        PersitenceManager.sharedInstance.managedObjectContext?.rollback()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        try! PersitenceManager.sharedInstance.managedObjectContext?.save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
