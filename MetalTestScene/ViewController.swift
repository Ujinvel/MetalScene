/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var drawingView: SMDrawingView!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  
    var data = SPlanData()
    
    data.originalWidth  = 4000
    data.originalHeight = 5000
    data.gridStep       = 50
    
    var originObject     = SOriginalObject()
    originObject.polygon = [SVector2d(x: 0, y: 0), SVector2d(x: 3000, y: 0), SVector2d(x: 0, y: 3000)]
    originObject.type    = 1012
    originObject.id      = 1111
    originObject.color   = EnSMObjectsColorsRGB.color(1012)
    
    data.objects.append(originObject)
    
    drawingView.process(data: data)
  }
  //-----------------------------------------------------------------------------------
}

