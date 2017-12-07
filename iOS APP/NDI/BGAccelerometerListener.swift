//
//  AccelerometerListener.swift
//  NDI
//
//  Created by Nidhal DOGGA on 12/7/17.
//  Copyright © 2017 Nidhal DOGGA. All rights reserved.
//

import UIKit
import CoreMotion

internal class BGAccelerometerListener: NSObject {

    public var lastSavedAcceleration: CMAcceleration?
    internal var motionManager: CMMotionManager = CMMotionManager()

    internal static var sharedInstance: BGAccelerometerListener = BGAccelerometerListener()
    
    public init(with accelerometerUpdateInterval: TimeInterval = 1.0) {
        super.init()
        motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
    }
    
    public func startListening(with callback: @escaping (CMAccelerometerData?, Error?) -> Void) {
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [unowned self] (data, error) in
            self.lastSavedAcceleration = data?.acceleration
            callback(data, error)
        }
    }
    
    public func stopListening() {
        motionManager.stopAccelerometerUpdates()
    }

}
