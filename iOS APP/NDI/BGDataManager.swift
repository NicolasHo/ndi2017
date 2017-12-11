
//
//  BGDataManager.swift
//  NDI
//
//  Created by Nidhal DOGGA on 12/11/17.
//  Copyright © 2017 Nidhal DOGGA. All rights reserved.
//

import UIKit
import CoreLocation

private let alertListEndPoint = "http://bachaner.fr:8081/alert_list"
private let alertCreateEndPoint = "http://bachaner.fr:8081/alert_create"

internal class BGDataManager: NSObject {
    
    public static var shared: BGDataManager = BGDataManager()
    
    public struct BGSOSAlert {
        
        public var location: CLLocation
        public var date: Date
        public var placemarkName: String?
        
    }
    
    public func requestAlerts(_ callback: @escaping (Error?, [BGSOSAlert]) -> ()) {
        let request = URLRequest(url: URL(string: alertListEndPoint)!)
        URLSession.shared.dataTask(with: request) { data, response, err in
            guard err == nil && data != nil else {
                callback(err, [])
                return
            }
            do {
                var alerts: [BGSOSAlert] = []
                var index = 0
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : [Any]]
                for jsonAlert in json["alerts"] as! [[String: Any]] {
                    let location = CLLocation(latitude: jsonAlert["latitude"] as! Double,
                                              longitude: jsonAlert["longitude"] as! Double)
                    let date = Date(timeIntervalSince1970: jsonAlert["date"] as! Double / 1000)
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                        alerts.append(BGSOSAlert(location: location, date: date, placemarkName: placemarks?.first?.name))
                        if index == (json["alerts"] as![[String: Any]]).count { // last iteration, call the callback function
                            callback(nil, alerts)
                        }
                    })
                    index += 1
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    public func createAlert(_ location: CLLocation, callback: @escaping (Error?) -> Void) {
        let request = URLRequest(url: URL(string: "\(alertCreateEndPoint)?long=\(location.coordinate.longitude)&lat=\(location.coordinate.latitude)")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            callback(error)
        }.resume()
    }
    
}







