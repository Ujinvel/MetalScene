/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 *
 */

//import IndoorModel
import UIKit

public class SMDrawingView: UIView {
  private lazy var drawingLayer: SMDrawingLayer = {
    do {
      return try SMDrawingLayer(containerView: self, textureIncreaseMultiplyer: 2)
    } catch let error as SError { fatalError(error.description) }
    catch { fatalError(error.localizedDescription) }
  }()

  // MARK: - Constructor

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  //-----------------------------------------------------------------------------------

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  //-----------------------------------------------------------------------------------

  public init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  }
  //-----------------------------------------------------------------------------------
  
  public func process(data: SPlanData) {
    drawingLayer.inputData = data
    
    drawingLayer.processData(inputData: data) {_ in
      self.drawingLayer.updateColors()
      self.drawingLayer.run()
    }
    
  }
  //-----------------------------------------------------------------------------------

// MARK: - IPlanView

  //*** When will the text display mechanism be implemented
  public var showObjectsId : Bool {
    get {
      return true
    }
    
    set {
      
    }
  }
  //-----------------------------------------------------------------------------------
  
//  public var zoomEnabled: Bool {
//    get { return drawingLayer.containerView.scrollView.isUserInteractionEnabled }
//    set(newValue) { drawingLayer.containerView.scrollView.isUserInteractionEnabled = newValue }
//  }
//  //-----------------------------------------------------------------------------------
//
//  public func rotate(toAngle: CGFloat) {
//    drawingLayer.rotateToRadAngle(CGFloat(Double(toAngle).degreesToRadians))
//  }
//  //-----------------------------------------------------------------------------------

//  public func placeMarker(withType type: IndTypes.MarkersTypes, atPoint point: CGPoint) {
//    showMarker(withType: type, hide: false)
//    //drawingLayer.userLocation.setCenter(center: point)
//    drawingLayer.polygonsToDraw.setMarkerAtPoint(point)
//  }
//  //-----------------------------------------------------------------------------------
//
//  public func removeMarker(withType type: IndTypes.MarkersTypes) {
//    showMarker(withType: type, hide: true)
//    drawingLayer.polygonsToDraw.updateVertixesWhisOutUniform()
//  }
//  //-----------------------------------------------------------------------------------
//
//  public func removeAllMarkers() {
//    drawingLayer.polygonsToDraw.vertexesData.showLocationMarker = false
//    drawingLayer.polygonsToDraw.vertexesData.showLookMarker     = false
//    drawingLayer.polygonsToDraw.vertexesData.showRealPosMarker  = false
//
//    drawingLayer.polygonsToDraw.updateVertixesWhisOutUniform()
//    //drawingLayer.userLocation.hideAll(true)
//  }
//  //-----------------------------------------------------------------------------------
//
//  public func updateWith(plan: IPlan, theme: IThemeManager, _ callback: @escaping ((_ error: IErrorTypeWithNSError?) -> Void)) {
//    updateWith(plan: plan) { [weak self] in
//      callback(self?.setTheme(theme))
//    }
//  }
//  //-----------------------------------------------------------------------------------
//
//  public func select(objects: [Int]) {
//    drawingLayer.showContour(iDs: objects)
//    drawingLayer.updateColors()
//  }
//  //-----------------------------------------------------------------------------------
//
//  private func setTheme(_ theme: IThemeManager) -> IErrorTypeWithNSError? {
//    var error: IErrorTypeWithNSError?
//
//    guard let types = drawingLayer.inputData?.objectTypes, drawingLayer.isDataProcessing() == false else { return nil }
//
//    let lookMarkerTheme     = theme.getThemeForLookMarker()
//    let locationMarkerTheme = theme.getThemeForLocationMarker()
//
//    for type in types {
//      let objectTheme = theme.getThemeForObject(IndTypes.ObjectType(rawValue: type.rawValue)!)
//
//      if !drawingLayer.setThemeForObject(type: type,
//                                         color: objectTheme.fillColor,
//                                         borderWidth: objectTheme.borderWidth,
//                                         borderColor: objectTheme.borderColor,
//                                         borderSelectedColor: theme.selectedBorderColor) {
//        error = SMDrawingError.getErrorForType(type)
//      }
//    }
//    // font
////    let font = theme.applicationFonts.lblFont
////    let fontName = font.fontName
////    let fontSize = font.pointSize
//    // background
//    self.backgroundColor = theme.worldBg
//
//    drawingLayer.setColorForBackground(theme.planBg)
//    // grid
//    let objectTheme = theme.getThemeForLayerNode(IndTypes.LayerType.routesGrid)
//
//    drawingLayer.setForbiddenCellsColor(objectTheme.fillSquareColor)
//    drawingLayer.setGridColor(UIColor.black)
//    // location
//    drawingLayer.setLookMarkerTheme(color: lookMarkerTheme.fillColor,
//                                    borderColor: lookMarkerTheme.borderColor,
//                                    borderWidth: lookMarkerTheme.borderWidth)
//    drawingLayer.setLocationMarkerTheme(mainColor: locationMarkerTheme.mainColor,
//                                        outerColor: locationMarkerTheme.outerColor,
//                                        borderColor: locationMarkerTheme.borderColor,
//                                        borderWidth: locationMarkerTheme.borderWidth)
//    drawingLayer.updateColors()
//
//    return error
//  }
//  //-----------------------------------------------------------------------------------
//
//// MARK: - Data processing
//
//  @discardableResult public func updateWith(plan: IPlan, _ callback: @escaping (() -> Void)) -> Bool {
//    guard !plan.layers.isEmpty else { return false }
//
//    var data = SPlanData()
//
//    drawingLayer.containerView.scrollView.setZoomScale(1, animated: true)
//
//    data.originalWidth  = Float(plan.width)
//    data.originalHeight = Float(plan.height)
//
//    for layer in plan.layers {
//      switch layer.format {
//        case .grid: setGridTo(data: &data, grid: layer.grid)
//        case .objects: setObjectsTo(data: &data, objects: layer.objects)
//      }
//    }
//
//    if (drawingLayer.processData(inputData: data) { [weak self] error in
//      if error.type == .success { self?.drawingLayer.run(); callback() }
//    }) { return true }
//    else { return false }
//  }
//  //-----------------------------------------------------------------------------------
//
//  private func setGridTo(data: inout SPlanData, grid: IGrid?) {
//    guard let grid_ = grid?.filling, let step = grid?.step  else { return }
//
//    data.gridStep = Float(step)
//    data.grid     = grid_.map { (cellXPos: $0.x, cellYPos: $0.y) }
//  }
//  //-----------------------------------------------------------------------------------
//
//  private func setObjectsTo(data: inout SPlanData, objects: [String: IObject]) {
//    guard !objects.isEmpty else { return }
//
//    data.objects += objects
//      .filter { $0.value.type != .beacon }// for now ignore beacons
//      .map { object in
//        var originalObject: SOriginalObject = SOriginalObject()
//
//        originalObject.polygon = object.value.coordinates.map { SVector2d(x: Float($0.x), y: Float($0.y)) }
//        originalObject.type    = object.value.type.rawValue//
//        originalObject.id      = object.value.object_id
//        originalObject.color   = EnSMObjectsColorsRGB.color(originalObject.type)
//
//        var add = true
//
//        for type in data.objectTypes {
//          if type.rawValue == object.value.type.rawValue { add = false; break }
//        }
//
//        if add { data.objectTypes.append(cSMObjectsTypes(rawValue: object.value.type.rawValue)!) }
//
//        return originalObject
//    }
//  }
//  //-----------------------------------------------------------------------------------
//
//  private func showMarker(withType type: IndTypes.MarkersTypes, hide: Bool) {
//    switch type {
//      case .beaconMarker: print("beakon")
//      case .locationMarker: drawingLayer.polygonsToDraw.vertexesData.showLocationMarker = !hide//drawingLayer.userLocation.showLocationMarker(hide)
//      case .lookMarker: drawingLayer.polygonsToDraw.vertexesData.showLookMarker = !hide//drawingLayer.userLocation.showLookMarker(hide)
//      case .realPosMarker: drawingLayer.polygonsToDraw.vertexesData.showRealPosMarker = !hide//drawingLayer.userLocation.showRealPositionMarker(hide)
//    }
//  }
//  //-----------------------------------------------------------------------------------
}


