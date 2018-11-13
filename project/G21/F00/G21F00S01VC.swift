//
//  G21F00S01VC.swift
//  project
//
//  Created by SPJ on 10/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class G21F00S01VC: BaseParentViewController {

    @IBAction func goScanScreen(_ sender: Any) {
        pushToView(name: "G21F00S02VC")
    }
    
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var lblQRCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: DomainConst.CONTENT00550)
        btnScan.layer.cornerRadius = btnScan.frame.height / 2
        btnScan.backgroundColor = GlobalConst.MAIN_COLOR_GAS_24H
    }

}
