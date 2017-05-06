//
//  FacetrackingViewController.swift
//  SmileCoffeClient
//
//  Created by Tao Jiachen on 2017/3/20.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//


import UIKit
import AVFoundation

class DetailsView: UIView {
    
    lazy var detailsLabel: UILabel = {
        let detailsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        detailsLabel.numberOfLines = 0
        detailsLabel.textColor = .white
        detailsLabel.font = UIFont.systemFont(ofSize: 18.0)
        detailsLabel.textAlignment = .left
        
        return detailsLabel
    }()
    
    func setup() {
        layer.borderColor = UIColor.red.withAlphaComponent(0.7).cgColor
        layer.borderWidth = 5.0
        
        addSubview(detailsLabel)
    }
    
    override var frame: CGRect {
        didSet(newFrame) {
            var detailsFrame = detailsLabel.frame
            detailsFrame = CGRect(x: 0, y: newFrame.size.height, width: newFrame.size.width * 2.0, height: newFrame.size.height / 2.0)
            detailsLabel.frame = detailsFrame
        }
    }
}


class FaceTrackingViewController: UIViewController {
    
    var session: AVCaptureSession?
    var stillOutput = AVCaptureStillImageOutput()
    var borderLayer: CAShapeLayer?
    
    fileprivate var detectedFace = false
    fileprivate var hasSmile = false
    fileprivate var isSmileDetected = false
    
    fileprivate var timer: DispatchSourceTimer?
    
    let detailsView: DetailsView = {
        let detailsView = DetailsView()
        detailsView.setup()
        
        return detailsView
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        var previewLay = AVCaptureVideoPreviewLayer(session: self.session!)
        previewLay?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        return previewLay
    }()
    
    lazy var frontCamera: AVCaptureDevice? = {
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else { return nil }
        
        return devices.filter { $0.position == .front }.first
    }()
    
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyLow])
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let previewLayer = previewLayer else { return }
        
        view.layer.addSublayer(previewLayer)
        view.addSubview(detailsView)
        view.bringSubview(toFront: detailsView)
        
        timer = DispatchSource.makeTimerSource()
        timer?.setEventHandler(handler: DispatchWorkItem {
            NotificationCenter.default.post(name: .precedureFinished, object: nil)
        })
        timer?.scheduleOneshot(deadline: .now() + .seconds(10))
        timer?.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionPrepare()
        session?.startRunning()
    }
}

extension FaceTrackingViewController {
    
    func sessionPrepare() {
        session = AVCaptureSession()
        
        guard let session = session, let captureDevice = frontCamera else { return }
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            session.beginConfiguration()
            
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            
            output.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
            let queue = DispatchQueue(label: "output.queue")
            output.setSampleBufferDelegate(self, queue: queue)
            
        } catch {
            print("error with creating AVCaptureDeviceInput")
        }
    }
}

extension FaceTrackingViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if self.isSmileDetected {
            return
        }
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [String : Any]?)
        let options: [String : Any] = [CIDetectorImageOrientation: exifOrientation(orientation: UIDevice.current.orientation),
                                       CIDetectorSmile: true,
                                       CIDetectorEyeBlink: true]
        let allFeatures = faceDetector?.features(in: ciImage, options: options)
        
        let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        let cleanAperture = CMVideoFormatDescriptionGetCleanAperture(formatDescription!, false)
        
        guard let features = allFeatures else { return }
        
        for feature in features {
            if !detectedFace {
                detectedFace = true
                timer?.cancel()
                timer = DispatchSource.makeTimerSource()
                timer?.setEventHandler(handler: DispatchWorkItem {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ms") as! MessageViewController
                    
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    AudioServicesPlaySystemSound(1114)
                })
                timer?.scheduleOneshot(deadline: .now() + .seconds(5))
                timer?.resume()
            }
            
            
            if let faceFeature = feature as? CIFaceFeature {
                let faceRect = calculateFaceRect(facePosition: faceFeature.mouthPosition, faceBounds: faceFeature.bounds, clearAperture: cleanAperture)
                let featureDetails = ["是否有微笑: \(faceFeature.hasSmile)"]
                update(with: faceRect, text: featureDetails.joined(separator: "\n"))
                if faceFeature.hasSmile {
                    self.isSmileDetected = true
                    self.timer?.cancel()
                    self.timer = nil
                    //如果没有DetectSmile 5s后跳转到MessageViewController
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                        self.session?.stopRunning()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "sl") as! SelectionViewController

                        
                        self.present(vc, animated: true, completion: nil)
                        //self.present(vc!, animated: true, completion: nil)
                        AudioServicesPlaySystemSound(1114)
                        //self.removeFromParentViewController()
                        return
                    }
                    return
                }
            }
        }
        
        if features.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                // Wait for 1 second to see whether we really cannot detect any faces.
                if !self.hasSmile {
                    self.detailsView.alpha = 0
                }
            }
        }
        
    }
    func exe() {
        print("hello")
    }
    func exifOrientation(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portraitUpsideDown:
            return 8
        case .landscapeLeft:
            return 3
        case .landscapeRight:
            return 1
        default:
            return 6
        }
    }
    
    func videoBox(frameSize: CGSize, apertureSize: CGSize) -> CGRect {
        let apertureRatio = apertureSize.height / apertureSize.width
        let viewRatio = frameSize.width / frameSize.height
        
        var size = CGSize.zero
        
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width
            size.height = apertureSize.width * (frameSize.width / apertureSize.height)
        } else {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width)
            size.height = frameSize.height
        }
        
        var videoBox = CGRect(origin: .zero, size: size)
        
        if (size.width < frameSize.width) {
            videoBox.origin.x = (frameSize.width - size.width) / 2.0
        } else {
            videoBox.origin.x = (size.width - frameSize.width) / 2.0
        }
        
        if (size.height < frameSize.height) {
            videoBox.origin.y = (frameSize.height - size.height) / 2.0
        } else {
            videoBox.origin.y = (size.height - frameSize.height) / 2.0
        }
        
        return videoBox
    }
    
    func calculateFaceRect(facePosition: CGPoint, faceBounds: CGRect, clearAperture: CGRect) -> CGRect {
        let parentFrameSize = previewLayer!.frame.size
        let previewBox = videoBox(frameSize: parentFrameSize, apertureSize: clearAperture.size)
        
        var faceRect = faceBounds
        
        swap(&faceRect.size.width, &faceRect.size.height)
        swap(&faceRect.origin.x, &faceRect.origin.y)
        
        let widthScaleBy = previewBox.size.width / clearAperture.size.height
        let heightScaleBy = previewBox.size.height / clearAperture.size.width
        
        faceRect.size.width *= widthScaleBy
        faceRect.size.height *= heightScaleBy
        faceRect.origin.x *= widthScaleBy
        faceRect.origin.y *= heightScaleBy
        
        faceRect = faceRect.offsetBy(dx: 0.0, dy: previewBox.origin.y)
        let frame = CGRect(x: parentFrameSize.width - faceRect.origin.x - faceRect.size.width / 2.0 - previewBox.origin.x / 2.0, y: faceRect.origin.y, width: faceRect.width, height: faceRect.height)
        
        return frame
    }
}

extension FaceTrackingViewController {
    func update(with faceRect: CGRect, text: String) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.detailsView.detailsLabel.text = text
                self.detailsView.alpha = 1.0
                self.detailsView.frame = faceRect
                
            }
        }
    }
}
