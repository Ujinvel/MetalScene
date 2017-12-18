/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * A class that organizes the interaction of nodes to draw a plan.
 */

import Metal
import MetalKit

class SMDrawingLayer: NSObject {
  //*** Rendering
  var polygonsToDraw: SMTriangle!// Provides data ready for rendering
  var metalLayer: CAMetalLayer!// Object, where everything will be drawn
  var device: MTLDevice!// References to the default MTLDevice
  
  private var sampler: MTLSamplerState!
  private lazy var depthTexture: MTLTexture = {
    let drawableSize = self.metalLayer.drawableSize
    let descriptor   = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.depth32Float, width: Int(drawableSize.width), height: Int(drawableSize.height), mipmapped: false)
    descriptor.usage = .renderTarget
    
    return self.device.makeTexture(descriptor: descriptor)!
  } ()
  private var fontTexture: MTLTexture!  
  private var pipelineState: MTLRenderPipelineState!// Object for combining shaders whis other configuration data
  private var commandQueue: MTLCommandQueue!// Ordered list of commands that I tell the GPU to execute, one at a time
  private var renderPassDescriptor: MTLRenderPassDescriptor!// Represents a collection of attachments to be used to create a concrete render command encoder
  private var timer: CADisplayLink!// Needed for function to be called every time the device screen refreshes so I can redraw the screen
  private var textureIncreaseMultiplyer: CGFloat// How many times will we increase the texture density relative to the native multiplier for the view
  private var nativeWindowScale: CGFloat// Native scale factor of the physical screen
  //private weak var drawableContainerView: MTKView?// View-container for rendering whis CAMetalLayer
  private var clearColor: MTLClearColor!// Background color fo drawing layer
  //*** Compass
  //var compass = SMCompassRotation()
  //*** View hierarchy
  var containerViewHierarchy: ContainerViewHierarchy!
  
  var inputData: SPlanData?
  var containerView: ContainerViewHierarchy { get { return containerViewHierarchy } }
  
  // MARK: - Constructor
  
  public init(containerView: UIView, textureIncreaseMultiplyer: CGFloat) throws { guard MTLCreateSystemDefaultDevice() != nil else { throw SError(type: .defaultDevice, description: String(describing: cErrorType.getErrorDescription(.defaultDevice))) }
    
    device                         = MTLCreateSystemDefaultDevice()!
    self.textureIncreaseMultiplyer = textureIncreaseMultiplyer
    self.renderPassDescriptor      = MTLRenderPassDescriptor()
    
    if let scale = containerView.window?.screen.nativeScale {
      nativeWindowScale = scale
    } else { nativeWindowScale = 1 }
    
    super.init()
    
    try setup(baseContainerView: containerView)
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Setup
  
  private func setup(baseContainerView: UIView) throws {
    // Make the background transparent
    let clear  = EnSMObjectsColorsRGB.hexToRGB(cSMObjectsColors.clear, alpha: 0)
    clearColor = MTLClearColor(red: Double(clear.red),
                               green: Double(clear.green),
                               blue: Double(clear.blue),
                               alpha: Double(clear.alpha))
    
    setupMetalLayer(view: baseContainerView)
    
    try setupPipeline()
  }
  //-----------------------------------------------------------------------------------
  
  //*** Creating and configure CAMetalLayer
  private func setupMetalLayer(view: UIView) {
    containerViewHierarchy = SMViewHierarchyPreparing.prepareViewHierarchy(mainContainerView: view)
    
    setGestures()
    
    metalLayer                 = CAMetalLayer()
    metalLayer.device          = device
    metalLayer.pixelFormat     = .bgra8Unorm// 8 bytes for Blue, Green, Red, and Alpha, in that order — with normalized values between 0 and 1
    metalLayer.framebufferOnly = true// Apple encourages to set framebufferOnly to true for performance reasons unless you need to sample from the textures generated for this layer, or if you need to enable compute kernels on the layer drawable texture
    
    // Set isOpaque to false so that the alpha channel will work when the color is set
    metalLayer.isOpaque                                     = false
    containerViewHierarchy.drawContainerView.layer.isOpaque = false
    
    
    setMetalLayerDrawable(darwableContainerViewFrame: view.frame)
    containerViewHierarchy.drawContainerView.layer.addSublayer(metalLayer)
    
    let samplerDescriptor          = MTLSamplerDescriptor()
    samplerDescriptor.minFilter    = .nearest
    samplerDescriptor.magFilter    = .linear
    samplerDescriptor.sAddressMode = .clampToZero
    samplerDescriptor.tAddressMode = .clampToZero
    
    sampler = metalLayer.device!.makeSamplerState(descriptor: samplerDescriptor)
  }
  //-----------------------------------------------------------------------------------
  
  //*** Setting of drawing boundaries and density of points
  func setMetalLayerDrawable(darwableContainerViewFrame: CGRect) {
    metalLayer.frame  = CGRect(x: 0, y: 0, width: darwableContainerViewFrame.width, height: darwableContainerViewFrame.height)// Area of ​​drawing - the container view size
    
    // Increase the density of points
    let scale     = nativeWindowScale * textureIncreaseMultiplyer// Gets the display nativeScale for the device and multiply by the density coefficient
    let layerSize = darwableContainerViewFrame.size
    
    // Applies the scale to increase the drawable texture size
    containerViewHierarchy.drawContainerView.contentScaleFactor = scale
    metalLayer.drawableSize                                     = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
  }
  //-----------------------------------------------------------------------------------
  
  //*** Creating and configure object, that combine shaders
  private func setupPipeline() throws {
    // Shaders are precompiled. To get to the already compiled shaders, use MTLLibrary
    //    guard let defaultLibrary = device?.makeDefaultLibrary() else { throw SError(type: .shaders,
    //                                                                                description: String(describing: cErrorType.getErrorDescription(.shaders))) }
    do {
      guard let defaultLibrary = try device?.makeDefaultLibrary(bundle: Bundle.init(for: SMDrawingLayer.self)) else {
        throw SError(type: .shaders, description: String(describing: cErrorType.getErrorDescription(.shaders)))
      }
      
      // Set up render pipeline configuration. It contains the shaders, and the pixel format for the color attachment — i.e.
      let pipelineStateDescriptor              = MTLRenderPipelineDescriptor()
      pipelineStateDescriptor.vertexFunction   = defaultLibrary.makeFunction(name: cShaders.vertex)// Vertex Shader
      pipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: cShaders.fragment)// Fragment Shader
      
      pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
      
      guard let colorElement = pipelineStateDescriptor.colorAttachments[0] else {
        throw SError(type: .renderPipelineColor, description: String(describing: cErrorType.getErrorDescription(.renderPipelineColor)))
      }
      
      colorElement.pixelFormat = .bgra8Unorm// Same as in CAMetalLayer
      // alpha blending
      colorElement.isBlendingEnabled           = true
      //colorElement.writeMask                   = .all
      colorElement.rgbBlendOperation           = .add
      colorElement.alphaBlendOperation         = .add
      colorElement.sourceRGBBlendFactor        = .sourceAlpha
      colorElement.sourceAlphaBlendFactor      = .sourceAlpha
      colorElement.destinationRGBBlendFactor   = .oneMinusSourceAlpha
      colorElement.destinationAlphaBlendFactor = .oneMinusSourceAlpha
      
      do {
        pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
      } catch(let error) { throw error }
    } catch {
      throw SError(type: .shaders,
                   description: String(describing: cErrorType.getErrorDescription(.shaders)))
    }
  }
  //-----------------------------------------------------------------------------------
  
  // MARK: - Render runloop
  
  //*** Starting rendering
  public func run() {
    let fontAtlas   = SMFontAtlasBuild.getFontAtlasWhisFontName("HoeflerText-Regular", andSize: 20)
    let textureDesc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r8Unorm, width: 2048, height: 2048, mipmapped: false)
    
    textureDesc.usage = .shaderRead
    let region        = MTLRegionMake2D(0, 0, 2048, 2048)
    fontTexture       = device.makeTexture(descriptor: textureDesc)
    let data          = fontAtlas!.textureData! as NSData
    
    fontTexture.replace(region: region, mipmapLevel: 0, withBytes: data.bytes, bytesPerRow: 2048)
    
    commandQueue = device.makeCommandQueue()
    timer        = CADisplayLink(target: self, selector: #selector(renderLoop(displayLink:)))
    
    timer.add(to: .main, forMode: .defaultRunLoopMode)
  }
  //-----------------------------------------------------------------------------------
  
  //*** Called when the screen is updated
  @objc private func renderLoop(displayLink: CADisplayLink) {
    autoreleasepool {
      guard let drawable = metalLayer?.nextDrawable() else { return }
      
      if depthTexture.width != Int(metalLayer!.drawableSize.width) || depthTexture.height != Int(metalLayer!.drawableSize.height) {
        let drawableSize = self.metalLayer.drawableSize
        let descriptor   = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.depth32Float, width: Int(drawableSize.width), height: Int(drawableSize.height), mipmapped: false)
        descriptor.usage = .renderTarget
        
        depthTexture = device.makeTexture(descriptor: descriptor)!
      }
      
      renderPassDescriptor = MTLRenderPassDescriptor()
      
      polygonsToDraw.render(commandQueue: commandQueue,
                            pipelineState: pipelineState,
                            renderPassDescriptor: renderPassDescriptor,
                            depthTexture: depthTexture,
                            fontTexture: fontTexture,
                            sampler: sampler,
                            drawable: drawable,
                            clearColor: clearColor)
    }
  }
  //-----------------------------------------------------------------------------------
}

