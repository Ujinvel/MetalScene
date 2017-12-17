/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

import CoreLocation
import CoreGraphics

public extension CLLocation {
  //*** Takes care of both the projection and the bearing computation
  func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
    let lat1 = coordinate.latitude.degreesToRadians
    let lon1 = coordinate.longitude.degreesToRadians
    let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
    let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
    
    let dLon = lon2 - lon1
    
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    
    let radiansBearing = atan2(y, x)
    
    return CGFloat(radiansBearing)
  }
  //-----------------------------------------------------------------------------------
  
  func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
    return CGFloat(Double(bearingToLocationRadian(destinationLocation)).radiansToDegrees)
  }
  //-----------------------------------------------------------------------------------
}


