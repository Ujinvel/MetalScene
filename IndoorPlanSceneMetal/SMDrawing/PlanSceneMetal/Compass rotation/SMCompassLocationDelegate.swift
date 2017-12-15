/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Class to handle CLLocationManagerDelegate. We need a class because we inherit from NSObject.
 */

import CoreLocation

class SMCompassLocationDelegate: NSObject, CLLocationManagerDelegate {
  var didUpdateLocations: ((CLLocation) -> ())?
  var didUpdateHeading: ((CLLocationDirection) -> ())? 
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else { return }
    
    didUpdateLocations?(currentLocation)
  }
  //-----------------------------------------------------------------------------------
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    didUpdateHeading?(newHeading.magneticHeading)
  }
  //-----------------------------------------------------------------------------------
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    fatalError(error.localizedDescription)
  }
  //-----------------------------------------------------------------------------------
  
  //*** Only works if the compass is not calibrated
  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    guard let heading = manager.heading, heading.headingAccuracy > 0 else { return true }
    
    return false
  }
  //-----------------------------------------------------------------------------------
}
