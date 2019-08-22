//
//  PhotoCaptureProcessor.swift
//  Metal
//
//  Created by JiangWang on 2019/8/15.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import AVFoundation
import CocoaLumberjack

class PhotoCaptureProcessor: NSObject {
    
}

extension PhotoCaptureProcessor:  AVCapturePhotoCaptureDelegate {
    
    /*
     photoOutput(_:willBeginCaptureFor:) arrives first, as soon as you call capturePhoto. The resolved settings represent the actual settings that the camera will apply for the upcoming photo. AVCam uses this method only for behavior specific to Live Photos. AVCam tries to tell if the photo is a Live Photo by checking its livePhotoMovieDimensions size; if the photo is a Live Photo, AVCam increments a count to track Live Photos in progress:
     */
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        DDLogInfo("will begin capture - setting resolved:\(resolvedSettings)")
    }
    
    /******************** shutter sound ********************/
    
    /*
     photoOutput(_:willCapturePhotoFor:) arrives right after the system plays the shutter sound. AVCam uses this opportunity to flash the screen, alerting to the user that the camera captured a photo. The sample code implements this flash by animating the preview view layer’s opacity from 0 to 1.
     */
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        DDLogInfo("will capture - setting resolved:\(resolvedSettings)")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        DDLogInfo("did capture - setting resolved:\(resolvedSettings)")
    }
    
    /*
     photoOutput(_:didFinishProcessingPhoto:error:) arrives when the system finishes processing depth data and a portrait effects matte. AVCam checks for a portrait effects matte and depth metadata at this stage:
     */
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DDLogInfo("did finish process photo - photo:\(photo)")
        if let photoData = photo.fileDataRepresentation() {
            let captureImage = UIImage(data: photoData)
            DDLogInfo("captured image:\(String(describing: captureImage))")
        }
        
    }
    
    /*
     photoOutput(_:didFinishCaptureFor:error:) is the final callback, marking the end of capture for a single photo. AVCam cleans up its delegate and settings so they don’t remain for subsequent photo captures:
     */
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        DDLogInfo("did finish capture - setting resolved:\(resolvedSettings)")
    }
    
    /******************** live photos ********************/
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
    }
}
