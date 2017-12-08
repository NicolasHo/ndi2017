//
//  BGMapController.swift
//  NDI
//
//  Created by Nidhal DOGGA on 12/8/17.
//  Copyright © 2017 Nidhal DOGGA. All rights reserved.
//

import UIKit
import MapKit

class BGMapController: UIViewController {
    
    
    @IBOutlet var mapView: MKMapView!
    
    public var region: MKCoordinateRegion?
    public var annotatedLocations: [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let region = self.region {
            mapView.setRegion(region, animated: false)
        }
        for locationCoordinate in annotatedLocations {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = locationCoordinate
            pointAnnotation.title = "Alerte d'urgence"
            mapView.addAnnotation(pointAnnotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
