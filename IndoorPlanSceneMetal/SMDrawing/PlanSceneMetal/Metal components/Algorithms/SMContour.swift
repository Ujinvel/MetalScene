/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Сontour creation
 */

import Darwin

class SMContour {
  //*** Main method for obtaining triangulated contour polygon
  static func getContour(polygon: [SVector2d], width: Float) -> [SVector2d] {
    guard !polygon.isEmpty && polygon.count >= cMaths.minNumPolyVer else {// the polygon must have at least 3 vertices
      return []
    }
    
    var contourSide: [SVector2d]         = []
    var triangulatedContour: [SVector2d] = []
    var firstPoint: SVector2d            = SVector2d()
    var point: SVector2d?
    
    for i in 0...polygon.count - 1 {
      do {
        point = try getContourPoint(polygon: polygon, index: i, pointsCount: polygon.count, width: width)
        
        if i == 0 { firstPoint = point! }
        
        if i % 2 == 0 {
          contourSide.append(polygon[i])
          contourSide.append(point!)
        } else {
          contourSide.append(point!)
          contourSide.append(polygon[i])
        }
      } catch { return [] }
      
      triangulateContour(contour: &contourSide, result: &triangulatedContour)
      
      if i == polygon.count - 1 {
        contourSide.removeAll()
        
        contourSide.append(point!)
        contourSide.append(polygon[i])
        contourSide.append(polygon[0])
        contourSide.append(firstPoint)
        
        triangulateContour(contour: &contourSide, result: &triangulatedContour)
      }
    }
    
    return triangulatedContour
  }
  //-----------------------------------------------------------------------------------
  
  //*** Triangulation of the contour side
  static private func triangulateContour(contour: inout [SVector2d], result: inout [SVector2d]) {
    if contour.count == cMaths.quadPolyVer {// assembled part of the contour - a quadrilateral for one side
      var triangulatedPolygon: [SVector2d] = []
      
      if SMTriangulate.process(contour: contour, result: &triangulatedPolygon) == .success { result += triangulatedPolygon }
      
      contour.remove(at: 0)
      contour.remove(at: 0)
    }
  }
  //-----------------------------------------------------------------------------------
  
  //*** Obtaining the point of the contour lies on the bisector of the angle of the original polygon formed by the two sides. The distance depends on the thickness of the contour
  static private func getContourPoint(polygon: [SVector2d], index: Int, pointsCount: Int, width: Float) throws -> SVector2d {
    var triangle: (A: SVector2d, B: SVector2d, C: SVector2d) = (polygon[index], SVector2d(), SVector2d())
    var point: SVector2d                                     = SVector2d()
    
    if index == 0 {
      triangle.B = polygon[index + 1]; triangle.C = polygon[pointsCount - 1]
    } else if index == pointsCount - 1 {
      triangle.B = polygon[0]; triangle.C = polygon[index - 1]
    } else {
      triangle.B = polygon[index + 1]; triangle.C = polygon[index - 1]
    }
    
    var vectorAB: (x: Float, y: Float) = (0, 0)
    var vectorAC: (x: Float, y: Float) = (0, 0)
    var alpha: Float                   = 0
    
    let AF: Float = getHypotenuse(vectorAB: &vectorAB, vectorAC: &vectorAC, triangle: triangle, width: width, angle: &alpha)
    
    if AF == 0 {
      throw SError(type: .defaultDevice, description: String(describing: cErrorType.getErrorDescription(.defaultDevice)))// for debug in real app ignore result
    } else {
      let D = getIntersectionPointOfBisector(vectorAB: vectorAB, vectorAC: vectorAC, triangle: triangle)
      
      let vectorAD: (x: Float, y: Float) = (D.x - triangle.A.vector2d.x, D.y - triangle.A.vector2d.y)
      let AD: Float                      = (powf(vectorAD.x, 2) + powf(vectorAD.y, 2)).squareRoot()
      let ortAD: (x: Float, y: Float)    = (vectorAD.x / AD, vectorAD.y / AD)
      
      point.vector2d = (x: ortAD.x * AF + triangle.A.vector2d.x, y: ortAD.y * AF + triangle.A.vector2d.y)
      
      let rotationAngleRad: Float = (cMaths.circleDeg / 2) / (cMaths.circleDeg / 2) * .pi
      
      if isPointInsidePolygon(point: point, polygon: polygon) { rotate(point: &point, to: rotationAngleRad, on: triangle.A) }
    }
    
    return point
  }
  //-----------------------------------------------------------------------------------
  
  static private func getHypotenuse(vectorAB: inout (x: Float, y: Float),
                                    vectorAC: inout (x: Float, y: Float),
                                    triangle: (A: SVector2d, B: SVector2d, C: SVector2d),
                                    width: Float,
                                    angle: inout Float) -> Float {
    vectorAB = (x: triangle.B.vector2d.x - triangle.A.vector2d.x,
                y: triangle.B.vector2d.y - triangle.A.vector2d.y)
    vectorAC = (x: triangle.C.vector2d.x - triangle.A.vector2d.x,
                y: triangle.C.vector2d.y - triangle.A.vector2d.y)
    
    let alpha = (vectorAB.x * vectorAC.x + vectorAB.y * vectorAC.y) /
      ( (powf(vectorAB.x, 2) + powf(vectorAB.y, 2)).squareRoot() * (powf(vectorAC.x, 2) + powf(vectorAC.y, 2)).squareRoot() )
    angle     = acosf(alpha) * (cMaths.circleDeg / 2) / .pi
    
    if angle == 0 || angle == (cMaths.circleDeg / 2) { return 0 }
    else { return width / sinf(angle / 2) }
  }
  //-----------------------------------------------------------------------------------
  
  static private func getIntersectionPointOfBisector(vectorAB: (x: Float, y: Float),
                                                     vectorAC: (x: Float, y: Float),
                                                     triangle: (A: SVector2d, B: SVector2d, C: SVector2d)) -> (x: Float, y: Float) {
    var D: (x: Float, y: Float) = (0, 0)
    
    let AB: Float     = (powf(vectorAB.x, 2) + powf(vectorAB.y, 2)).squareRoot()
    let AC: Float     = (powf(vectorAC.x, 2) + powf(vectorAC.y, 2)).squareRoot()
    let lambda: Float = AB / AC
    
    D.x = (triangle.B.vector2d.x + lambda * triangle.C.vector2d.x) / (1 + lambda)
    D.y = (triangle.B.vector2d.y + lambda * triangle.C.vector2d.y) / (1 + lambda)
    
    return D
  }
  //-----------------------------------------------------------------------------------
  
  static private func rotate(point: inout SVector2d, to angle: Float, on anchorPoint: SVector2d) {
    point.vector2d.x = anchorPoint.vector2d.x + (point.vector2d.x - anchorPoint.vector2d.x) * cosf(angle) - (point.vector2d.y - anchorPoint.vector2d.y) * sinf(angle)
    point.vector2d.y = anchorPoint.vector2d.y + (point.vector2d.x - anchorPoint.vector2d.x) * sinf(angle) + (point.vector2d.y - anchorPoint.vector2d.y) * cosf(angle)
  }
  //-----------------------------------------------------------------------------------
  
  //*** Сheck for belonging to a polygon point
  static private func isPointInsidePolygon(point: SVector2d, polygon p: [SVector2d]) -> Bool {
    var flag = false
    let N    = p.count
    var i1   = 0
    var i2   = 0
    
    for n in 0...N - 1 {
      flag = false
      i1   = (n < N - 1) ? n + 1 : 0
      
      while !flag {
        i2 = i1 + 1
        
        if i2 >= N { i2 = 0 }
        
        if i2 == (n < N - 1 ? n + 1 : 0) { break }
        
        var part1: Int32 = 0
        var part2: Int32 = 0
        var part3: Int32 = 0
        
        part1 = p[i1].intVector.x * (p[i2].intVector.y - p[n].intVector.y)
        part2 = p[i2].intVector.x * (p[n].intVector.y - p[i1].intVector.y)
        part3 = p[n].intVector.x * (p[i1].intVector.y - p[i2].intVector.y)
        let S = abs(part1 + part2 + part3)
        
        part1  = p[i1].intVector.x * (p[i2].intVector.y - point.intVector.y)
        part2  = p[i2].intVector.x * (point.intVector.y - p[i1].intVector.y)
        part3  = point.intVector.x * (p[i1].intVector.y - p[i2].intVector.y)
        let S1 = abs(part1 + part2 + part3)
        
        part1  = p[n].intVector.x * (p[i2].intVector.y - point.intVector.y)
        part2  = p[i2].intVector.x * (point.intVector.y - p[n].intVector.y)
        part3  = point.intVector.x * (p[n].intVector.y - p[i2].intVector.y)
        let S2 = abs(part1 + part2 + part3)
        
        part1  = p[i1].intVector.x * (p[n].intVector.y - point.intVector.y)
        part2  = p[n].intVector.x * (point.intVector.y - p[i1].intVector.y)
        part3  = point.intVector.x * (p[i1].intVector.y - p[n].intVector.y)
        let S3 = abs(part1 + part2 + part3)
        
        if S == S1 + S2 + S3 { flag = true; break }
        
        i1 = i1 + 1
        
        if i1 >= N { i1 = 0 }
      }
      
      if !flag { break }
    }
    
    return flag
  }
  //-----------------------------------------------------------------------------------
}

