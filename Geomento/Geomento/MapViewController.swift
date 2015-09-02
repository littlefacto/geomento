//
//  MapViewController.swift
//  Geomento
//
//  Created by Vincent on 02/09/2015.
//  Copyright © 2015 Little Facto. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: SpotsViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let annotationViewIdentifier = "SpotAnnotationView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.addAnnotations(self.spotList!)
        self.mapView.showAnnotations(self.spotList!, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SpotDetailsSegueFromMap" {
            let detailSpotVC = segue.destinationViewController as! DetailSpotViewController
            let spot = self.mapView.selectedAnnotations.first as! Spot
            
            detailSpotVC.spot = spot
        }
    }
    
    // MARK: - Methods
    
    override func refreshData() {
        let displayedAnnotations = Set(self.mapView.annotations as! [Spot])
        let allAnnotations = Set(self.spotList!)
        
        let notDisplayedAnnotations = allAnnotations.subtract(displayedAnnotations)
        
        self.mapView.addAnnotations(Array(notDisplayedAnnotations))
        self.mapView.showAnnotations(Array(notDisplayedAnnotations), animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func addButton(sender: AnyObject) {
        self.addNewSpot()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for annotationView in views {
            let spot = annotationView.annotation as! Spot
            let imageView = UIImageView(image: spot.photo as? UIImage)
            imageView.frame = CGRectMake(0, 0, 40, 40)
            imageView.contentMode = .ScaleAspectFit
            
            annotationView.leftCalloutAccessoryView = imageView
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control.isKindOfClass(UIButton.self) {
            self.performSegueWithIdentifier("SpotDetailsSegueFromMap", sender: view)
        }
    }

}
