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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Coffe.image = Coffe.image?.withRenderingMode(.alwaysTemplate)
        Coffe.tintColor = UIColor.brown
    }
    override func viewDidAppear(_ animated: Bool) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
            self.present()
        }
    }

    func present() {
        DispatchQueue.main.async() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "vs")
            AudioServicesPlaySystemSound(114)
            self.present(vc!, animated: true, completion: nil)
            self.removeFromParentViewController()
        }

    }
    
    func http() {
        //HTTP Request for controlling Coffe Machine
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
