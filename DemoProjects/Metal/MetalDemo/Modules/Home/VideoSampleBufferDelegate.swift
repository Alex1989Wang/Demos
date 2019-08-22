//
//  VideoSampleBufferDelegate.swift
//  Metal
//
//  Created by JiangWang on 2019/8/22.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit
import AVKit

class VideoSampleBufferDelegate: NSObject {
    private let processQueue = SessionSerialQueue()
    
    var videoQueue: DispatchQueue {
        get {
            return processQueue.queue
        }
    }
}

extension VideoSampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /*!
     @method captureOutput:didOutputSampleBuffer:fromConnection:
     @abstract
     Called whenever an AVCaptureVideoDataOutput instance outputs a new video frame.
     
     @param output
     The AVCaptureVideoDataOutput instance that output the frame.
     @param sampleBuffer
     A CMSampleBuffer object containing the video frame data and additional information about the frame, such as its format and presentation time.
     @param connection
     The AVCaptureConnection from which the video was received.
     
     @discussion
     Delegates receive this message whenever the output captures and outputs a new video frame, decoding or re-encoding it as specified by its videoSettings property. Delegates can use the provided video frame in conjunction with other APIs for further processing. This method will be called on the dispatch queue specified by the output's sampleBufferCallbackQueue property. This method is called periodically, so it must be efficient to prevent capture performance problems, including dropped frames.
     
     Clients that need to reference the CMSampleBuffer object outside of the scope of this method must CFRetain it and then CFRelease it when they are finished with it.
     
     Note that to maintain optimal performance, some sample buffers directly reference pools of memory that may need to be reused by the device system and other capture inputs. This is frequently the case for uncompressed device native capture where memory blocks are copied as little as possible. If multiple sample buffers reference such pools of memory for too long, inputs will no longer be able to copy new samples into memory and those samples will be dropped. If your application is causing samples to be dropped by retaining the provided CMSampleBuffer objects for too long, but it needs access to the sample data for a long period of time, consider copying the data into a new buffer and then calling CFRelease on the sample buffer if it was previously retained so that the memory it references can be reused.
     */
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    
    /*!
     @method captureOutput:didDropSampleBuffer:fromConnection:
     @abstract
     Called once for each frame that is discarded.
     
     @param output
     The AVCaptureVideoDataOutput instance that dropped the frame.
     @param sampleBuffer
     A CMSampleBuffer object containing information about the dropped frame, such as its format and presentation time. This sample buffer will contain none of the original video data.
     @param connection
     The AVCaptureConnection from which the dropped video frame was received.
     
     @discussion
     Delegates receive this message whenever a video frame is dropped. This method is called once for each dropped frame. The CMSampleBuffer object passed to this delegate method will contain metadata about the dropped video frame, such as its duration and presentation time stamp, but will contain no actual video data. On iOS, Included in the sample buffer attachments is the kCMSampleBufferAttachmentKey_DroppedFrameReason, which indicates why the frame was dropped. This method will be called on the dispatch queue specified by the output's sampleBufferCallbackQueue property. Because this method will be called on the same dispatch queue that is responsible for outputting video frames, it must be efficient to prevent further capture performance problems, such as additional dropped video frames.
     */
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
