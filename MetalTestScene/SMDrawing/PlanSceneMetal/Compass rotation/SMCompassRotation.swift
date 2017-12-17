/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Processing position relative to magnetic north and azimuth.
 */

import CoreLocation
import UIKit

class SMCompassRotation {
  private let locationDelegate: SMCompassLocationDelegate!// Object to handle CLLocationManagerDelegate
  private var location: CLLocation!
  private var latestLocation: CLLocation?
  private let locationManager: CLLocationManager!
  private var radBaseAngle: CGFloat = 0
  private var prevOrientation: UIInterfaceOrientation = .unknown
  
  var didChangeAngle: ((CGFloat) -> ())?// Each time the course changes
  
// MARK: - Constructor
  
  init() {
    locationManager  = SMCompassRotation.setupLocationManager()
    locationDelegate = SMCompassLocationDelegate()
    location         = CLLocation()
  }
  //-----------------------------------------------------------------------------------
  
  private static func setupLocationManager() -> CLLocationManager {
    let manager = CLLocationManager()
    
    manager.requestWhenInUseAuthorization()
    
    manager.desiredAccuracy = kCLLocationAccuracyBest
    
    return manager
  }
  //-----------------------------------------------------------------------------------

// MARK: - Start
  
  //*** Start compass data processing
  func startUpdatingRotationAngle(gradBaseAngle: Double) {
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
    
    locationManager.delegate = locationDelegate
    
    radBaseAngle = CGFloat(gradBaseAngle.degreesToRadians)
    
    locationDelegate.didUpdateLocations = { [weak self] location in self?.location = location }
    locationDelegate.didUpdateHeading   = { [weak self] newHeading in
      guard let strongSelf = self else { return }
      
      self?.didChangeAngle?(strongSelf.radBaseAngle + strongSelf.computeNewAngle(with: CGFloat(newHeading)))
    }
  }
  //-----------------------------------------------------------------------------------

// MARK: - Compass data processing
  
  private func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
    let originalHeading = Double(getLocationBearing(location)) - Double(newAngle).degreesToRadians
    let heading         = (UIDevice.current.orientation == .faceDown) ? -(Double)(originalHeading) : Double(originalHeading)

    return CGFloat(orientationAdjustment().degreesToRadians + heading)
  }
  //-----------------------------------------------------------------------------------
  
  private func getLocationBearing(_ destinationLocation: CLLocation) -> CGFloat {
    return latestLocation?.bearingToLocationRadian(location) ?? 0
  }
  //-----------------------------------------------------------------------------------
  
  private func orientationAdjustment() -> Double {
    let isFaceDown: Bool              = (UIDevice.current.orientation == .faceDown) ? true : false
    var orientationAdjustment: Double = 0
    let currOrientation               = UIApplication.shared.statusBarOrientation

    switch currOrientation {
      case .landscapeLeft: orientationAdjustment = (cCompass.fullСircle / 4)// 90 degrees
      case .landscapeRight: orientationAdjustment = -(cCompass.fullСircle / 4)
      case .portrait, .unknown: orientationAdjustment = 0
      case .portraitUpsideDown: orientationAdjustment = isFaceDown ? (cCompass.fullСircle / 2) : -(cCompass.fullСircle / 2)
    }
    
    if UIDevice.current.orientation == .portraitUpsideDown {
      orientationAdjustment = isFaceDown ? (cCompass.fullСircle / 2) : -(cCompass.fullСircle / 2)
    }
    
    var adjust = orientationAdjustment
    
    if prevOrientation != currOrientation && prevOrientation != .unknown {
      if prevOrientation == .landscapeRight && currOrientation == .landscapeLeft { adjust = cCompass.fullСircle / 2 }//180
        else if prevOrientation == .landscapeLeft && currOrientation == .landscapeRight { adjust = cCompass.fullСircle }//360
      
      if prevOrientation == .landscapeRight && currOrientation == .portrait { adjust = cCompass.fullСircle }
        else if prevOrientation == .portrait && currOrientation == .landscapeRight { adjust = cCompass.fullСircle * 3 / 4 }// 270
      
      if prevOrientation == .landscapeLeft && currOrientation == .portrait { adjust = cCompass.fullСircle  }
        else if prevOrientation == .portrait && currOrientation == .landscapeLeft { adjust = cCompass.fullСircle / 4 }
    }
    
    prevOrientation = UIApplication.shared.statusBarOrientation
    
    return adjust
  }
  //-----------------------------------------------------------------------------------
}
