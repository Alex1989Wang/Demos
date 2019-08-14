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
    private let sessionQueue = SessionSerialQueue()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }
}

extension HomeViewController {
    private struct QueueIdentity {
        let label: String!
    }
    
    func setupSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession.beginConfiguration()
            defer { self?.captureSession.commitConfiguration() }
            
            //camera
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            guard let cameraInput = try? AVCaptureDeviceInput(device: camera), (self?.captureSession.canAddInput(cameraInput) ?? false) else { return }
            self?.captureSession.addInput(cameraInput)
            
            //photo output
            let photoOutput = AVCapturePhotoOutput()
            guard (self?.captureSession.canAddOutput(photoOutput) ?? false) else { return }
            self?.captureSession.sessionPreset = .photo
            self?.captureSession.addOutput(photoOutput)
        }
        //preview
        previewView.videoPreviewLayer.session = self.captureSession
    }
    
    func startSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}
