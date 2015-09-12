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
    
    // MARK: - IBAction
    
    @IBAction func mapClicked(sender: UITapGestureRecognizer) {
        let latitute:CLLocationDegrees =  self.spot!.latitude
        let longitute:CLLocationDegrees =  self.spot!.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        self.spot?.comments = self.textView.text
    }

}
