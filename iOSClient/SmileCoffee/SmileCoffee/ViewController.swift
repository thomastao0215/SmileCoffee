//
//  ViewController.swift
//  SmileCoffee
//
//  Created by Tao Jiachen on 2017/3/2.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import CoreImage
import ImageIO


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let dector = CIDetectorSmile
    var feature = CIFaceFeature()
    

}

