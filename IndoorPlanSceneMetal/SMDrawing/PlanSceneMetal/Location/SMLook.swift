/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Сlass for display the angle of view.
 */

import UIKit

class SMLook: UIView {
  private var fillColor =  UIColor.blue.withAlphaComponent(cMarkers.defAlpha)
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    drawSlice(color: fillColor, rect: rect)
  }
  //-----------------------------------------------------------------------------------
  
  func drawSlice(startGradAngle: Double = cMarkers.angleOfViewStart,
                 endGradAngle: Double = cMarkers.angleOfViewEnd,
                 color: UIColor = UIColor.blue.withAlphaComponent(cMarkers.defAlpha),
                 rect: CGRect?) {
    fillColor      = color
    let rect_      = (rect == nil) ? frame : rect!
    let center     = CGPoint(x: rect_.origin.x + rect_.width / 2, y: rect_.origin.y)
    let radius     = max(rect_.width, rect_.height) / 2
    let startAngle = CGFloat(startGradAngle.degreesToRadians)
    let endAngle   = CGFloat(endGradAngle.degreesToRadians)
    let path       = UIBezierPath()
    
    path.move(to: center)
    path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    path.close()
    fillColor.setFill()
    path.fill()
  }
  //-----------------------------------------------------------------------------------
}

