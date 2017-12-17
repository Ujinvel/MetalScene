/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

extension SMTriangle {
  func prepareTextVertexis() {
    let offset: VertexOffset  = getOffset()
    let atlas                 = SMFontAtlasBuild.getFontAtlasWhisFontName(cText.defFontName, andSize: cText.defFontSize)
    var vertexBuff: [SVertex] = []
    
    for object in originalData.objects {
      if object.type == cSMObjectsTypes.exhibit.rawValue {
        let center   = SMTriangulate.getBarycenter(object.polygon)
        var rect     = CGRect(origin: CGPoint(x: CGFloat(center.vector2d.x), y: CGFloat(center.vector2d.y)), size: CGSize(width: cText.textWidth, height: cText.texHeight))
        
        rect.origin.x = (CGFloat(offset.x + Float(rect.origin.x) * offset.scale)) - cText.textWidth / 2
        rect.origin.y = (CGFloat(offset.y + (Float(offset.originalSize.height) - Float(rect.origin.y)) * offset.scale)) - cText.texHeight / 2
        
        let id       = object.id.description
        //        let width    = atlas?.estimatedLineWidth(for: UIFont(name: "HoeflerText-Regular", size: 20)!, andString: id)
        //        let height   = UIFont(name: "HoeflerText-Regular", size: 20)!.pointSize
        
        let textMesh = SMTextMesh(string: id, in: rect, with: atlas, atSize: cText.defFontSize, drawingFrame: drawLayerFrame)
        
        let vertexArr: [SMVectorTextMesh] = textMesh?.vertexArr as! [SMVectorTextMesh]
        
        let buff: [SVertex] = vertexArr.map { vertex in
          return SVertex(coordinates: SVector2d(x: vertex.positionX, y: vertex.positionY), color: EnSMObjectsColorsRGB.color(cSMObjectsColors.clear),
                         textPos: (x: vertex.textX, y: vertex.textY, isText: 1))
        }
        
        vertexBuff += buff
      }
    }
    
    vertexesData.text = vertexBuff
  }
  //-----------------------------------------------------------------------------------
}
