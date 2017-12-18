/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */
import UIKit

extension SMDrawingLayer {
// MARK: - Theme
  
  func setThemeForObject(type: cSMObjectsTypes,
                         color: UIColor,
                         borderWidth: CGFloat,
                         borderColor: UIColor,
                         borderSelectedColor: UIColor) -> Bool {
    guard !isDataProcessing() else { return false }
    
    let objectColor         = getRGBfromColor(color)
    let borderColor         = getRGBfromColor(borderColor)
    let borderSelectedColor = getRGBfromColor(borderSelectedColor)
    
    return polygonsToDraw.setThemeForObject(type: type,
                                            color: objectColor,
                                            borderColor: borderColor,
                                            borderSelectedColor: borderSelectedColor,
                                            borderWidth: borderWidth)
  }
  //-----------------------------------------------------------------------------------
  
// MARK: Markers
  
  func updateColors() {
    
    polygonsToDraw.refreshBuffers()
  }
  //-----------------------------------------------------------------------------------
  
  public func setLookMarkerTheme(color: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
    //userLocation.setLookViewColor(color: color, borderColor: borderColor, borderWidth: borderWidth)
    let lookColor = getRGBfromColor(color)
    
    polygonsToDraw.setColorForLookMarker(lookColor)
  }
  //-----------------------------------------------------------------------------------
  
  public func setLocationMarkerTheme(mainColor: UIColor, outerColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
    //userLocation.setLocationViewColor(mainColor: mainColor, outerColor: outerColor, borderColor: borderColor, borderWidth: borderWidth)
    let innerColor = getRGBfromColor(mainColor)
    let outerColor = getRGBfromColor(outerColor)
    
    polygonsToDraw.setColorForLocationMarker(innerColor: innerColor, outerColor: outerColor)

  }
  //-----------------------------------------------------------------------------------
  
  // MARK: Grid
  
  public func setGridColor(_ color: UIColor) {
    let gridColor = getRGBfromColor(color)
    
    polygonsToDraw.setGridColor(gridColor)
  }
  //-----------------------------------------------------------------------------------
  
  public func setForbiddenCellsColor(_ color: UIColor) {
    let cellColor = getRGBfromColor(color)
    
    polygonsToDraw.setForbiddenCellsColor(cellColor)
  }
  //-----------------------------------------------------------------------------------
  
  public func setColorForBackground(_ color: UIColor) {
    let background = getRGBfromColor(color)
    
    polygonsToDraw.setColorForBackground(background)
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Show contour
  
  public func showContour(iDs: [Int]) {
    polygonsToDraw.showContoures(iDs: iDs)
  }
  //-----------------------------------------------------------------------------------
  
  private func getRGBfromColor(_ color: UIColor) -> ColorRGB {
    guard let colorComponents = color.cgColor.components, colorComponents.count == 4 else { return EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear) }
    
    let red   = colorComponents[0]
    let green = colorComponents[1]
    let blue  = colorComponents[2]
    let alpha = colorComponents[3]
    
    return (red: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha))
  }
  //-----------------------------------------------------------------------------------
}
