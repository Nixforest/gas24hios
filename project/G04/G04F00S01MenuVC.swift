//
//  G04F00S01MenuVC.swift
//  project
//
//  Created by SPJ on 12/28/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import harpyframework

class G04F00S01MenuVC: BaseMenuViewController {
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Override
//     */
//    override func configItemTapped(_ sender: AnyObject) {
//        self.dismiss(animated: false) {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: G04Const.NOTIFY_NAME_G04_ORDER_LIST_CONFIG_ITEM), object: nil)
//        }
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setItem(listValues: [false, false, false, true, true])
        setupMenuItem()
    }
    
    /**
     * Did receive memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
