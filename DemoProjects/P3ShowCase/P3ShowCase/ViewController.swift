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
//    private lazy var wideColorFilter: CIFilter = CIFilter(name: "WideColor")!
    
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
        metalView.colorPixelFormat = .bgr10_xr
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
        
        // metal initializaiton
        setupDrawImageWithMetal()
    }
    
    func showWideColorFilteredImage() {
        /*
        wideColorFilter.setValue(CIImage(image: testImage), forKey: kCIInputImageKey)
        guard let output = wideColorFilter.outputImage else { return }
        let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)
        guard let cgImage = self.ciContext.createCGImage(output,
                                                         from: output.extent,
                                                         format: CIFormat.RGBAh,
                                                         colorSpace: colorSpace) else { return }
        imageView.image = UIImage(cgImage: cgImage)
         */
    }
    
    func setupDrawImageWithMetal() {
        let textureLoader = MTKTextureLoader(device: device)
        
        var image = testImage
        // redraw image
//        image = redrawImage(image)
        image = ImageConvertor.convertP3Image(image!)

        imageTexture = try? textureLoader.newTexture(cgImage: (image?.cgImage)!, options: nil)
        let vertexes: [VertexData] = [
            VertexData(position: vector_float3(-0.5, -1, 0), textCoord: vector_float2(0, 1)),
            VertexData(position: vector_float3(-0.5, 1, 0), textCoord: vector_float2(0, 0)),
            VertexData(position: vector_float3(0.5, -1, 0), textCoord: vector_float2(1, 1)),
            VertexData(position: vector_float3(0.5, 1, 0), textCoord: vector_float2(1, 0))
        ]
        let vertexesBytes = MemoryLayout.size(ofValue: vertexes[0]) * vertexes.count
        vetexesBuffer = device.makeBuffer(bytes: vertexes, length: vertexesBytes, options: .storageModeShared)
        let indexes: [UInt16] = [
            0, 1, 2,
            2, 3, 1
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
              let rps = renderPipelineState,
              let vb = vetexesBuffer,
              let ib = indexesBuffer,
              let ft = imageTexture else { return }

        guard let drawable = view.currentDrawable else { return }
        let rpd = MTLRenderPassDescriptor()
        rpd.colorAttachments[0].texture = drawable.texture
        rpd.colorAttachments[0].loadAction = .clear
        rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)

        let cmdBuffer = queue.makeCommandBuffer()
        let renderEncoder = cmdBuffer?.makeRenderCommandEncoder(descriptor: rpd)
        renderEncoder?.setRenderPipelineState(rps)
        renderEncoder?.setVertexBuffer(vb, offset: 0, index: 0)
        renderEncoder?.setFragmentTexture(ft, index: 0)
        renderEncoder?.drawIndexedPrimitives(type: .triangleStrip, indexCount: 6, indexType: .uint16, indexBuffer: ib, indexBufferOffset: 0)
        renderEncoder?.endEncoding()
        
        cmdBuffer?.present(drawable)
        
        cmdBuffer?.commit()
    }
}


extension ViewController {
    
    /*
    func redrawImage(_ image: UIImage?) -> UIImage? {
        guard let img = image else { return nil }
        var ret: UIImage? = img
        
        let size = CGSize(width: img.size.width * img.scale, height: img.size.height * img.scale)
        // mix draw
        /*
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
 */
//        guard let cgImage = img.cgImage,
//              let colorSpace = img.cgImage?.colorSpace else { return nil }
        guard let cgImage = img.cgImage else { return nil }
              
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        let w = Int(size.width)
        let h = Int(size.height)
        pixelData.withUnsafeMutableBytes { pointer in
            guard let colorSpace = CGColorSpace(name: CGColorSpace.displayP3),
                  let context = CGContext(data: pointer.baseAddress,
                                          width: Int(size.width),
                                          height: Int(size.height),
                                          bitsPerComponent: 8,
                                          bytesPerRow: 4 * Int(size.width),
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else { return }
            
            // draw
            context.setBlendMode(.normal)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            // premultiplied => non-premultiplied
            let count = w * h
            for idx in 0..<count {
                // r
                let r = pointer.load(fromByteOffset: idx * 4, as: UInt8.self)
                let g = pointer.load(fromByteOffset: idx * 4 + 1, as: UInt8.self)
                let b = pointer.load(fromByteOffset: idx * 4 + 2, as: UInt8.self)
//                let a = pointer.load(fromByteOffset: idx * 4 + 3, as: UInt8.self)
                
                let fr = r.toColorFloat()
                let fg = g.toColorFloat()
                let fb = b.toColorFloat()
//                let fa = a.toColorFloat()
                
//                let rgb = toSRGB(SIMD3<Float>(fr, fg, fb))
                
                pointer.storeBytes(of: rgb.x.toColorUint(), toByteOffset: idx * 4, as: UInt8.self)
                pointer.storeBytes(of: rgb.y.toColorUint(), toByteOffset: idx * 4 + 1, as: UInt8.self)
                pointer.storeBytes(of: rgb.z.toColorUint(), toByteOffset: idx * 4 + 2, as: UInt8.self)
            }
//            unsigned char* _p = _rgba->imageData();
            ret = UIImage(cgImage: context.makeImage()!)
        }

        print(pixelData) // prints [255, 255, 255, 255]
        /*
        CGContextSetBlendMode(_context, kCGBlendModeNormal);
        
        assert( NULL != _context );
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (image.imageOrientation)
        {
            case UIImageOrientationUp:
                break;
            case UIImageOrientationDown:          // 180 deg rotation
                transform = CGAffineTransformTranslate(transform, width, height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
            case UIImageOrientationLeft:          // 90 deg CCW
                transform = CGAffineTransformTranslate(transform, width, 0.0f);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
            case UIImageOrientationRight:         // 90 deg CW
                transform = CGAffineTransformTranslate(transform, 0.0f, height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
                transform = CGAffineTransformTranslate(transform, width, 0.0f);
                transform = CGAffineTransformScale(transform, -1.f, 1.f);
                break;
            case UIImageOrientationDownMirrored:  // horizontal flip
                transform = CGAffineTransformTranslate(transform, width, height);
                transform = CGAffineTransformRotate(transform, M_PI);
                transform = CGAffineTransformTranslate(transform, width, 0.0f);
                transform = CGAffineTransformScale(transform, -1.f, 1.f);
                break;
            case UIImageOrientationLeftMirrored:  // vertical flip
                transform = CGAffineTransformTranslate(transform, width, 0.0f);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                transform = CGAffineTransformTranslate(transform, 0.0f, height);
                transform = CGAffineTransformScale(transform, 1.f, -1.f);
                break;
            case UIImageOrientationRightMirrored: // vertical flip
                transform = CGAffineTransformTranslate(transform, width, 0.0f);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                transform = CGAffineTransformTranslate(transform, 0.0f, height);
                transform = CGAffineTransformScale(transform, 1.f, -1.f);
                break;
            default:
                break;
        }
        
        CGContextConcatCTM(_context, transform);
        
        CGRect _rect = CGRectMake(0, 0, width, height);
        
        switch (image.imageOrientation)
        {
            case UIImageOrientationLeft:          // 90 deg CCW
            case UIImageOrientationRight:         // 90 deg CW
            case UIImageOrientationLeftMirrored:  // vertical flip
            case UIImageOrientationRightMirrored: // vertical flip
            {
                _rect = CGRectMake(0, 0, height, width);
            }
                break;
            default:
                break;
        }
        
        CGImageRef _imageRef = image.CGImage;
        CGContextDrawImage(_context, _rect, _imageRef);
        
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(_context);

        // premultiplied => non-premultiplied
        size_t _count = _rgba->width() * _rgba->height();
        unsigned char* _p = _rgba->imageData();

        for (size_t i = 0;  i < _count; ++ i)
        {
            if (0 == *(_p + 3) || 1 == *(_p + 3))
            {
                _p += 4;
            }
            else
            {
                float _a = ONE / U82F(*(_p + 3));
                // R
                *_p = F2U8(U82F(*_p) * _a);
                ++_p;
                // G
                *_p = F2U8(U82F(*_p) * _a);
                ++_p;
                // B
                *_p = F2U8(U82F(*_p) * _a);
                ++_p;
                // Skip Alpha
                ++_p;
            }
        }
 */
        
        return ret
    }
 
 */
    
    
}



extension UInt8 {
    func toColorFloat() -> Float {
        return Float(self)/255.0
    }
}

extension Float {
    func toColorUint() -> UInt8 {
        return max(0, min(255, UInt8(self * 255.0 + 0.5)))
    }
}
