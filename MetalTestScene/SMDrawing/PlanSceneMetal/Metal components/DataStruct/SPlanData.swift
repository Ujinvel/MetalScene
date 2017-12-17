/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Structure to store the original data
 */

public typealias OriginalObject = (polygon: [SVector2d], type: Int, id: Int, color: ColorRGB)
public typealias GridFilling    = (cellXPos: Int, cellYPos: Int)

public struct SOriginalObject {
  public init() {}
  
  public var polygon: [SVector2d]          = []
  public var type: Int                     = 0
  public var id: Int                       = 0
  public var color: ColorRGB               = EnSMObjectsColorsRGB.color(cSMObjectsTypes.grid.rawValue)
  public var borderWidth: Float            = 2//
  public var borderColor: ColorRGB         = EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear)
}

public struct SPlanData {
  public init() {}
  
  public var originalWidth: Float  = 0
  public var originalHeight: Float = 0
  public var gridStep: Float       = 0
  
  public var borderSelectedColor: ColorRGB = EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear)// selected color for all objects
  public var borderDefColor: ColorRGB      = EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear)
  
  public var objectTypes: [cSMObjectsTypes] = []
  public var objects: [SOriginalObject]     = []
  public var grid: [GridFilling]            = []
}

