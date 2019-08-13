//
//  HomeViewController.swift
//  Metal
//
//  Created by JiangWang on 2019/8/13.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    
    var previewView: CapturePreviewView {
        get {
            return self.view as! CapturePreviewView
        }
    }

    override func loadView() {
         self.view = CapturePreviewView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //configure
        setupSession()
        captureSession.startRunning()
    }
}

extension HomeViewController {
    func setupSession() {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        //camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera), captureSession.canAddInput(cameraInput) else { return }
        captureSession.addInput(cameraInput)
        
        //photo output
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        //preview
        previewView.videoPreviewLayer.session = self.captureSession
    }
}
