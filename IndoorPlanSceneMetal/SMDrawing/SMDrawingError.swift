///*
// * Created by Ujin Velichko.
// * Copyright (c) UranCompany. All rights reserved.
// */
//
////import IndoorModel
//
//public enum SMDrawingError: IErrorTypeWithNSError {
//  case wall
//  case window
//  case door
//  case barrier
//  case stairs
//  case pavilion
//  case informationDesk
//  case showRoom
//  case conferenceHall
//  case scene
//  case shop
//  case wc
//  case foodCourt
//  case beacon
//  case wifiPoint
//  case room
//  case exhibit
//  case grid
//  
//  public func getAsNSError() -> NSError {
//    switch self {
//      case .wall:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.wall])
//      case .window:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.window])
//      case .door:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.door])
//      case .barrier:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.barrier])
//      case .stairs:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.stairs])
//      case .pavilion:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.pavilion])
//      case .informationDesk:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.informationDesk])
//      case .showRoom:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.showRoom])
//      case .conferenceHall:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.conferenceHall])
//      case .scene:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.scene])
//      case .shop:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.shop])
//      case .wc:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.wc])
//      case .foodCourt:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.foodCourt])
//      case .beacon:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.beacon])
//      case .wifiPoint:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.wifiPoint])
//      case .room:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.room])
//      case .exhibit:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.exhibit])
//      case .grid:
//        return NSError(domain: cErrorColorsDesc.domain, code: cErrorColorsDesc.code, userInfo: [NSLocalizedDescriptionKey: cErrorColorsDesc.grid])
//    }
//  }
//  //-----------------------------------------------------------------------------------
//  
//  static func getErrorForType(_ type: cSMObjectsTypes) -> SMDrawingError {
//    switch type {
//      case .wall: return SMDrawingError.wall
//      case .window: return SMDrawingError.window
//      case .door: return SMDrawingError.door
//      case .barrier: return SMDrawingError.barrier
//      case .stairs: return SMDrawingError.stairs
//      case .pavilion: return SMDrawingError.pavilion
//      case .informationDesk: return SMDrawingError.pavilion
//      case .showRoom: return SMDrawingError.showRoom
//      case .conferenceHall: return SMDrawingError.conferenceHall
//      case .scene: return SMDrawingError.scene
//      case .shop: return SMDrawingError.shop
//      case .wc: return SMDrawingError.wc
//      case .foodCourt: return SMDrawingError.foodCourt
//      case .beacon: return SMDrawingError.beacon
//      case .wifiPoint: return SMDrawingError.wifiPoint
//      case .room: return SMDrawingError.room
//      case .exhibit: return SMDrawingError.exhibit
//      case .grid: return SMDrawingError.grid
//    }
//  }
//  //-----------------------------------------------------------------------------------
//}

