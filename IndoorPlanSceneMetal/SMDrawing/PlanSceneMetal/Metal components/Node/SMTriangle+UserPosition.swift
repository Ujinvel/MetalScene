/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

extension SMTriangle {
// MARK: - Preparetion
  
  func prepareUserPosition() {
    vertexesData.lookMarker = getCircleVertexes(radius: Float(cMarkers.containerWidth) / 2,
                                                degStart: Int(Double(cCompass.fullСircle / 2) + cMarkers.angleOfViewStart),
                                                degEnd: Int(cCompass.fullСircle - cMarkers.angleOfViewStart))
    
    vertexesData.locationInnerMarker = getCircleVertexes(radius: Float(cMarkers.locationRadius),
                                                         degStart: 0,
                                                         degEnd: Int(cCompass.fullСircle))
    vertexesData.locationOuterMarker = getCircleVertexes(radius: Float(cMarkers.locationContainerRadius),
                                                         degStart: 0,
                                                         degEnd: Int(cCompass.fullСircle))
    
    vertexesData.realPosMarker = getCircleVertexes(radius: Float(cMarkers.realPosRadius),
                                                   degStart: 0,
                                                   degEnd: Int(cCompass.fullСircle))
  }
  //-----------------------------------------------------------------------------------
  
  private func getCircleVertexes(radius: Float, degStart: Int, degEnd: Int) -> [SVertex] {
    let offset: VertexOffset             = getOffset()
    var poly: [SVector2d]                = (degStart == 0 ? [] : [SVector2d(x: 0, y: 0)])
    var triangulatedPolygon: [SVector2d] = []
    var vertexesCircle: [SVertex]        = []
    
    for i in degStart..<degEnd {
      let xOnCircle = radius * offset.scale * cos(Float(i) * Float.pi / Float(cCompass.fullСircle / 2))
      let yOnCircle = radius * offset.scale * sin(Float(i) * Float.pi / Float(cCompass.fullСircle / 2))
      
      poly.append(SVector2d(x: xOnCircle, y: yOnCircle))
    }
    
    if SMTriangulate.process(contour: poly, result: &triangulatedPolygon) == .success {
      vertexesCircle += triangulatedPolygon.map { SVertex(coordinates: $0,
                                                          color: EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.green),
                                                          textPos: (x: 0, y: 0, isText: 0), isUserLocation: 1) }
    }
    
    return vertexesCircle
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Pozition
  
  func setMarkerAtPoint(_ point: CGPoint) {
    let offset: VertexOffset = getOffset()
    
    let scaledPoint = CGPoint(x: CGFloat(Float(point.x) * offset.scale + offset.x), y: CGFloat(Float(point.y) * offset.scale + offset.y))
    
    refreshUniformBuffer(layerSize: nil, userLocation: scaledPoint)
    updateVertixesWhisOutUniform()
  }
  //-----------------------------------------------------------------------------------
}

