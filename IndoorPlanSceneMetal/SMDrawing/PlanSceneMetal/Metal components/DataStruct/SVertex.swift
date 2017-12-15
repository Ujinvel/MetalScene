/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Structure to store the position and color of each vertex
 */

import QuartzCore

class SMOffset {
  var scale: Float = 0
  var x: Float     = 0
  var y: Float     = 0
  
  static let sharedInstance = SMOffset()
}

typealias VertexOffset = (scale: Float, x: Float, y: Float, originalSize: CGSize)

struct SVertex{
  var x, y, z: Float// position data
  var tx, ty: Float// text
  var text: Float// if 1 - text vertex
  var r,g,b,a: Float// color data
  var isUserLoc: Float
  
  init(coordinates: SVector2d, offset: VertexOffset, color: ColorRGB, textPos: (x: Float, y: Float, isText: Float) = (0, 0, 0), isUserLocation: Float = 0) {
    x = (offset.x + coordinates.vector2d.x * offset.scale) // x = x * 3 + Float(originalSize.width / 2) * (1 - 3)// увеличиваем в 3 - раза от центра
    y = (offset.y + (Float(offset.originalSize.height) - coordinates.vector2d.y) * offset.scale) // y = y * 3 + Float(originalSize.height / 2) * (1 - 3)
    z = 0
    
    tx   = textPos.x
    ty   = textPos.y
    text = textPos.isText
    
    r = color.red
    g = color.green
    b = color.blue
    a = color.alpha
    
    isUserLoc = isUserLocation
  }
  //-----------------------------------------------------------------------------------
  
  init(coordinates: SVector2d, drawLayerFrame: CGRect, originalSize: CGSize, color: ColorRGB) {
    let offset = SVertex.getOffset(drawLayerFrame: drawLayerFrame, originalSize: originalSize)
    
    self.init(coordinates: coordinates, offset: offset, color: color)
  }
  //-----------------------------------------------------------------------------------
  
  init(coordinates: SVector2d, color: ColorRGB, textPos: (x: Float, y: Float, isText: Float) = (0, 0, 0), isUserLocation: Float = 0) {
    x = coordinates.vector2d.x
    y = coordinates.vector2d.y
    z = 0
    
    tx   = textPos.x
    ty   = textPos.y
    text = textPos.isText
    
    r = color.red
    g = color.green
    b = color.blue
    a = color.alpha
    
    isUserLoc = isUserLocation
  }
  //-----------------------------------------------------------------------------------
  
  init() {
    self.init(coordinates: SVector2d(x: 0, y: 0),
              drawLayerFrame: CGRect(x: 0, y: 0, width: 0, height: 0),
              originalSize: CGSize(width: 0, height: 0),
              color: (red: 0, green: 0, blue: 0, alpha: 0))
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColor(_ color: ColorRGB) {
    r = color.red
    g = color.green
    b = color.blue
    a = color.alpha
  }
  //-----------------------------------------------------------------------------------
  
  func floatBuffer() -> [Float] {
    return [x, y, z, tx, ty, text, r, g, b, a, isUserLoc]
  }
  //-----------------------------------------------------------------------------------
  
  //*** We get a multiplier to write the plan into the allocated space. Also center the scene
  static func getOffset(drawLayerFrame: CGRect, originalSize: CGSize) -> VertexOffset {
    var offset: VertexOffset = (SMOffset.sharedInstance.scale,
                                SMOffset.sharedInstance.x,
                                SMOffset.sharedInstance.y, originalSize)
    
    if SMOffset.sharedInstance.scale == 0 {
      var scaleFactor: Float = 1
    
      let widthFactor  = Float(drawLayerFrame.width / originalSize.width)
      let heightFactor = Float(drawLayerFrame.height / originalSize.height)
    
      scaleFactor = widthFactor < heightFactor ? widthFactor : heightFactor
    
      let newWidth  = scaleFactor * Float(originalSize.width)
      let newheight = scaleFactor * Float(originalSize.height)
    
      offset = (scaleFactor.rounded(toPlaces: 1),
                ((Float(drawLayerFrame.width) - newWidth) / 2).rounded(toPlaces: 2) /*+ Float(drawLayerFrame.origin.x)*/,
                ((Float(drawLayerFrame.height) - newheight) / 2).rounded(toPlaces: 2) /*+ Float( drawLayerFrame.origin.y)*/, originalSize)

      SMOffset.sharedInstance.scale = offset.scale
      SMOffset.sharedInstance.x     = offset.x
      SMOffset.sharedInstance.y     = offset.y
    }
    
    return offset
  }
  //-----------------------------------------------------------------------------------
}

