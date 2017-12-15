/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Structure to store the polygon point position
 */

import Foundation

public struct SVector2d {
  private var _x: Float = 0
  private var _y: Float = 0
  
  public init(x: Float, y: Float) {
    vector2d = (x, y)
  }
  //-----------------------------------------------------------------------------------
  
  public init() {
    self.init(x: 0, y: 0)
  }
  //-----------------------------------------------------------------------------------
  
  public var vector2d: (x: Float, y: Float) {
    set(newVector) {
      _x = newVector.x
      _y = newVector.y
    }
    
    get {
      return (_x, _y)
    }
  }
  //-----------------------------------------------------------------------------------
  
  public var intVector: (x: Int32, y: Int32) {
    get { return (Int32(roundf(_x)), Int32(roundf(_y))) }
  }
  //-----------------------------------------------------------------------------------
}

