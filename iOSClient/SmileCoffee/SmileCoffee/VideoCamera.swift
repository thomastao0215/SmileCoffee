//
//  VideoCamera.swift
//  SmileCoffee
//
//  Created by Tao Jiachen on 2017/3/2.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import CoreImage
import ImageIO
import AVFoundation



class VieoCamera: UIViewController {
    
    let captureSession = AVCaptureSession()
    var videoCaptureDevice:AVCaptureDevice?
    var previewLayer = AVCaptureVideoPreviewLayer() //PreviewOutput
    var metadataOutput = AVCaptureMetadataOutput() //MetadataOutput
    let stillImageOutput = AVCaptureStillImageOutput()
    var face = UIImage()
    var Smile = false
    var context : CIContext = {
        return CIContext(options: nil)
    }()

    
    @IBOutlet var CameraView: UIView!
    
    @IBOutlet weak var StatueLabel: UILabel!
    
    @IBOutlet weak var Content: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.CameraSetting()
        if self.FaceDetector() {
            captureImage()
            let Image = CIImage(image: face)
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            var faceFeatures :[CIFaceFeature]!
            faceFeatures = detector?.features(in: Image!) as! [CIFaceFeature]!
            for feature in faceFeatures {
                if feature.hasSmile {
                    Smile = true
                }
            }
            
            
            
        }
        
    }
    func CameraSetting() {
        let Discovery = AVCaptureDeviceDiscoverySession(deviceTypes: [ AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        
        for device in (Discovery?.devices)! {
            print(device.localizedName)
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.front {
                    self.videoCaptureDevice = device
                }
            }
        }
        if videoCaptureDevice != nil {
            do {
                try self.captureSession.addInput(AVCaptureDeviceInput(device: self.videoCaptureDevice))
                
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.CameraView.layer.addSublayer(previewLayer)
                self.previewLayer.frame = self.CameraView.frame
                stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                if captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addOutput(stillImageOutput)
                }
                
                self.captureSession.startRunning()
                
            }catch {
                print(error)
            }
        }
    }
    
    func FaceDetector() -> (Bool){
        if self.captureSession.canAddOutput(metadataOutput){
            self.captureSession.addOutput(metadataOutput)
       //    let mainQueue = DispatchQueue.init(label: "Hello")
       //     self.metadataOutput.setMetadataObjectsDelegate(<#T##objectsDelegate: AVCaptureMetadataOutputObjectsDelegate!##AVCaptureMetadataOutputObjectsDelegate!#>, queue: mainQueue)
            self.metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        }
        return true
    }

    func captureImage() {
        let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo)
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(ingDataBuffer, error) in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(ingDataBuffer)
            self.face = UIImage(data: imageData!)!
        })
    }
}





