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
    
    
    
    
    
    

    private var noteObserver: AnyObject!

    @IBOutlet var Label1: UILabel!
    @IBOutlet var Label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.noteObserver = NotificationCenter.default.addObserver(forName: .precedureFinished, object: nil, queue: OperationQueue.main) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }

        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.4) { 
            self.view.alpha = 1
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.noteObserver)
    }
    
    


}

