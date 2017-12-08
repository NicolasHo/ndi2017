//
//  BGViewController.swift
//  NDI
//
//  Created by Nidhal DOGGA on 12/7/17.
//  Copyright © 2017 Nidhal DOGGA. All rights reserved.
//

import UIKit
import CoreLocation

let reuseIdentifier = "reuseID"

class BGAlertsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var alerts: [String: [Any]] = ["alerts": []]
    private var addresses: [String?] = []
    
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
                    let long = (alert as! [String: Double])["longitude"]!
                    let lat = (alert as! [String: Double])["latitude"]!
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long),
                                                        completionHandler: { (placemarks, error) in
                        self.addresses.append(placemarks!.first!.name)
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
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {
            return UITableViewCell()
        }
        // Configure cell
        cell.textLabel?.text = addresses[indexPath.row]
        return cell
    }
    
}







