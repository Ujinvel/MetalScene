/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

import UIKit

extension SMDrawingLayer: UIScrollViewDelegate {
  
  // MARK: - Rotation
  
  func rotateToRadAngle(_ radAngle: CGFloat) {
    UIView.animate(withDuration: cZoomAndRotation.rotationAnimDur, delay: 0, options: .allowUserInteraction, animations: ({
      self.containerView.scrollContainerView.transform = CGAffineTransform(rotationAngle: radAngle)
      
      self.containerView.scrollView.superview?.layoutIfNeeded()
    }), completion: nil)
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Zoom
  
  func setupZoom() {
    containerView.scrollView.minimumZoomScale = cZoomAndRotation.minimumZoomScale
    containerView.scrollView.maximumZoomScale = cZoomAndRotation.maximumZoomScale
    containerView.scrollView.zoomScale        = cZoomAndRotation.defZoomScale
    
    containerView.scrollView.delegate                 = self
    containerView.scrollView.isUserInteractionEnabled = true
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: UIScrollViewDelegate
  
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return containerView.drawContainerView
  }
  //-----------------------------------------------------------------------------------
  
  public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    if scrollView.zoomScale < scrollView.minimumZoomScale { scrollView.zoomScale = scrollView.minimumZoomScale }
  }
  //-----------------------------------------------------------------------------------
}

