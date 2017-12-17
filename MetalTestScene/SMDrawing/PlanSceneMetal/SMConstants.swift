/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Constants
 */

// MARK: - Objects types

import UIKit

public enum cSMObjectsTypes: Int {
  case wall            = 1
  case window          = 2
  case door            = 3
  case barrier         = 4
  case stairs          = 5
  case pavilion        = 1001
  case informationDesk = 1002
  case showRoom        = 1003
  case conferenceHall  = 1004
  case scene           = 1005
  case shop            = 1006
  case wc              = 1007
  case foodCourt       = 1008
  case beacon          = 1009
  case wifiPoint       = 1010
  case room            = 1011
  case exhibit         = 1012
  case grid            = 2000
}
//-----------------------------------------------------------------------------------

// MARK: - Objects colors

enum cSMObjectsColors {
  static let darkturquoise: Int = 0x009AC9
  static let darkolive: Int     = 0x9BCC00
  static let brown: Int         = 0x996533
  static let darkpurple: Int    = 0x663398
  static let salmon: Int        = 0xFB7F74
  static let darkblue: Int      = 0x1B1772
  static let darkcyan: Int      = 0x00D0D0
  static let darkred: Int       = 0x800000
  static let darkgreen: Int     = 0x339933
  static let lightblue: Int     = 0x6395ec
  static let peach: Int         = 0xFFC04E
  static let purpleblue: Int    = 0x640CC8
  static let darkgray: Int      = 0x555555
  static let yellow: Int        = 0xFFFF00
  static let lightgray: Int     = 0xAAAAAA
  static let red: Int           = 0xFF0000
  static let clear: Int         = 0x000000
  static let orange: Int        = 0xFF974A// for unknown types
  static let green: Int         = 0x00FF00  
}
//-----------------------------------------------------------------------------------

public typealias ColorRGB = (red: Float, green: Float, blue: Float, alpha: Float)

public enum EnSMObjectsColorsRGB {
  public static func color(_ type: Int) -> ColorRGB {
    guard let currType = cSMObjectsTypes(rawValue: type) else { return hexToRGB(cSMObjectsColors.orange) }// if the type is unknown we return the orange color
    
    var hexColor: Int!
    
    switch currType {
    case .wall:
      hexColor = cSMObjectsColors.darkgray
    case .window:
      hexColor = cSMObjectsColors.darkturquoise
    case .door:
      hexColor = cSMObjectsColors.darkgreen
    case .barrier:
      hexColor = cSMObjectsColors.brown
    case .stairs:
      hexColor = cSMObjectsColors.lightgray
    case .pavilion:
      hexColor = cSMObjectsColors.lightblue
    case .informationDesk:
      hexColor = cSMObjectsColors.darkpurple
    case .showRoom:
      hexColor = cSMObjectsColors.red
    case .conferenceHall:
      hexColor = cSMObjectsColors.salmon
    case .scene:
      hexColor = cSMObjectsColors.darkred
    case .shop:
      hexColor = cSMObjectsColors.lightblue
    case .wc:
      hexColor = cSMObjectsColors.darkblue
    case .foodCourt:
      hexColor = cSMObjectsColors.yellow
    case .beacon:
      hexColor = cSMObjectsColors.darkolive
    case .wifiPoint:
      hexColor = cSMObjectsColors.darkcyan
    case .room:
      hexColor = cSMObjectsColors.peach
    case .exhibit:
      hexColor = cSMObjectsColors.darkpurple
    case .grid:
      hexColor = cSMObjectsColors.darkpurple
    }
    
    return hexToRGB(hexColor)
  }
  
  static func hexToRGB(_ hexColor: Int, alpha: Float = 1) -> ColorRGB {
    let alpha_ = (hexColor == cSMObjectsColors.peach ? 0 : alpha)
    
    return (red: Float((hexColor >> 16) & 0xFF) / 255.0,
            green: Float((hexColor >> 8) & 0xFF) / 255.0,
            blue: Float(hexColor & 0xFF) / 255.0,
            alpha: alpha_)
  }
}
//-----------------------------------------------------------------------------------

// MARK: - Shaders

enum cShaders {
  static let vertex   = "basicVertex"// The name of the function that is responsible for rendering the vertex shader
  static let fragment = "basicFragment"// The name of the function that is responsible for rendering the fragment shader(pixel)
}
//-----------------------------------------------------------------------------------

// MARK: - Compass

enum cCompass {
  static let fullСircle: Double = 360
}
//-----------------------------------------------------------------------------------

// MARK: - Markers

enum cMarkers {
  static let containerWidth: CGFloat          = 600
  static let containerHeight: CGFloat         = 600
  static let realPosRadius: CGFloat           = 25
  static let locationContainerRadius: CGFloat = 100
  static let locationRadius: CGFloat          = 15
  static let angleOfViewStart: Double         = 15// View angle display - start angle
  static let angleOfViewEnd: Double           = 165
  static let defAlpha: CGFloat                = 0.3
}
//-----------------------------------------------------------------------------------

// MARK: - Zoom and rotation

enum cZoomAndRotation {
  static let minimumZoomScale: CGFloat     = 1
  static let maximumZoomScale: CGFloat     = 3
  static let defZoomScale: CGFloat         = 1
  static let rotationAnimDur: TimeInterval = 0.5
}
//-----------------------------------------------------------------------------------

// MARK: - Mathematical constants for various calculations

enum cMaths {
  static let circleDeg: Float   = 360
  static let minNumPolyVer: Int = 3// Minimum number of polygon vertices
  static let quadPolyVer: Int   = 4// Number of vertices in a quadrilateral
}
//-----------------------------------------------------------------------------------

// MARK: - Text

enum cText {
  static let defFontName = "HoeflerText-Regular"
  static let defFontSize: CGFloat = 20
  static let textWidth: CGFloat   = 44
  static let texHeight:  CGFloat  = 25
}
//-----------------------------------------------------------------------------------

