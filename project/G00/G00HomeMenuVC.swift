//
//  homeMenuViewController.swift
//  project
//
//  Created by Lâm Phạm on 10/25/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00HomeMenuVC: BaseMenuViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if BaseModel.shared.checkIsLogin() {
//            setItem(listValues: [false, true, false, true, true])
//        } else {
//            setItem(listValues: [true, false, true, false, true])
//        }
//        setupMenuItem()
//        // Do any additional setup after loading the view.
//    }
//    
//    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
////    /**
////     * Override
////     */
////    override func configItemTapped(_ sender: AnyObject) {
////        self.dismiss(animated: false) {
////            NotificationCenter.default.post(name: Notification.Name(rawValue: DomainConst.NOTIFY_NAME_COFIG_ITEM_HOMEVIEW), object: nil)
////        }
////        
////    }
//    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
