/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Base class for element to draw(source code: https://developer.apple.com/documentation/metal/hello_triangle ,
 *                                             https://developer.apple.com/library/content/documentation/Miscellaneous/Conceptual/MetalProgrammingGuide/Render-Ctx/Render-Ctx.html ,
 *                                             https://www.raywenderlich.com/90592/liquidfun-tutorial-2 ,
 *                                             https://www.raywenderlich.com/146414/metal-tutorial-swift-3-part-1-getting-started ,
 *                                             https://www.raywenderlich.com/146416/metal-tutorial-swift-3-part-2-moving-3d )
 */

import Metal
import MetalKit
import QuartzCore

class SMNode {
  weak var device: MTLDevice!
  private var vertexData: [Float] = []
  private let layerSize: CGSize!
  private var vertexCount: Int = 0
  private var vertexBuffer: MTLBuffer!
  private var uniformBuffer: MTLBuffer!
  private var planScale: Float = 1
  private var planScaleCenter: CGPoint = CGPoint(x: -1, y: -1)
  private lazy var avaliableResourcesSemaphore = { DispatchSemaphore(value: 2) }()// Using the semaphore to keep track of how many buffers are currently in use on the GPU
  
  var depthTexture: MTLTexture!
  var fontTexture: MTLTexture!
  
// MARK: - Constructor
  
  init(device: MTLDevice, layerSize: CGSize) {
    self.device    = device
    self.layerSize = layerSize
  }
  //-----------------------------------------------------------------------------------
  
  deinit {
    for _ in 0...1 { avaliableResourcesSemaphore.signal() }
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Buffers setup
  
  //*** Сreate global arrays of shaders
  @discardableResult func createBuffers(vertices: [SVertex], refreshUniform: Bool = true) -> SError {
    guard !vertices.isEmpty else { return SError(type: .emtyVertexes, description: String(describing: cErrorType.getErrorDescription(.emtyVertexes))) }
    
    // Vertex buffer
    self.vertexCount = vertices.count
    vertexData       = vertices.flatMap { $0.floatBuffer() }
    let dataSize     = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    vertexBuffer     = device.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModeShared)
    
    // Uniform buffer
    if refreshUniform == true { refreshUniformBuffer(layerSize: layerSize) }
    
    
    return SError(type: .success, description: String(describing: cErrorType.getErrorDescription(.success)))
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Normalization
  
  //*** Matrix of normalization. Taken from openGL source
  private func makeOrthographicMatrix(left: Float, right: Float, bottom: Float, top: Float, near: Float = -1, far: Float = 1) -> [Float] {
    let ral = right + left
    let rsl = right - left
    let tab = top + bottom
    let tsb = top - bottom
    let fan = far + near
    let fsn = far - near
    
    return [2.0 / rsl, 0.0, 0.0, 0.0,
            0.0, 2.0 / tsb, 0.0, 0.0,
            0.0, 0.0, -2.0 / fsn, 0.0,
            -ral / rsl, -tab / tsb, -fan / fsn, 1.0]
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Input data upodate
  
  func updateScale(_ newScale: Float, center: CGPoint) {
    planScaleCenter = center
    planScale       *= newScale
    
    if planScale < 1 { planScale = 1 }
  }
  //-----------------------------------------------------------------------------------
  
  func refreshVertixes(vertixes: [SVertex]) {
    let vertexData = vertixes.flatMap { $0.floatBuffer() }
    let dataSize   = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    
    vertexBuffer = (device?.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModeShared))!
  }
  //-----------------------------------------------------------------------------------
  
  //*** Buffer for transferring the normalization matrix to the shader
  func refreshUniformBuffer(layerSize: CGSize?,
                            userLocation: CGPoint = CGPoint(x: 0, y: 0),
                            scale: Float = 1,
                            scalePoint: CGPoint = CGPoint(x: -1, y: -1)) {
    guard let device = device else { fatalError(cErrorDesc.emptyDevice) }
    
//    var scalePoint_ = scalePoint
//    if planScaleCenter.x > 0 {
//      let newX = Int((planScaleCenter.x - scalePoint.x) / CGFloat(planScale))
//      let newY = Int((planScaleCenter.y - scalePoint.y) / CGFloat(planScale))
//
//      scalePoint_.x = planScaleCenter.x - CGFloat(newX)
//      scalePoint_.y = planScaleCenter.y - CGFloat(newY)
//    }
    
    var size: CGSize = self.layerSize
    
    if layerSize != nil { size = layerSize! }
    
    let screenWidth  = Float(size.width)
    let screenHeight = Float(size.height)
    
    //let ndcMatrix    = matrix_orthographic_projection(left: 0, right: screenWidth, top: 0, bottom: screenHeight)
//    let ndcMatrix    = makeOrthographicMatrix(left: 0, right: screenWidth,
//                                              bottom: 0, top: screenHeight,
//                                              near: -1, far: 1)
    let ndcMatrix    = makeOrthographicMatrix(left: 0, right: screenWidth,
                                              bottom: screenHeight, top: 0)
    
    let floatSize             = MemoryLayout<Float>.size
    let float4x4ByteAlignment = floatSize * 4
    let float4x4Size          = floatSize * float4x4ByteAlignment
    let paddingBytesSize      = float4x4ByteAlignment - floatSize * 2 - floatSize * 2 + floatSize * 3
    let uniformsStructSize    = float4x4Size + paddingBytesSize + floatSize * 2 + floatSize * 2 + floatSize * 3
    
    uniformBuffer = device.makeBuffer(length: uniformsStructSize, options: .storageModeShared)!
    
    let bufferPointer           = uniformBuffer.contents()
    let userLocation: [Float]   = [Float(userLocation.x), Float(userLocation.y)]
    let translation: [Float]    = [10, 15]
    let scaleFromPoint: [Float] = [/*planScale * */scale, Float(scalePoint.x), Float(scalePoint.y)]// scale, point.x, point.y
    
    memcpy(bufferPointer, ndcMatrix, float4x4Size)
    memcpy(bufferPointer + float4x4Size, userLocation, floatSize * 2)
    memcpy(bufferPointer + float4x4Size + floatSize * 2, translation, floatSize * 2)
    memcpy(bufferPointer + float4x4Size + floatSize * 2 + floatSize * 2, scaleFromPoint, floatSize * 3)
  }
  //-----------------------------------------------------------------------------------
  
// MARK: - Render
  
  func render(commandQueue: MTLCommandQueue,
              pipelineState: MTLRenderPipelineState,
              renderPassDescriptor: MTLRenderPassDescriptor,
              depthTexture: MTLTexture,
              fontTexture: MTLTexture,
              sampler: MTLSamplerState,
              drawable: CAMetalDrawable,
              clearColor: MTLClearColor) {
    // Every time i need to access a buffer, i’ll ask the semaphore to “wait”. If a buffer is available, i’ll continue running as usual (but decrement the count on the semaphore).
    // If all buffers are in use, this will block the thread until one becomes available.
    guard avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture) == .success else { return }
    guard let colorElement = renderPassDescriptor.colorAttachments[0] else { fatalError(cErrorDesc.renderPipelineColor) }
    
    renderPassDescriptor.depthAttachment.texture     = depthTexture
    renderPassDescriptor.depthAttachment.loadAction  = .clear
    renderPassDescriptor.depthAttachment.storeAction = .store
    renderPassDescriptor.depthAttachment.clearDepth  = 1.0
    
    colorElement.clearColor  = clearColor// Background color
    colorElement.texture     = drawable.texture
    colorElement.loadAction  = .clear// Each time we clean and redraw the scene again
    colorElement.storeAction = .store
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    
//    renderEncoder?.setFrontFacing(.counterClockwise)
//    renderEncoder?.setCullMode(.none)
    renderEncoder?.setRenderPipelineState(pipelineState)
    
    renderEncoder?.setFragmentTexture(fontTexture, index: 0)
    renderEncoder?.setFragmentSamplerState(sampler, index: 0)
    
    // Set it in the order in which it will accept the shader
    renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
    
    renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
    //    renderEncoder.drawPrimitives(type: .triangle,
    //                                 vertexStart: 0,
    //                                 vertexCount: vertexCount,
    //                                 instanceCount: 1)
    renderEncoder?.endEncoding()
    commandBuffer?.present(drawable)
    // GPU has completed rendering the frame and is done using the contents of any buffers previously encoded on the CPU for that frame.
    // Signal the semaphore and allow the CPU to proceed and construct the next frame.
    commandBuffer?.addCompletedHandler { _ in self.avaliableResourcesSemaphore.signal() }
    
    commandBuffer?.commit()
  }
  //-----------------------------------------------------------------------------------
}

