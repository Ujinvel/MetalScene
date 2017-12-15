/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

import CoreGraphics

extension Double {
  var degreesToRadians: Double { return self * .pi / (cCompass.fullСircle / 2) }
  var radiansToDegrees: Double { return self * (cCompass.fullСircle / 2) / .pi }
}

// Rounds the double to decimal places value
extension Float {
  func rounded(toPlaces places:Int) -> Float {
    let divisor = pow(10.0, Float(places))
    return (self * divisor).rounded() / divisor
  }
}
