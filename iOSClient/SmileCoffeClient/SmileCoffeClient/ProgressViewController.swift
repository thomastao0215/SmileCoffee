//
//  ProgressViewController.swift
//  SmileCoffeClient
//
//  Created by softthree-29 on 2017/5/6.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import Canvas
import AudioToolbox
import AVFoundation

class ProgressViewController: UIViewController {
    
    let layer = CAShapeLayer()
    let LElayer = CAShapeLayer()
    let RElayer = CAShapeLayer()
    let Mouthlayer = CAShapeLayer()
    let mouthPath = UIBezierPath()
    var mouthleft:CGPoint!
    var mouthright:CGPoint!
    var selection = String()
    
    var mouthinnerLayer = CAShapeLayer()

    var count = 0
    var dpLink:CADisplayLink!
    
    var cp1:CGPoint!
    var cp2:CGPoint!
    var time = 0

    
    func update(){
        time = time+1
        if time >= 1800 {
            stopDpLink()
            present()
        }
        mouthPath.removeAllPoints()
        cp1.y = cp1.y+0.08
        cp2.y = cp2.y+0.08
        
        mouthPath.move(to: mouthleft)
        mouthPath.addCurve(to: mouthright, controlPoint1: cp1, controlPoint2: cp2)
        Mouthlayer.path = mouthPath.cgPath
        
    }
    
    func startDpLink(){
        self.dpLink.isPaused = false
    }
    
    func stopDpLink(){
        self.dpLink.invalidate()
    }
    
    
    
    
    @IBOutlet weak var Statue: UILabel!
    
    @IBOutlet weak var Wait: UILabel!
    
    
    
    override open func viewWillAppear(_ animated: Bool) {
        let radius: CGFloat = 120.0
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = CGFloat(Double.pi * 2)
        let center = CGPoint(x: view.center.x, y: view.center.y - 100.0)
        let eyeradius: CGFloat = 15.0
        let lefteye = CGPoint(x: center.x-42.0, y: center.y - 35.0)
        let righteye = CGPoint(x: center.x+42.0, y: center.y - 35.0)
        
        
        
        mouthleft = CGPoint(x: lefteye.x - 25.0, y: lefteye.y + 75.0)
        mouthright = CGPoint(x: righteye.x + 25.0, y: lefteye.y + 75.0)
        
        cp1 = CGPoint(x: (mouthleft.x + mouthright.x)/3.0, y: mouthleft.y - 75)
        cp2 = CGPoint(x: (mouthleft.x + mouthright.x)*2.0/3.0, y: mouthright.y - 75)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let LEyePath = UIBezierPath(arcCenter: lefteye, radius: eyeradius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let REyePath = UIBezierPath(arcCenter: righteye, radius: eyeradius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        
        
        
        mouthPath.move(to: mouthleft)
        mouthPath.addCurve(to: mouthright, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = 5.0
        
        layer.path = path.cgPath
        layer.lineWidth = 8
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.orange.cgColor
        
        LElayer.path = LEyePath.cgPath
        LElayer.lineWidth = 8
        LElayer.fillColor = UIColor.orange.cgColor
        LElayer.strokeColor = UIColor.clear.cgColor
        
        RElayer.path = REyePath.cgPath
        RElayer.lineWidth = 8
        RElayer.fillColor = UIColor.orange.cgColor
        RElayer.strokeColor = UIColor.clear.cgColor
        
        Mouthlayer.path = mouthPath.cgPath
        Mouthlayer.fillColor = UIColor.clear.cgColor
        Mouthlayer.strokeColor = UIColor.black.cgColor
        

        
        Mouthlayer.strokeColor = UIColor.orange.cgColor
        Mouthlayer.lineWidth = 10
        Mouthlayer.lineCap = kCALineCapRound
        view.layer.addSublayer(layer)
        view.layer.addSublayer(LElayer)
        view.layer.addSublayer(RElayer)
        view.layer.addSublayer(Mouthlayer)
        
        

        
        dpLink = CADisplayLink(target: self, selector: #selector(update))
        dpLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        Statue.text = "汽水正在制作中"
        
        switch selection {
        case "Coffeex":
            Statue.text = "咖啡正在制作中"
        case "Colax":
            Statue.text = "汽水正在制作中"
        case "Milkteax":
            Statue.text = "奶茶正在制作中"
        case "Juicex":
            Statue.text = "果汁正在制作中"
        default:
            Statue.text = "正在制作中"
        }
        Wait.text = "请稍候"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func present() {
        DispatchQueue.main.async() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "vs") as! AffairsViewController
            vc.selectionx = self.selection
            AudioServicesPlaySystemSound(1028)
            self.present(vc, animated: true, completion: nil)
            
            
            
        }
    }
    
    

    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
