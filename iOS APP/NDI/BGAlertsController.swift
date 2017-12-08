//
//  BGViewController.swift
//  NDI
//
//  Created by Nidhal DOGGA on 12/7/17.
//  Copyright © 2017 Nidhal DOGGA. All rights reserved.
//

import UIKit
import MapKit

let reuseIdentifier = "reuseID"

class BGAlertsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var alerts: [String: [Any]] = ["alerts": []]
    private var userAlerts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let request = URLRequest(url: URL(string: "http://bachaner.fr:8081/alert_list")!)
        let session = URLSession.shared
        session.dataTask(with: request) { [unowned self] data, response, err in
            guard err == nil && data != nil else {
                // TODO: handle errors
                return
            }
            do {
                self.alerts = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : [Any]]
                for alert in self.alerts["alerts"]! {
                    var userAlert = [String: Any]()
                    userAlert["long"] = (alert as! [String: Double])["longitude"]!
                    userAlert["lat"] = (alert as! [String: Double])["latitude"]!
                    userAlert["date"] = Date().timeIntervalSince1970 - (alert as! [String: Double])["date"]! / 1000
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(CLLocation(latitude: (alert as! [String: Double])["latitude"]!,
                                                               longitude: (alert as! [String: Double])["longitude"]!), completionHandler: { (placemarks, error) in
                        userAlert["name"] = placemarks!.first!.name
                        self.userAlerts.append(userAlert)
                        DispatchQueue.main.async {
                            self.tableView.reloadSections([0], with: .automatic)
                        }
                    })
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BGAlertsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // Configure cell
        let userAlert = self.userAlerts.sorted { (first, second) -> Bool in
            return first["date"] as! Double > second["date"] as! Double
        }[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        cell.textLabel?.text = userAlert["name"] as? String
        let seconds = userAlert["date"] as! Double
        if seconds < 60 {
            cell.detailTextLabel?.text = "il y a \(Int(seconds)) secondes"
        } else if seconds < 3600 {
            cell.detailTextLabel?.text = "il y a \(Int(seconds / 60)) minutes"
        } else if seconds < 3600 * 24 {
            cell.detailTextLabel?.text = "il y a \(Int(seconds / 3600)) heures"
        } else {
            cell.detailTextLabel?.text = "il y a \(Int(seconds / (3600 * 24))) jours"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coordinate = CLLocationCoordinate2D(latitude: userAlerts[indexPath.row]["lat"] as! Double, longitude: userAlerts[indexPath.row]["long"] as! Double)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: coordinateSpan)
        performSegue(withIdentifier: "showMapController", sender: region)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapController" {
            let mapController = segue.destination as! BGMapController
            mapController.region = sender as? MKCoordinateRegion
            mapController.annotatedLocations = [(sender as! MKCoordinateRegion).center]
        }
    }
    
}







