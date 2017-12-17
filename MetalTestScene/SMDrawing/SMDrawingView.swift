/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 *
 */

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
}


