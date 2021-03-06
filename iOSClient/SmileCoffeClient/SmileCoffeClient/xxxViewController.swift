//
//  xxxViewController.swift
//  SmileCoffeClient
//
//  Created by Tao Jiachen on 2017/5/10.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit

class xxxViewController: UIViewController {
    
    @IBAction func request(_ sender: Any) {
        http(smilestatus: true)
    }
    func http(smilestatus:Bool) -> Bool {
        //HTTP Request for controlling Coffe Machine
        let session = URLSession.shared
        let whiteurl = URL(string: "https://api.github.com/")
        let blackurl = URL(string: "http://192.168.1.112:3000/black")
        var url = URL(string: "http://192.168.1.112:3000/")
        
        switch smilestatus {
        case true:
            url = whiteurl!
        default:
            url = blackurl!
        }
        
        let urlRequest = URLRequest(url: url!)
        var status = false
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, respons, eror) -> Void in
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
