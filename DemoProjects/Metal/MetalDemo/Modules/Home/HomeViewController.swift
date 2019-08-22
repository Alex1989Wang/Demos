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
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var currentVideoInput: AVCaptureDeviceInput!
    private let photoProccessor = PhotoCaptureProcessor()
    private let videoBufferDelegate = VideoSampleBufferDelegate()
    
//    var previewView: CapturePreviewView {
//        get {
//            return self.view as! CapturePreviewView
//        }
//    }
    
        var previewView: PreviewMetalView {
            get {
                return self.view as! PreviewMetalView
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
        self.view = PreviewMetalView(frame: .zero, device: nil)
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
            guard let sSelf = self else { return }
            
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
            
            //video output
            let videoOutput = AVCaptureVideoDataOutput()
            self?.videoDataOutput = videoOutput
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoOutput.setSampleBufferDelegate(sSelf.videoBufferDelegate, queue: sSelf.videoBufferDelegate.videoQueue)
            guard (self?.captureSession.canAddOutput(videoOutput) ?? false) else { return }
            self?.captureSession.addOutput(videoOutput)
        }

    }
    
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            //添加preview
            if let unwrappedVideoDataOutputConnection = sSelf.videoDataOutput.connection(with: .video) {
                let videoDevicePosition = sSelf.currentVideoInput.device.position
                let interfaceOrientation = UIApplication.shared.statusBarOrientation
                let rotation = PreviewMetalView.Rotation(with: interfaceOrientation,
                                                         videoOrientation: unwrappedVideoDataOutputConnection.videoOrientation,
                                                         cameraPosition: videoDevicePosition)
                sSelf.previewView.mirroring = (videoDevicePosition == .front)
                if let rotation = rotation {
                    sSelf.previewView.rotation = rotation
                }
            }
            
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
