//
//  ViewController.swift
//  SmileCoffeClient
//
//  Created by Tao Jiachen on 2017/3/20.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {



    @IBOutlet var Label1: UILabel!
    @IBOutlet var Label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.removeFromParentViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
