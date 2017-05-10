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
    
    
    
    func http(smilestatus:Bool) -> Bool {
        //HTTP Request for controlling Coffe Machine
        let session = URLSession.shared
        let whiteurl = URL(string: "http://192.168.1.102:3000/white")
        let blackurl = URL(string: "http://192.168.1.112:3000/black")
        var url = URL(string: "http://192.168.1.112:3000/")
        
        switch smilestatus {
        case true:
            url = whiteurl!
        default:
            url = blackurl!
        }
        print("here")
        let urlRequest = URLRequest(url: url!)
        var status = false
        let task =  session.dataTask(with: urlRequest, completionHandler: { (data, respons, eror) -> Void in
            if data != nil{
                let Respons:HTTPURLResponse = respons as! HTTPURLResponse
                if Respons.statusCode == 200 || Respons.statusCode == 304 {
                    status = true
                    print(Respons.statusCode)
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    print(json!)
                }else {
                    print("hell")
                }
            }else {print("efq")}
        })
        
        task.resume()
        return status
    }
    
    
    

    private var noteObserver: AnyObject!

    @IBOutlet var Label1: UILabel!
    @IBOutlet var Label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.noteObserver = NotificationCenter.default.addObserver(forName: .precedureFinished, object: nil, queue: OperationQueue.main) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        http(smilestatus: true)
        
        
        
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

