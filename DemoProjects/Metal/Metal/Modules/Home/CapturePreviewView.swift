//
//  CapturePreviewView.swift
//  Metal
//
//  Created by JiangWang on 2019/8/13.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit
import AVFoundation

class CapturePreviewView: UIView {

    // Use AVCaptureVideoPreviewLayer as the underlying layer
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
