//
//  BGMainController.swift
//  NDI
//
//  Created by Nidhal DOGGA on 12/7/17.
//  Copyright © 2017 Nidhal DOGGA. All rights reserved.
//

import UIKit
import CoreLocation

class BGMainController: UIViewController {
    
    @IBOutlet var reportSOSButton: UIButton!
    
    internal var locationManager: CLLocationManager = CLLocationManager()
    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    private var conductMode: Bool = false
    
    @IBAction func showAlertsController(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAlertsController", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        reportSOSButton.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: reportSOSButton.centerYAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: reportSOSButton.trailingAnchor, constant: -16).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleConductionMode(_ sender: UIButton) {
        conductMode = !conductMode
        sender.setTitle(conductMode ? "Déactiver mode conduite" : "Activer mode conduite", for: .normal)
    }
    
    @IBAction func reportSOSSituation(_ sender: Any) {
        locationManager.requestLocation()
        activityIndicator.startAnimating()
    }

}

extension BGMainController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        activityIndicator.stopAnimating()
        guard let location = locations.first else { return }
        // TODO: deal with receirved data
        print(location.coordinate)
        let alertController = UIAlertController(title: "Réussite", message: "Votre situation a été bien signalée", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: ", error)
    }
    
}

