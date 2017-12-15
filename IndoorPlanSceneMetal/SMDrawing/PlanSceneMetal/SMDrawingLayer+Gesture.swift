/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */


extension SMDrawingLayer {
  func setGestures() {
    let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
    
    containerViewHierarchy.scrollContainerView.addGestureRecognizer(gesture)
  }
  //-----------------------------------------------------------------------------------
  
  @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
    if gesture.state == .began || gesture.state == .changed && gesture.numberOfTouches == 2 {
      guard let view = gesture.view else { return }
      
      let pinchCenter = gesture.location(in: view)
      
      polygonsToDraw.refreshUniformBuffer(layerSize: nil, scale: Float(gesture.scale), scalePoint: pinchCenter)
      
      print(gesture.scale)
    }
    
    if gesture.state == .ended {
      polygonsToDraw.updateScale(Float(gesture.scale), center: gesture.location(in: gesture.view))
      print("ended" + gesture.scale.description)
    }
  }
  //-----------------------------------------------------------------------------------
}
