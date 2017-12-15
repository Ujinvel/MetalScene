/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

extension SMDrawingLayer {
  //*** Refresh drawing area in real time
  public func refreshScene(newDrawableFrame: CGRect) {
    setMetalLayerDrawable(darwableContainerViewFrame: newDrawableFrame)
    polygonsToDraw.refreshVertixes(newDrawableFrame: newDrawableFrame)
    polygonsToDraw.refreshUniformBuffer(layerSize: newDrawableFrame.size)
  }
  //-----------------------------------------------------------------------------------
  
  func processData(inputData: SPlanData, success: @escaping ((SError) -> Void)) -> Bool {
    guard self.polygonsToDraw == nil || (self.polygonsToDraw != nil && !self.polygonsToDraw.isDataProcessing) else { return false }
    
    self.inputData = inputData
    
    if polygonsToDraw == nil {
      self.polygonsToDraw = SMTriangle(device: self.device,
                                       drawLayerFrame: self.metalLayer.frame,
                                       data: inputData)
    } else { polygonsToDraw.setNewData(data: inputData) }
    
    DispatchQueue.global().async {// Triangulation and casting the array of shaders to the ready-to-render form
      self.polygonsToDraw.prepareObjectsForDraw() { error in DispatchQueue.main.async { success(error) } }
    }
    
    return true
  }
  //-----------------------------------------------------------------------------------
  
  public func isDataProcessing() -> Bool {
    guard polygonsToDraw != nil else { return true }
    
    return polygonsToDraw!.isDataProcessing
  }
  //-----------------------------------------------------------------------------------
}
