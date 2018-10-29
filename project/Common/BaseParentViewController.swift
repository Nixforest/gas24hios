      //
//  BaseParentViewController.swift
//  project
//
//  Created by SPJ on 9/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class BaseParentViewController: ParentExtViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     * Handle open login view
     */
    override func openLogin() {
        let view = G00LoginExtVC(nibName: G00LoginExtVC.theClassName, bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.present(view, animated: true, completion: finishOpenLogin)
        }
//        let view = G00CheckLocation(nibName: G00CheckLocation.theClassName, bundle: nil)
//        if let controller = BaseViewController.getCurrentViewController() {
//            controller.present(view, animated: true, completion: finishOpenLogin)
//        }
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "G00LaunchScreenVC") as! G00LaunchScreenVC
////        let view = G00LaunchScreenVC()
//        if let controller = BaseViewController.getCurrentViewController() {
//            controller.present(secondViewController, animated: true, completion: finishOpenLogin)
//        }
        //let vc = self.storyboard.instantiateWithIdentifier("G00LaunchScreenVC")
        //pushToView(name: G00LaunchScreenVC.theClassName)
    }
    
    /**
     * Handle when finish open login view
     */
    internal func finishOpenLogin() -> Void {
        print("finishOpenLogin")
    }
    
    //++ BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    override func openPromotionActiveUsingCode(code: String) {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
        promotionView.activeUsingCode(code: code)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(promotionView, animated: true)
        }
    }
    //-- BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    //++ BUG0195-SPJ (NguyenPT 20180411) Add function announce
    /**
     * Handle open announce list
     */
    override func openAnnounce() {
        let view = G15F00S01VC(nibName: G15F00S01VC.theClassName,
                               bundle: nil)
        self.push(view, animated: true)
    }
    
    /**
     * Handle open announce detail
     * - parameter id: Id of announce
     */
    override func openAnnounceDetail(id: String) {
        let view = G15F00S02VC(nibName: G15F00S02VC.theClassName, bundle: nil)
        view.setData(id: id)
        self.push(view, animated: true)
    }
    //-- BUG0195-SPJ (NguyenPT 20180411) Add function announce
    override func openMapAgent() {
        let vc = MapAgentViewController(nibName: MapAgentViewController.theClassName, bundle: nil)
        self.push(vc, animated: true)
    }
}
