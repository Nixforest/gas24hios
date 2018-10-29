//
//  MultiDeviceVC.swift
//  project
//
//  Created by SPJ on 9/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class MultiDeviceVC: BaseChildViewController {
    @IBOutlet weak var lblLabel1: UILabel!
    @IBOutlet weak var btnPOS: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblLabel1.text = String(describing: self.getTopHeight())
        
        // Navigation
        self.createNavigationBar(title: "Thử nghiệm Multi-device")
        
        // Handle position of controls
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
