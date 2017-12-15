/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Vertexes ready to drawing
 */

typealias ObjectVertex = (id: Int, type: Int, objectVertexes: [SVertex], conturVertexes: [SVertex], conturWidth: Float)

struct SVertexesData {
  var planObjects: [ObjectVertex] = []
  var planBackground: [SVertex]   = []
  // Markers
  var lookMarker: [SVertex]          = []
  var locationInnerMarker: [SVertex] = []
  var locationOuterMarker: [SVertex] = []
  var realPosMarker: [SVertex]       = []
  // Text
  var text: [SVertex] = []
  // Grid
  var grid: [SVertex]        = []
  var forbidCells: [SVertex] = []
  var conturesIDs: [Int]     = []
  // Markers flags
  var showLookMarker: Bool     = false
  var showLocationMarker: Bool = false
  var showRealPosMarker: Bool  = false
  // Text flag
  var showIDs: Bool = true
  
  var defContourColor: ColorRGB      = EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear)
  var selectedContourColor: ColorRGB = EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear)
  
  func isContouresExists() -> Bool {
    for object in planObjects {
      if !object.conturVertexes.isEmpty { return true }
    }
    
    return false
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Colors
  
  mutating func setColor(color: ColorRGB, vertexes: inout [SVertex]) {
    vertexes = vertexes.map {
      var object = $0
      
      object.setColor(color)
      
      return object
    }
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColorForObjectType(_ type: Int, objectColor: ColorRGB, contourColor: ColorRGB) {
    planObjects = planObjects.map {
      var object = $0
      if $0.type == type {
        object.conturVertexes = $0.conturVertexes.map { setColorForVertex($0, color: contourColor) }
        object.objectVertexes = $0.objectVertexes.map { setColorForVertex($0, color: objectColor) }
      }
      
      return object
    }
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColorForGridLines(color: ColorRGB) {
    var gridNew = grid
    
    setColor(color: color, vertexes: &gridNew)
    
    defer { grid = gridNew }
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColorForBackground(color: ColorRGB) {
    var planBackgroundNew = planBackground
    
    setColor(color: color, vertexes: &planBackgroundNew)
    
    defer { planBackground = planBackgroundNew }
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColorForForbiddenCells(color: ColorRGB) {
    var forbidCellsNew = forbidCells
    
    setColor(color: color, vertexes: &forbidCellsNew)
    
    defer { forbidCells = forbidCellsNew }
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColorForObjectId(_ id: Int, color: ColorRGB) {
    for i in 0...planObjects.count - 1 {
      if planObjects[i].id == id {
        var object = planObjects[i].objectVertexes
        
        setColor(color: color, vertexes: &object)
        
        planObjects[i].objectVertexes = object
        
        break
      }
    }
  }
  //-----------------------------------------------------------------------------------
  
  func setColorForVertex(_ vertex: SVertex, color: ColorRGB) -> SVertex {
    var newVertex = vertex
    
    newVertex.setColor(color)
    
    return newVertex
  }
  //-----------------------------------------------------------------------------------
  
// MARK: User position colors
  
  mutating func setColorForLookMarker(color: ColorRGB) {
    var lookMarkerNew = lookMarker
    
    setColor(color: color, vertexes: &lookMarkerNew)
    
    defer { lookMarker = lookMarkerNew }
  }
  //-----------------------------------------------------------------------------------

  mutating func setColorForLocationInnerMarker(_ color: ColorRGB) {
    var locationInnerMarkerNew = locationInnerMarker
    
    setColor(color: color, vertexes: &locationInnerMarkerNew)
    
    defer { locationInnerMarker = locationInnerMarkerNew }
  }
  //-----------------------------------------------------------------------------------
  
  mutating func setColorForLocationOuterMarker(_ color: ColorRGB) {
    var locationOuterMarkerNew = locationOuterMarker
    
    setColor(color: color, vertexes: &locationOuterMarkerNew)
    
    defer { locationOuterMarker = locationOuterMarkerNew }
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Contoures
  
  mutating func updateContoures(contouresID: [Int]) {
    conturesIDs = contouresID
    
    for i in 0...planObjects.count - 1 {
      planObjects[i].conturVertexes = planObjects[i].conturVertexes.map {
        var newVertex = $0
        
        newVertex.setColor(defContourColor)
        
        return newVertex
      }
    }
    
    if !contouresID.isEmpty {
      for contourID in conturesIDs {
        for i in 0...planObjects.count - 1 {
          if contourID == planObjects[i].id {
            planObjects[i].conturVertexes = planObjects[i].conturVertexes.map {
              var newVertex = $0
              
              newVertex.setColor(selectedContourColor)
              
              return newVertex
            }
          }
        }
      }
    }
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Data
  
  func isDataEmpty() -> Bool {
    return planObjects.isEmpty
  }
  //-----------------------------------------------------------------------------------

  func getVertexes(showGrid: Bool) -> [SVertex] {
    // Grid
    let grids: [SVertex] = (showGrid ? grid : [])
    let cells: [SVertex] = (showGrid ? forbidCells : [])
    // Markers
    let lookMarkers: [SVertex]          = (showLookMarker ? lookMarker : [])
    let locationInnerMarkers: [SVertex] = (showLocationMarker ? locationInnerMarker : [])
    let locationOuterMarkers: [SVertex] = (showLocationMarker ? locationOuterMarker : [])
    let realPosMarkers: [SVertex]       = (showRealPosMarker ? realPosMarker : [])
    // Text(IDs)
    let textIDs: [SVertex] = (showIDs ? text : [])
    // Objects
    let objectVertexes: [SVertex] = planObjects.map { $0.objectVertexes }.flatMap { $0 }

    let objectsContures: [[SVertex]] = planObjects
      .filter { !$0.conturVertexes.isEmpty }
      .map { $0.conturVertexes }
    
    let contures = objectsContures.flatMap { $0 }
    let markers  = lookMarkers + locationOuterMarkers + locationInnerMarkers + realPosMarkers
    
    return planBackground + grids + cells + objectVertexes + contures + textIDs + markers
  }
  //-----------------------------------------------------------------------------------
}

