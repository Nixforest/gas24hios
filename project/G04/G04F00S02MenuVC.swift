//
//  G04F00S02MenuVC.swift
//  project
//
//  Created by SPJ on 12/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

class G04F00S02MenuVC: BaseMenuViewController {
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Override
//     */
//    override func configItemTapped(_ sender: AnyObject) {
//        self.dismiss(animated: false) {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: G04Const.NOTIFY_NAME_G04_ORDER_VIEW_CONFIG_ITEM), object: nil)
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
