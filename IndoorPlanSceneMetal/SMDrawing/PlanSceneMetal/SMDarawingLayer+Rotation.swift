/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

extension SMDrawingLayer {
  public func startCompassRotation(gradBaseAngle: Double) {
    compass.startUpdatingRotationAngle(gradBaseAngle: gradBaseAngle)// Start processing compass data
    
    compass.didChangeAngle = { [weak self] radAngle in// Heading did change
      self?.rotateToRadAngle(radAngle)
    }
  }
  //-----------------------------------------------------------------------------------
}
