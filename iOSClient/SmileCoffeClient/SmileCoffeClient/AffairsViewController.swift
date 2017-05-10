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
import Canvas


class AffairsViewController: UIViewController {



    let layer = CAShapeLayer()
    let layerx = CAShapeLayer()
    let layery = CAShapeLayer()
    var path = UIBezierPath()
    var path1 = UIBezierPath()
    
    var selectionx:String = ""
    
    @IBOutlet var MessageView: CSAnimationView!
    
    let viewx = UIView()
    @IBOutlet var Completed: UIImageView!
    

    

    override func viewWillAppear(_ animated: Bool) {
        
        view.addSubview(viewx)
        
        
        let startAngle: CGFloat = 0.0
        let radius: CGFloat = 100.0
        let endAngle: CGFloat = CGFloat(Double.pi * 2)
        let center = CGPoint(x: view.center.x, y: view.center.y)
        
        
        path1.move(to: center)
        path1.addLine(to: CGPoint(x: center.x - 10, y: center.y + 20))
        layerx.path = path1.cgPath
        

        
        path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = CGFloat(5.0)
        path.lineCapStyle = CGLineCap.butt
        
        layer.path = path.cgPath
        layer.lineWidth = 10
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.orange.cgColor
        self.path.stroke()
        
        Completed.image = UIImage.init(named: selectionx)
//        view.layer.addSublayer(layer)
//        view.layer.addSublayer(layerx)
        MessageView.startCanvasAnimation()
    
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NotificationCenter.default.post(name: .precedureFinished, object: nil)
        }
    }

}
