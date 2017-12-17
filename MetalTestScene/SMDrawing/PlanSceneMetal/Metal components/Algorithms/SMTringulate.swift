/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Converting a polygon into triangles
 * Useful links: https://en.wikipedia.org/wiki/Barycenter
 */

let cEpcilon: Float = 0.0000000001

enum eNTriangulateError {
  case success
  case line// In the input data less than 3 points
  case bad// Bad polygon
}

typealias Vector2d   = [SVector2d]
typealias Triangle2d = (A: SVector2d, B: SVector2d, C: SVector2d)

class SMTriangulate {
  // MARK: - Polygon scale
  
  //*** Scale relative to the center of the polygon
  private static func prepareInnnerPolygon(polygon: [SVector2d], scale: Float) -> [SVector2d] {
    let center = getBarycenter(polygon)
    
    return polygon.map { point in
      let newX = point.vector2d.x * scale + center.vector2d.x * (1 - scale)
      let newY = point.vector2d.y * scale + center.vector2d.y * (1 - scale)
      
      return SVector2d(x: newX, y: newY)
    }
  }
  //-----------------------------------------------------------------------------------
  
  //*** Geometric center of a two-dimensional domain
  static func getBarycenter(_ contour: Vector2d) -> SVector2d {
    let n: Int    = contour.count
    var Gx: Float = 0// x coordinate of the center
    var Gy: Float = 0// y coordinate of the center
    let A: Float  = area(contour)
    var p: Int    = n - 1
    var q: Int    = 0
    
    while q < n {
      Gx += (contour[p].vector2d.x * contour[q].vector2d.y - contour[q].vector2d.x * contour[p].vector2d.y) * (contour[p].vector2d.x + contour[q].vector2d.x)
      Gy += (contour[p].vector2d.x * contour[q].vector2d.y - contour[q].vector2d.x * contour[p].vector2d.y) * (contour[p].vector2d.y + contour[q].vector2d.y)
      
      p = q
      q += 1
    }
    
    Gx = Gx / (6 * A)// 6 is a constant from formula
    Gy = Gy / (6 * A)
    
    return SVector2d(x: Gx, y: Gy)
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Polygon triangulation
  
  static func process(contour: Vector2d, result: inout [SVector2d]) -> eNTriangulateError {
    // Allocate and initialize list of Vertices in polygon
    guard contour.count >= 3 else { return .line }
    
    result.removeAll()
    
    let n = contour.count
    
    var V = Array<Int>(repeating: 0, count: n)
    
    // We want a counter-clockwise polygon in V
    let A = area(contour)
    
    for v in 0...n - 1 {
      if A > 0 { V[v] = v }
      else { V[v] = (n - 1) - v }
    }
    
    var nv: Int = n
    
    // Remove nv-2 Vertices, creating 1 triangle every time
    var count = 2 * nv// error detection
    
    var m: Int = 0
    var v: Int = nv - 1
    
    while nv > 2 {
      // If we loop, it is probably a non-simple polygon
      if 0 >= count - 1 {
        return .bad
      }
      
      count -= 1
      
      // Three consecutive vertices in current polygon, <u, v, w>
      var u = v
      
      if nv <= u { u = 0 }// previos
      
      v = u + 1
      
      if nv <= v { v = 0 }// new v
      
      var w: Int = v + 1
      
      if nv <= w { w = 0 }// next
      
      if snip(contour: contour, u: u, v: v, w: w, n: nv, V: V) {
        // True names of the vertices
        let a = V[u]; let b = V[w]; let c = V[v]
        
        // Output Triangle
        result.append(contour[a])
        result.append(contour[b])
        result.append(contour[c])
        
        m += 1
        
        // Remove v from remaining polygon
        var s: Int = v
        var t: Int = v + 1
        
        while t < nv {
          V[s] = V[t]
          
          s += 1
          t += 1
        }
        
        nv -= 1
        
        // Resest error detection counter
        count = 2 * nv
      }
    }
    
    return .success
  }
  //-----------------------------------------------------------------------------------
  
  static func area(_ contour: Vector2d) -> Float {
    let n: Int   = contour.count
    var A: Float = 0
    var p: Int   = n - 1
    var q: Int   = 0
    
    while q < n {
      A += contour[p].vector2d.x * contour[q].vector2d.y - contour[q].vector2d.x * contour[p].vector2d.y
      
      p = q
      q += 1
    }
    
    return A / 2
  }
  //-----------------------------------------------------------------------------------
  
  private static func snip(contour: Vector2d, u: Int, v: Int, w: Int, n: Int, V: [Int]) -> Bool {
    let Ax: Float = contour[V[u]].vector2d.x
    let Ay: Float = contour[V[u]].vector2d.y
    
    let Bx: Float = contour[V[v]].vector2d.x
    let By: Float = contour[V[v]].vector2d.y
    
    let Cx: Float = contour[V[w]].vector2d.x
    let Cy: Float = contour[V[w]].vector2d.y
    
    if cEpcilon > ( (Bx - Ax) * (Cy - Ay) ) - ( (By - Ay) * (Cx - Ax) ) { return false }
    
    for p in 0...n - 1 {
      if !((p == u) || (p == v) || (p == w)) {
        let Px = contour[V[p]].vector2d.x
        let Py = contour[V[p]].vector2d.y
        
        if insideTriangle(Ax: Ax, Ay: Ay,
                          Bx: Bx, By: By,
                          Cx: Cx, Cy: Cy,
                          Px: Px, Py: Py) { return false }
      }
    }
    
    return true
  }
  //-----------------------------------------------------------------------------------
  
  private static func insideTriangle(Ax: Float, Ay: Float,
                                     Bx: Float, By: Float,
                                     Cx: Float, Cy: Float,
                                     Px: Float, Py: Float) -> Bool {
    let ax  = Cx - Bx;  let ay  = Cy - By
    let bx  = Ax - Cx;  let by  = Ay - Cy
    let cx  = Bx - Ax;  let cy  = By - Ay
    let apx = Px - Ax;  let apy = Py - Ay
    let bpx = Px - Bx;  let bpy = Py - By
    let cpx = Px - Cx;  let cpy = Py - Cy
    
    let aCROSSbp = ax * bpy - ay * bpx
    let cCROSSap = cx * apy - cy * apx
    let bCROSScp = bx * cpy - by * cpx
    
    return (aCROSSbp >= 0) && (bCROSScp >= 0) && (cCROSSap >= 0)
  }
  //-----------------------------------------------------------------------------------
}

