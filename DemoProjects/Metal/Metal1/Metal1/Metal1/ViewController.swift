//
//  ViewController.swift
//  Metal1
//
//  Created by JiangWang on 2020/5/22.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    /// gpu representation
    var device: MTLDevice!
    
    /// metal的图层
    var metalLayer: CAMetalLayer!
    
    /// 三角形的顶点坐标
    let vertexData:[Float] = [0.0, 0.5, 1.0,
                              -0.5, -0.5, 1.0,
                              0.5, -0.5, 1.0]
    
    ///
    var vertexBuffer: MTLBuffer! = nil
    
    /// hold all of the state the render pipeline needs to refer to
    var pipelineState: MTLRenderPipelineState! = nil
    
    /// command queue
    var commandQueue: MTLCommandQueue! = nil
    
    /// timer
    var displayLink: CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()
        metalLayer.backgroundColor = UIColor.white.cgColor
        
        //配置
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.bounds
        view.layer.addSublayer(metalLayer)

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModeShared)
        
        let defaultLibrary = device.makeDefaultLibrary()
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("\(error)")
        }
        
        commandQueue = device.makeCommandQueue()
        
        displayLink = CADisplayLink(target: self, selector: #selector(renderLoopped))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    // Render pass
    func render() {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        guard let drawable = metalLayer.nextDrawable() else { return }
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(221.0/255.0, 160.0/255.0, 221.0/255.0, 1.0)
        // command buffer
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }

    @objc func renderLoopped() {
        autoreleasepool { () -> Void in
            render()
        }
    }
}

