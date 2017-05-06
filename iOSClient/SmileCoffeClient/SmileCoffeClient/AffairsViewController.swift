//
//  AffairsViewController.swift
//  SmileCoffeClient
//
//  Created by Tao Jiachen on 2017/3/20.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class AffairsViewController: UIViewController {



    @IBOutlet var Completed: UIImageView!
    
    @IBOutlet var Label1: UILabel!
    
    @IBOutlet var Label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Completed.image = Completed.image?.withRenderingMode(.alwaysTemplate)
        Completed.tintColor = UIColor.init(red: 118, green: 230, blue: 0, alpha: 0.8)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NotificationCenter.default.post(name: .precedureFinished, object: nil)
        }
    }

}
