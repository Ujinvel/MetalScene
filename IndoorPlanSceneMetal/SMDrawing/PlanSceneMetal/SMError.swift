/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

enum cErrorDesc {
  static let success             = "Success."
  static let defaultDevice       = "No access to GPU resources. It is necessary to run on a valid device with a 64-bit architecture."
  static let emptyDevice         = "Emty link to device."
  static let shaders             = "No precompiled shaders. It is necessary to create a file *.metal in which to register the correct shaders. Also               make sure that the file with the shaders is present in Build Phases -> Compile Sources for your project target."
  static let renderPipelineColor = "You can not access the MTLRenderPipelineColorAttachmentDescriptorArray element. Perhaps Apple changed the structure."
  static let emtyVertexes        = "No vertexes"
}
//-----------------------------------------------------------------------------------

enum cErrorColorsDesc {
  static let domain = "Object color"
  
  static let code = 1000
  
  static let wall            = "Can't set color to wall."
  static let window          = "Can't set color to window."
  static let door            = "Can't set color to door."
  static let barrier         = "Can't set color to barrier."
  static let stairs          = "Can't set color to stairs."
  static let pavilion        = "Can't set color to pavilion."
  static let informationDesk = "Can't set color to informationDesk."
  static let showRoom        = "Can't set color to showRoom."
  static let conferenceHall  = "Can't set color to conferenceHall."
  static let scene           = "Can't set color to scene."
  static let shop            = "Can't set color to shop."
  static let wc              = "Can't set color to wc."
  static let foodCourt       = "Can't set color to foodCourt."
  static let beacon          = "Can't set color to beacon."
  static let wifiPoint       = "Can't set color to wifiPoint."
  static let room            = "Can't set color to room."
  static let exhibit         = "Can't set color to exhibit."
  static let grid            = "Can't set color to grid."
}
//-----------------------------------------------------------------------------------

public enum cErrorType {
  case success
  case defaultDevice
  case emptyDevice
  case shaders
  case renderPipelineColor
  case emtyVertexes
  
  static func getErrorDescription(_ type: cErrorType) -> String {
    var errorDesc: String!
    
    switch type {
    case .success: errorDesc = cErrorDesc.success
    case .defaultDevice: errorDesc = cErrorDesc.defaultDevice
    case .emptyDevice: errorDesc = cErrorDesc.emptyDevice
    case .shaders: errorDesc = cErrorDesc.shaders
    case .renderPipelineColor: errorDesc = cErrorDesc.renderPipelineColor
    case .emtyVertexes: errorDesc = cErrorDesc.emtyVertexes
    }
    
    return errorDesc
  }
}
//-----------------------------------------------------------------------------------

public struct SError: Error {
  public let type: cErrorType
  public let description: String
}
//-----------------------------------------------------------------------------------

