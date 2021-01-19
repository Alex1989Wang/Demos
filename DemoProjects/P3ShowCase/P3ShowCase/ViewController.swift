//
//  ViewController.swift
//  P3ShowCase
//
//  Created by JiangWang on 2021/1/19.
//

import MetalKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var metalView: MTKView!
    @IBOutlet weak var wideColorFilterSwitch: UISwitch!
    
    // MARK: Core Image
    private lazy var wideColorFilter: CIFilter = CIFilter(name: "WideColor")!
    
    private lazy var ciContext: CIContext = {
        let wideColorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!
        let floatPixelFormat = NSNumber(value: CIFormat.RGBAh.rawValue)
        var options = [CIContextOption: Any]()
        options[.workingColorSpace] = wideColorSpace
        options[.workingFormat] = floatPixelFormat
        return CIContext(options: options)
    }()
    
    private var testImage: UIImage!
    
    private lazy var device = MTLCreateSystemDefaultDevice()!
    private lazy var library = device.makeDefaultLibrary()
    private lazy var cmdQueue = device.makeCommandQueue()
    private var renderPipelineState: MTLRenderPipelineState?
    private var imageTexture: MTLTexture?
    private var vetexesBuffer: MTLBuffer?
    private var indexesBuffer: MTLBuffer?
    
    private var displayLink: CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFit
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressGesture)
        
        wideColorFilterSwitch.isOn = false
        metalView.delegate = self
        metalView.device = device
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.enableSetNeedsDisplay = true
        
        do {
            try WideColorFilter.setup()
        } catch {
            print("Filter creation failed.")
        }
        setupInitialContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayLink = CADisplayLink(target: self, selector: #selector(drawMetalContent))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func setupInitialContents() {
        /*
         test images
         
         "Baby.jpg"
         "android_p3.PNG"
         "Iceland.jpg"
         "Italy 1.jpg"
         "Italy 2.jpg"
         */
//        let imageFile = "Baby.jpg" as NSString
        let imageFile = "android_p3.PNG" as NSString
//        let imageFile = "Iceland.jpg" as NSString
//        let imageFile = "Italy 1.jpg" as NSString
//        let imageFile = "Italy 2.jpg" as NSString
        let name = imageFile.deletingPathExtension
        let iExtension = imageFile.pathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: iExtension) else { return }
        testImage = UIImage(contentsOfFile: url.path)

        // show wide color filtered image
        showWideColorFilteredImage()
    }
    
    func showWideColorFilteredImage() {
        wideColorFilter.setValue(CIImage(image: testImage), forKey: kCIInputImageKey)
        guard let output = wideColorFilter.outputImage else { return }
        let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)
        guard let cgImage = self.ciContext.createCGImage(output,
                                                         from: output.extent,
                                                         format: CIFormat.RGBAh,
                                                         colorSpace: colorSpace) else { return }
        imageView.image = UIImage(cgImage: cgImage)
    }
    
    func setupDrawImageWithMetal() {
        let textureLoader = MTKTextureLoader(device: device)
        imageTexture = try? textureLoader.newTexture(cgImage: self.testImage.cgImage!, options: nil)
        let vertexes: [VertexData] = [
            VertexData(position: vector_float3(-0.5, -1, 0), textCoord: vector_float2(0, 1)),
            VertexData(position: vector_float3(-0.5, 1, 0), textCoord: vector_float2(0, 0)),
            VertexData(position: vector_float3(0.5, -1, 0), textCoord: vector_float2(1, 1)),
            VertexData(position: vector_float3(0.5, 1, 0), textCoord: vector_float2(1, 0))
        ]
        let vertexesBytes = MemoryLayout.size(ofValue: vertexes[0]) * vertexes.count
        vetexesBuffer = device.makeBuffer(bytes: vertexes, length: vertexesBytes, options: .storageModeShared)
        let indexes: [Int] = [
            0, 1, 2,
            2, 3, 0
        ]
        let indexBytes = MemoryLayout.size(ofValue: indexes[0]) * indexes.count
        indexesBuffer = device.makeBuffer(bytes: indexes, length: indexBytes, options: .storageModeShared)
        
        // render pipeline state
        let rpsd = MTLRenderPipelineDescriptor()
        rpsd.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        rpsd.fragmentFunction = library?.makeFunction(name: "pass_through_fragment")
        rpsd.vertexFunction = library?.makeFunction(name: "pass_through_vertex")
        renderPipelineState = try? device.makeRenderPipelineState(descriptor: rpsd)
    }
}

extension ViewController {
    @objc func didTapImageView(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began: fallthrough
        case .changed:
            self.imageView.image = testImage
        default:
            showWideColorFilteredImage()
        }
    }
    
    @objc func drawMetalContent() {
        metalView.setNeedsDisplay()
    }
}

extension ViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("does nothing")
    }
    
    func draw(in view: MTKView) {
        
        guard let queue = cmdQueue,
              let rps = renderPipelineState else { return }

        guard let drawable = view.currentDrawable else { return }
        let rpd = MTLRenderPassDescriptor()
        rpd.colorAttachments[0].texture = drawable.texture
        rpd.colorAttachments[0].loadAction = .clear
        rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        rpd.colorAttachments[0].storeAction = .store
        
        let cmdBuffer = queue.makeCommandBuffer()
        let renderEncoder = cmdBuffer?.makeRenderCommandEncoder(descriptor: rpd)
        renderEncoder?.setRenderPipelineState(rps)
        
        renderEncoder
    }
}

