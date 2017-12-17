/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Grid preparing
 */

import UIKit

class SMGrid {
  static func prepareGrid(drawLayerFrame: CGRect,
                          originalSize: CGSize,
                          step: Float,
                          gridLineWidth: Int32 = 1,
                          gridColor: ColorRGB = EnSMObjectsColorsRGB.color(cSMObjectsColors.darkpurple),
                          grid: [GridFilling],
                          success: @escaping ((_ result: (cells: [Cell], lines: [SVertex])) -> Void)) {
    let yCellCount = lroundf(Float(originalSize.height) / step)
    let xCellCount = lroundf(Float(originalSize.width) / step)
    
    let linesProcessGroup = DispatchGroup()
    //let cellSide          = (Float(originalSize.width) - gridLineWidth * Float(xCellCount)) / Float(xCellCount)
    let cellSide          = Int32((Float(originalSize.width) - Float(gridLineWidth) * Float(xCellCount)) / Float(xCellCount))
    let offset            = SVertex.getOffset(drawLayerFrame: drawLayerFrame, originalSize: originalSize)
    //offset.scale = Float(Int(offset.scale))
    var xlines: [SVertex] = []
    var ylines: [SVertex] = []
    
    let cells = getCells(xCellCount: xCellCount, yCellCount: yCellCount, lineWidth: gridLineWidth, cellSide: cellSide, grid: grid)
    
    linesProcessGroup.enter()
    DispatchQueue.global().async {
      self.getGridLines(cells: cells,
                        xCellCount: xCellCount,
                        yCellCount: yCellCount,
                        lineWidth: gridLineWidth,
                        side: .x,
                        offset: offset,
                        lineColor: gridColor) { lines in xlines = lines; linesProcessGroup.leave() }
    }
    
    linesProcessGroup.enter()
    DispatchQueue.global().async {
      self.getGridLines(cells: cells,
                        xCellCount: xCellCount,
                        yCellCount: yCellCount,
                        lineWidth: gridLineWidth,
                        side: .y,
                        offset: offset,
                        lineColor: gridColor) { lines in ylines = lines; linesProcessGroup.leave() }
    }
    
    linesProcessGroup.notify(queue: .global()) {
      success((cells: cells, lines: xlines + ylines))
    }
  }
  //-----------------------------------------------------------------------------------
  
  static private func getCells(xCellCount: Int, yCellCount: Int, lineWidth: Int32, cellSide: Int32, grid: [GridFilling]) -> [Cell] {
    guard xCellCount != 0 && yCellCount != 0 && lineWidth != 0 && cellSide != 0 else { return [] }
    
    var cells: [Cell] = []
    
    for i in 0...(xCellCount - 1) {
      for j in 0...(yCellCount - 1) {
        var line: [SVector2d] = []
        
        let Ax = Float(i) * (Float(cellSide) + Float(lineWidth)); let Ay: Float = Float(j) * (Float(cellSide) + Float(lineWidth))
        let Bx = Ax + Float(cellSide);                     let By: Float = Ay
        let Cx = Bx;                                       let Cy: Float = By + Float(cellSide)
        let Dx = Ax;                                       let Dy: Float = Ay + Float(cellSide)
        
        line.append(SVector2d(x: Ax, y: Ay))
        line.append(SVector2d(x: Bx, y: By))
        line.append(SVector2d(x: Cx, y: Cy))
        line.append(SVector2d(x: Dx, y: Dy))
        
        var cell: Cell = (cellXPos: i , cellYPos: j,
                          originalCellPolygon: (A: SVector2d(x: Ax, y: Ay), B: SVector2d(x: Bx, y: By), C: SVector2d(x: Cx, y: Cy), D: SVector2d(x: Dx, y: Dy)),
                          triangulatedCellPolygon: [])
        
        getForbiddenCell(line: line, cell: &cell, i: i, j: j, grid: grid)
        cells.append(cell)
      }
    }
    
    return cells
  }
  //-----------------------------------------------------------------------------------
  
  static private func getForbiddenCell(line: [SVector2d], cell: inout Cell, i: Int, j: Int, grid: [GridFilling]) {
    var triangulatedPolygon: [SVector2d] = []
    
    for grid in grid {
      if grid.cellXPos == i + 1 && grid.cellYPos == j + 1 {
        if SMTriangulate.process(contour: line, result: &triangulatedPolygon) == .success { cell.triangulatedCellPolygon = triangulatedPolygon }
      }
    }
  }
  //-----------------------------------------------------------------------------------
  
  static private func getGridLines(cells: [Cell],
                                   xCellCount: Int,
                                   yCellCount: Int,
                                   lineWidth: Int32,
                                   side: eGridSide,
                                   offset: VertexOffset,
                                   lineColor: ColorRGB,
                                   _ success: @escaping (([SVertex]) -> Void)) {
    guard !cells.isEmpty && xCellCount != 0 && yCellCount != 0 else { return }
    
    var triangulatedLines: [SVertex] = []
    let sideCellsCount: Int          = (side == .x ? xCellCount : yCellCount)
    //let parallelArr                  = Array<Int>(repeating: 0, count: sideCellsCount)
    
    //parallelArr.pmap { element, i in
    for i in 0...(sideCellsCount - 1) {
      let minXPos = (side == .x ? i : 0)
      let minYPos = (side == .x ? 0 : i)
      let maxXPos = (side == .x ? i : xCellCount - 1)
      let maxYPos = (side == .x ? yCellCount - 1 : i)
      
      let xMin = cells.filter { $0.cellXPos == minXPos && $0.cellYPos == minYPos }
      let xMax = cells.filter { $0.cellXPos == maxXPos && $0.cellYPos == maxYPos }
      
      guard let xMin_ = xMin.first else { fatalError() }
      guard let xMax_ = xMax.first else { fatalError() }
      
      var line: [SVector2d]                = []
      var triangulatedPolygon: [SVector2d] = []
      
      if side == .x {
        line.append(SVector2d(x: Float(xMin_.originalCellPolygon.B.intVector.x),
                              y: Float(xMin_.originalCellPolygon.B.intVector.y)))
        line.append(SVector2d(x: Float(xMin_.originalCellPolygon.B.intVector.x + lineWidth),
                              y: Float(xMin_.originalCellPolygon.B.intVector.y)))
        line.append(SVector2d(x: Float(xMax_.originalCellPolygon.C.intVector.x + lineWidth),
                              y: Float(xMax_.originalCellPolygon.C.intVector.y + lineWidth)))
        line.append(SVector2d(x: Float(xMax_.originalCellPolygon.C.intVector.x),
                              y: Float(xMax_.originalCellPolygon.C.intVector.y + lineWidth)))
      } else {
          line.append(SVector2d(x: Float(xMin_.originalCellPolygon.D.intVector.x),
                                y: Float(xMin_.originalCellPolygon.D.intVector.y)))
          line.append(SVector2d(x: Float(xMin_.originalCellPolygon.D.intVector.x),
                                y: Float(xMin_.originalCellPolygon.D.intVector.y + lineWidth)))
          line.append(SVector2d(x: Float(xMax_.originalCellPolygon.C.intVector.x),
                                y: Float(xMax_.originalCellPolygon.C.intVector.y + lineWidth)))
          line.append(SVector2d(x: Float(xMax_.originalCellPolygon.C.intVector.x),
                                y: Float(xMax_.originalCellPolygon.C.intVector.y)))
        }
      
      if SMTriangulate.process(contour: line, result: &triangulatedPolygon) == .success {
        triangulatedLines += triangulatedPolygon.map { SVertex(coordinates: $0, offset: offset, color: lineColor) }
      }
    }
    
    success(triangulatedLines)
  }
  //-----------------------------------------------------------------------------------
}

