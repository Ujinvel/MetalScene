/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

import UIKit

extension SMTriangle {
  func setThemeForObject(type: cSMObjectsTypes,
                         color: ColorRGB,
                         borderColor: ColorRGB,
                         borderSelectedColor: ColorRGB,
                         borderWidth: CGFloat) -> Bool {
    guard !vertexesData.isDataEmpty() else { return false }
    
    originalData.borderSelectedColor = borderSelectedColor
    originalData.borderDefColor      = borderColor
    
    vertexesData.setColorForObjectType(type.rawValue, objectColor: color, contourColor: borderColor)
    
    if type == .exhibit { prepareContures(width: Int(borderWidth)) }
    
    return true
  }
  //-----------------------------------------------------------------------------------
  
  func setGridColor(_ color: ColorRGB) {
    vertexesData.setColorForGridLines(color: color)
  }
  //-----------------------------------------------------------------------------------
  
  func setForbiddenCellsColor(_ color: ColorRGB) {
    vertexesData.setColorForForbiddenCells(color: color)
  }
  //-----------------------------------------------------------------------------------
  
  func setColorForBackground(_ color: ColorRGB) {
    vertexesData.setColorForBackground(color: color)
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - User markers
  
  func setColorForLookMarker(_ color: ColorRGB) {
    vertexesData.setColorForLookMarker(color: color)
  }
  //-----------------------------------------------------------------------------------
  
  func setColorForLocationMarker(innerColor: ColorRGB, outerColor: ColorRGB) {
    vertexesData.setColorForLocationInnerMarker(innerColor)
    vertexesData.setColorForLocationOuterMarker(outerColor)
  }
  //-----------------------------------------------------------------------------------
}
