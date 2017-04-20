//
//  MessageViewController.swift
//  SmileCoffeClient
//
//  Created by Tao Jiachen on 2017/3/21.
//  Copyright © 2017年 Thomas_Tao. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class MessageViewController: UIViewController {

    
    @IBOutlet var Coffe: UIImageView!
    
    @IBOutlet var Label1: UILabel!
    
    @IBOutlet var Label2: UILabel!
    
    fileprivate var onceFlag = false
    
    var SmileStatue = false
    var httpResponse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Coffe.image = Coffe.image?.withRenderingMode(.alwaysTemplate)
        Coffe.tintColor = UIColor.brown
    }
    override func viewDidAppear(_ animated: Bool) {
        if !onceFlag {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                self.present()
            }
            onceFlag = true
        }
    }

    func present() {
        DispatchQueue.main.async() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "vs") as! AffairsViewController
            
            AudioServicesPlaySystemSound(114)
            repeat {
                self.httpResponse = self.http(smilestatue: self.SmileStatue)
            }while(!self.httpResponse)
            
            if self.httpResponse {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func http(smilestatue:Bool) -> Bool {
        //HTTP Request for controlling Coffe Machine
        let session = URLSession.shared
        let whiteurl = URL(string: "http://192.168.4.1/white")
        let blackurl = URL(string: "http://192.168.4.1/black")
        var url = URL(string: "http://192.168.4.1/")
        
        switch smilestatue {
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
                if Respons.statusCode == 200 || Respons.statusCode == 204 {
                    status = true
                    print(Respons.statusCode)
                }else {
                    print("404")
                }
            }else {print("No data")}
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
