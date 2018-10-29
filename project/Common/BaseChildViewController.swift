//
//  BaseChildViewController.swift
//  project
//
//  Created by Pham Trung Nguyen on 4/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class BaseChildViewController: ChildExtViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func openAnnounceDetail(id: String) {
        let view = G15F00S02VC(nibName: G15F00S02VC.theClassName, bundle: nil)
        view.setData(id: id)
        self.push(view, animated: true)
    }
}
