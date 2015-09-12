//
//  SpotViewController.swift
//  Geomento
//
//  Created by Vincent on 01/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import MapKit

class DetailSpotViewController: UITableViewController, UITextViewDelegate {
    
    var spot:Spot?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.imageView.image = self.spot?.photo as? UIImage
        self.textView.text = self.spot?.comments
        self.mapView.addAnnotation(self.spot!)
        self.mapView.showAnnotations([self.spot!], animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        try! PersitenceManager.sharedInstance.managedObjectContext?.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        self.spot?.comments = self.textView.text
    }

}
