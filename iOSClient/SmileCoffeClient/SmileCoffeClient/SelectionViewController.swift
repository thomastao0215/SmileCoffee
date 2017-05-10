//
//  SelectionViewController.swift
//  SmileCoffeClient
//
//  Created by softthree-29 on 2017/5/3.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import Canvas
import AVFoundation

class SelectionViewController: UIViewController {


    @IBOutlet weak var CoffeeView: CSAnimationView!
    
    @IBOutlet weak var TeaView: CSAnimationView!
    @IBOutlet weak var ColaView: CSAnimationView!
    
    @IBOutlet weak var JuiceView: CSAnimationView!
    @IBAction func Coffee(_ sender: Any) {
        http(smilestatus: true)
        CoffeeView.startCanvasAnimation()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pg") as! ProgressViewController
        
        vc.selection = "Coffeex"
        AudioServicesPlaySystemSound(1025)
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func Cola(_ sender: Any) {
        http(smilestatus: true)
        ColaView.startCanvasAnimation()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pg") as! ProgressViewController
        vc.selection = "Colax"
        AudioServicesPlaySystemSound(1025)
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func Tea(_ sender: Any) {
        http(smilestatus: true)
        TeaView.startCanvasAnimation()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pg") as! ProgressViewController
        vc.selection = "Milkteax"
        AudioServicesPlaySystemSound(1025)
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func Juice(_ sender: Any) {
        http(smilestatus: true)
        JuiceView.startCanvasAnimation()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pg") as! ProgressViewController

        vc.selection = "Juicex"
        AudioServicesPlaySystemSound(1025)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
