//
//  ViewController.swift
//  Camera
//
//  Created by Tao Jiachen on 2017/3/7.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import CoreImage
import AVFoundation


class ViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var SessionOutput = AVCapturePhotoOutput()
    var setting = AVCapturePhotoSettings()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var Smile = false
    
    @IBOutlet var CameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [ AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
    }



}

