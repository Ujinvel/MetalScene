/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Class for trinagele - base element, which will be draw
 */

import Metal
import QuartzCore
import UIKit

enum eGridSide {
  case x, y
}

typealias OriginalCellPolygon = (A: SVector2d, B: SVector2d, C: SVector2d, D: SVector2d)
typealias Cell                = (cellXPos: Int , cellYPos: Int, originalCellPolygon: OriginalCellPolygon, triangulatedCellPolygon: [SVector2d])

class SMTriangle: SMNode {
  private var originalSize: CGSize!// The original size of the plan that was received from the server
  private var triangulatedOriginalPolygons: [SVector2d] = []// Triangulated polygons in the original coordinate system
  private var colors: [ColorRGB]                        = []
  
  var drawLayerFrame: CGRect!
  var originalData: SPlanData!
  // Triangulated vertexes
  var grid: [SVertex]             = []
  var forbidCells: [SVertex]      = []
  var mainObjects: [ObjectVertex] = []
  var vertexesData: SVertexesData!
  
  var isDataProcessing = false
  
// MARK: - Constructor
  
  init(device: MTLDevice, drawLayerFrame: CGRect, data: SPlanData) {
    self.originalSize   = CGSize(width: CGFloat(data.originalWidth), height: CGFloat(data.originalHeight))
    self.drawLayerFrame = drawLayerFrame
    self.originalData   = data
    self.vertexesData   = SVertexesData()
    
    super.init(device: device, layerSize: drawLayerFrame.size)
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Debug profiling
  
  //*** Tracking the execution time of the block. Only for debugging
  private func profile(text: String, block: (() -> Void)) {
    let start = NSDate().timeIntervalSince1970
    block()
    let duration = NSDate().timeIntervalSince1970 - start
    
    print(text + "\(duration * 1000) ms")
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Preparation for drawing
  
  func setNewData(data: SPlanData) {
    originalSize = CGSize(width: CGFloat(data.originalWidth), height: CGFloat(data.originalHeight))
    originalData = data
    vertexesData = SVertexesData()
    
    clearBuffers()
  }
  //-----------------------------------------------------------------------------------
  
  func prepareObjectsForDraw(_ success: @escaping ((SError) -> Void)) {
    //let start = NSDate().timeIntervalSince1970
    isDataProcessing                    = true
    let dataProcessGroup: DispatchGroup = DispatchGroup()
    let offset: VertexOffset            = getOffset()
    
    prepareBackground(offset: offset)
    prepareUserPosition()
    
    dataProcessGroup.enter()
    DispatchQueue.global().async {
      SMGrid.prepareGrid(drawLayerFrame: self.drawLayerFrame, originalSize: self.originalSize, step: self.originalData.gridStep, grid: self.originalData.grid) { cells in
          var gridVertexes: [SVertex] = []
        
          for cell in cells.cells {
            gridVertexes += cell.triangulatedCellPolygon.map {SVertex(coordinates: $0, offset: offset, color: (red: 0, green: 0, blue: 0, alpha: 1))}
          }

          self.grid        = cells.lines
          self.forbidCells = gridVertexes

          //        let duration = NSDate().timeIntervalSince1970 - start
          //        print("time:" + "\(duration * 1000) ms")
          dataProcessGroup.leave()
       }
    }

    dataProcessGroup.enter()
    DispatchQueue.global().async {
      self.mainObjects = self.prepareMainObjects(offset: offset)
      
      dataProcessGroup.leave()
    }

    dataProcessGroup.notify(queue: .global()) {
      self.vertexesData.forbidCells = self.forbidCells
      self.vertexesData.grid        = self.grid
      self.vertexesData.planObjects = self.mainObjects
      
      success(super.createBuffers(vertices: self.vertexesData.getVertexes(showGrid: true)))

      self.isDataProcessing = false
    }
  }
  //-----------------------------------------------------------------------------------
  
// MARK: Objects
  
  func prepareContures(width: Int) {
    guard !vertexesData.isContouresExists() else { return }
    
    let contorWidth           = Float(width)//roundf(2 / offset.scale)//Float(object.borderWidth) / offset.scale
    let offset: VertexOffset  = getOffset()
    
    for object in originalData.objects {
      if object.type == cSMObjectsTypes.exhibit.rawValue {
        let triangulatedContour = SMContour.getContour(polygon: object.polygon, width: contorWidth)
        let contures            = triangulatedContour.map { SVertex(coordinates: $0, offset: offset, color: originalData.borderDefColor) }
        
        for i in 0...vertexesData.planObjects.count - 1 {
          if vertexesData.planObjects[i].id == object.id { vertexesData.planObjects[i].conturVertexes = contures; break }
        }
      }
    }
    
    vertexesData.selectedContourColor = originalData.borderSelectedColor
    vertexesData.defContourColor      = originalData.borderDefColor
    
    vertexesData.updateContoures(contouresID: [])
  }
  //-----------------------------------------------------------------------------------
  
  private func prepareBackground(offset: VertexOffset) {
    let background = [SVector2d(x: 0, y: 0),
                      SVector2d(x: 0, y: originalData.originalHeight),
                      SVector2d(x: originalData.originalWidth, y: originalData.originalHeight),
                      SVector2d(x: originalData.originalWidth, y: 0)]
    
    var triangulatedPolygon: [SVector2d] = []
    
    if SMTriangulate.process(contour: background, result: &triangulatedPolygon) == .success {
      vertexesData.planBackground = triangulatedPolygon.map { SVertex(coordinates: $0, offset: offset, color: (red: 0.5, green: 0.5, blue: 0, alpha: 1)) }
    }
  }
  //-----------------------------------------------------------------------------------
  
  @discardableResult private func prepareMainObjects(offset: VertexOffset) -> [ObjectVertex] {
    var triangulatedPolygon: [SVector2d] = []
    var verticesArray: [ObjectVertex]    = []
    
    // Make triangulation
    //originalData.objects.pmap { object, index in
    for object in originalData.objects {
      triangulatedPolygon.removeAll()
      
      if object.type != cSMObjectsTypes.room.rawValue  {
        if SMTriangulate.process(contour: object.polygon, result: &triangulatedPolygon) == .success {
          let vertexes  = triangulatedPolygon.map { SVertex(coordinates: $0, offset: offset, color: object.color) }
          
          verticesArray.append((id: object.id, type: object.type, objectVertexes: vertexes, conturVertexes: [], conturWidth: object.borderWidth))
        }// if the polygon is not correct - just do not draw it
      }
    }
    
    return verticesArray
  }
  //-----------------------------------------------------------------------------------
  
  func getOffset() -> VertexOffset {
    return SVertex.getOffset(drawLayerFrame: self.drawLayerFrame, originalSize: self.originalSize)
  }
  //-----------------------------------------------------------------------------------
  
  private func clearBuffers() {
    triangulatedOriginalPolygons.removeAll()
    colors.removeAll()
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Data update
  
  //*** Update the data for a new drawing size
  func refreshVertixes(newDrawableFrame: CGRect) {
    guard colors.count == triangulatedOriginalPolygons.count else { return }
    
    let verticesArray: [SVertex] = triangulatedOriginalPolygons
      .enumerated()
      .map { SVertex(coordinates: $1, drawLayerFrame: newDrawableFrame, originalSize: originalSize, color: colors[$0]) }
    
    super.refreshVertixes(vertixes: verticesArray)
  }
  //-----------------------------------------------------------------------------------
  
  func refreshBuffers() {
    prepareTextVertexis()
    
    super.createBuffers(vertices: vertexesData.getVertexes(showGrid: true), refreshUniform: false)
  }
  //-----------------------------------------------------------------------------------
  
  func updateVertixesWhisOutUniform() {
    super.createBuffers(vertices: vertexesData.getVertexes(showGrid: true), refreshUniform: false)
  }
  //-----------------------------------------------------------------------------------
  
// MARK: Contours select
  
  func showContoures(iDs: [Int]) {
    vertexesData.updateContoures(contouresID: iDs)
  }
  //-----------------------------------------------------------------------------------
}

