//
//  G12F00VC.swift
//  project
//
//  Created by SPJ on 10/17/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class G12F00VC: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let g12f00s01 = G12F00S01VC(nibName: G12F00S01VC.theClassName,
                                    bundle: nil)
        let g12f00s02 = G12F00S02VC(nibName: G12F00S02VC.theClassName,
                                    bundle: nil)
        let g12f00s01NV = UINavigationController(rootViewController: g12f00s01)
        let g12f00s02NV = UINavigationController(rootViewController: g12f00s02)
        
        self.viewControllers = [g12f00s01NV, g12f00s02NV]
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
