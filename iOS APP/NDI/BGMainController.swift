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
    
    private var conductModeActivated: Bool = false
    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    private var alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
    
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
        if conductModeActivated {
            
            sender.setTitle("Activer mode conduite", for: .normal)
            BGAccelerometerListener.sharedInstance.stopListening()
        } else {
            sender.setTitle("Déactiver mode conduite", for: .normal)
            BGAccelerometerListener.sharedInstance.startListening(with: { [unowned self] (previousAcceleration, data, error) in
                guard let data = data, let previousAcceleration = previousAcceleration, error == nil else {
                    return
                }
                if abs(previousAcceleration.x - data.acceleration.x) > 0.2 ||
                   abs(previousAcceleration.y - data.acceleration.y) > 0.2 ||
                   abs(previousAcceleration.z - data.acceleration.z) > 0.2 {
                    self.alertController.dismiss(animated: false, completion: nil)
                    self.alertController = UIAlertController(title: "Ça va?", message: "Un mouvement anormal a été détecté, dites nous si tous est dans l'ordre.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "oui", style: .default) { (action) in
                        self.alertController.dismiss(animated: true, completion: nil)
                    }
                    let dangerAction = UIAlertAction(title: "Pas du tout", style: .destructive) { (action) in
                        self.locationManager.requestLocation()
                    }
                    self.alertController.addAction(okAction)
                    self.alertController.addAction(dangerAction)
                    self.present(self.alertController, animated: true, completion: nil)
                }
            })
        }
        conductModeActivated = !conductModeActivated
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
        let request = URLRequest(url: URL(string: "http://bachaner.fr:8081/alert_create?long=\(location.coordinate.longitude)&lat=\(location.coordinate.latitude)")!)
        let session = URLSession.shared
        session.dataTask(with: request) { [unowned self] data, response, err in
                guard err == nil else {
                    self.alertController.dismiss(animated: false, completion: nil)
                    self.alertController = UIAlertController(title: "Échec", message: "Votre signalisation n'a pas abouti.", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "ok", style: .default) { (action) in
                        self.alertController.dismiss(animated: true, completion: nil)
                    }
                    self.alertController.addAction(doneAction)
                    self.present(self.alertController, animated: true, completion: nil)
                    return
                }
            }.resume()
        self.alertController.dismiss(animated: false, completion: nil)
        self.alertController = UIAlertController(title: "Réussite", message: "Votre signalisation a été bien envoyée.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.alertController.dismiss(animated: true, completion: nil)
        }
        self.alertController.addAction(doneAction)
        present(self.alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: ", error)
    }
    
}

