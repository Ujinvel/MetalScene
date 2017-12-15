/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Сlass for displaying user position markers.
 */

import UIKit

class SMUserLocation {
  private let mainContainerView: UIView!
  private let realPosView: UIView!
  private let lookView: SMLook!
  private let locationContainerView: UIView!
  private let locationView: UIView!
  private weak var drawableView: UIView?
  
  private var offset: VertexOffset = VertexOffset(scale: 1, x: 0, y: 0, originalSize: CGSize(width: 0, height: 0))
  
  // MARK: - Constructor
  
  init(drawableView: UIView,
       width: CGFloat,
       height: CGFloat,
       realPosRadius: CGFloat,
       locationContainerRadius: CGFloat,
       locationRadius: CGFloat,
       startPoint: CGPoint?) {
    defer {
      if startPoint != nil { setCenter(center: startPoint!) }
        else { mainContainerView.center = CGPoint(x: drawableView.frame.width / 2, y: (drawableView.frame.height + height) / 2) }
    }
    
    self.drawableView     = drawableView
    mainContainerView     = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    realPosView           = UIView(frame: CGRect(x: mainContainerView.frame.width / 2 - realPosRadius,
                                                 y: -realPosRadius,
                                                 width: realPosRadius * 2, height: realPosRadius * 2))
    lookView              = SMLook(frame: CGRect(x: 0, y: 0, width: mainContainerView.frame.width, height: mainContainerView.frame.height))
    locationContainerView = UIView(frame: CGRect(x: mainContainerView.frame.width / 2 - locationContainerRadius,
                                                 y: -locationContainerRadius,
                                                 width: locationContainerRadius * 2, height: locationContainerRadius * 2))
    locationView          = UIView(frame: CGRect(x: locationContainerView.frame.width / 2 - locationRadius,
                                                 y: locationContainerView.frame.height / 2 - locationRadius,
                                                 width: locationRadius * 2, height: locationRadius * 2))
    
    setupViewHierarchy(drawableView: drawableView)
    setupColors()
    makeRounds()
    
    mainContainerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double(cMaths.circleDeg / 2).degreesToRadians))
  }
  //-----------------------------------------------------------------------------------
  
  func updateOffset(_ offset: VertexOffset) {
    self.offset = offset
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Initial setup
  
  private func setupViewHierarchy(drawableView: UIView) {
    drawableView.addSubview(mainContainerView)
    mainContainerView.addSubview(lookView)
    mainContainerView.addSubview(realPosView)
    mainContainerView.addSubview(locationContainerView)
    locationContainerView.addSubview(locationView)
    
    mainContainerView.isHidden        = false
    realPosView.isHidden              = true
    lookView.isHidden                 = true
    locationView.isHidden             = true
    locationContainerView.isHidden    = true
    mainContainerView.backgroundColor = .black
  }
  //-----------------------------------------------------------------------------------
  
  private func makeRounds() {
    realPosView.layer.cornerRadius           = realPosView.bounds.height / 2
    locationContainerView.layer.cornerRadius = locationContainerView.bounds.height / 2
    locationView.layer.cornerRadius          = locationView.bounds.height / 2
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Setup
  
  private func setupColors(realPosViewColor: UIColor = .green,
                           lookViewColor: UIColor = UIColor.blue.withAlphaComponent(cMarkers.defAlpha),
                           locationContainerViewColor: UIColor = UIColor.purple.withAlphaComponent(cMarkers.defAlpha),
                           locationViewColor: UIColor = .purple) {
    mainContainerView.backgroundColor     = .clear
    realPosView.backgroundColor           = realPosViewColor
    lookView.backgroundColor              = .clear
    locationContainerView.backgroundColor = locationContainerViewColor
    locationView.backgroundColor          = locationViewColor
    
    lookView.drawSlice(color: lookViewColor, rect: nil)
  }
  //-----------------------------------------------------------------------------------
  
  func setLookViewColor(color: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
    lookView.drawSlice(color: color, rect: lookView.frame)

    lookView.layer.borderColor = borderColor.cgColor
    lookView.layer.borderWidth = borderWidth
  }
  //-----------------------------------------------------------------------------------
  
  func setLocationViewColor(mainColor: UIColor, outerColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
    locationView.backgroundColor          = mainColor
    locationContainerView.backgroundColor = outerColor
    
    mainContainerView.layer.borderColor = borderColor.cgColor
    mainContainerView.layer.borderWidth = borderWidth
  }
  //-----------------------------------------------------------------------------------
  
  func hideAll(_ hide: Bool) {
    mainContainerView.isHidden = hide
  }
  //-----------------------------------------------------------------------------------
  
  func showLookMarker(_ show: Bool) {
    lookView.isHidden = show
  }
  //-----------------------------------------------------------------------------------
  
  func showLocationMarker(_ show: Bool) {
    locationContainerView.isHidden = show
    locationView.isHidden          = show
  }
  //-----------------------------------------------------------------------------------
  
  func showRealPositionMarker(_ show: Bool) {
    realPosView.isHidden = show
  }
  //-----------------------------------------------------------------------------------
  
  func setCenter(center: CGPoint, animationDuration: TimeInterval = 0) {
    let scaledPoint = CGPoint(x: center.x * CGFloat(offset.scale) + CGFloat(offset.x), y: center.y * CGFloat(offset.scale) +  CGFloat(offset.y))
    
    mainContainerView.isHidden = false
    
    UIView.animate(withDuration: animationDuration) {
      self.mainContainerView.center = CGPoint(x: scaledPoint.x, y: scaledPoint.y - self.mainContainerView.frame.height / 2)
      
      self.drawableView?.layoutIfNeeded()
    }
  }
  //-----------------------------------------------------------------------------------
}

