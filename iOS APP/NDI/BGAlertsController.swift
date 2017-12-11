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
    private var alerts: [BGDataManager.BGSOSAlert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        BGDataManager.shared.requestAlerts { [unowned self] (error, alerts) in
            guard error == nil else { return }
            self.alerts = alerts
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
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
        return self.alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // Configure cell
        let userAlert = self.alerts.sorted { (first, second) -> Bool in
            return first.date > second.date
        }[indexPath.row]
        cell.textLabel?.text = userAlert.placemarkName
        let seconds = Date().timeIntervalSince1970 - userAlert.date.timeIntervalSince1970
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
        
        let coordinate = alerts[indexPath.row].location.coordinate
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







