//
//  HomeViewController.swift
//  Metal
//
//  Created by JiangWang on 2019/8/13.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit
import AVKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private let sessionQueue = SessionSerialQueue()
    private var photoOutput: AVCapturePhotoOutput!
    private var currentVideoInput: AVCaptureDeviceInput!
    private let photoProccessor = PhotoCaptureProcessor()
    
    var previewView: CapturePreviewView {
        get {
            return self.view as! CapturePreviewView
        }
    }
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        button.setTitle("Capture", for: .normal)
        button.backgroundColor = .brown
        return button
    }()

    override func loadView() {
         self.view = CapturePreviewView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //setupUI
        view.addSubview(captureButton)
        captureButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottomMargin.equalTo(view.snp.bottomMargin).offset(-20)
        }
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
            self?.currentVideoInput = cameraInput
            self?.captureSession.addInput(cameraInput)
            
            //photo output
            let photoOutput = AVCapturePhotoOutput()
            self?.photoOutput = photoOutput
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


// MARK: - actions
extension HomeViewController {
    @objc func capturePhoto() {
        guard let photoConnection = self.photoOutput.connection(with: .video) else { return }
        
        var photoSettings = AVCapturePhotoSettings()
        
        // Capture HEIF photos when supported. Enable auto-flash and high-resolution photos.
        if  self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        if self.currentVideoInput.device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        
        photoSettings.isHighResolutionPhotoEnabled = true
        if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
        }

        photoSettings.isDepthDataDeliveryEnabled = self.photoOutput.isDepthDataDeliveryEnabled

        if #available(iOS 12.0, *) {
            photoSettings.isPortraitEffectsMatteDeliveryEnabled = self.photoOutput.isPortraitEffectsMatteDeliveryEnabled
        }
        photoSettings.isHighResolutionPhotoEnabled = self.photoOutput.isHighResolutionCaptureEnabled

        self.photoOutput.capturePhoto(with: photoSettings, delegate: photoProccessor)
    }
}
