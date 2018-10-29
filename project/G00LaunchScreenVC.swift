//
//  G00LaunchScreenVC.swift
//  project
//
//  Created by SPJ on 10/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

class G00LaunchScreenVC: UIViewController {
    var window: UIWindow?
    internal var rootNav: UINavigationController = UINavigationController()
    @IBOutlet weak var loadingLayout: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadingLayout.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Thread.sleep(forTimeInterval: 3.0)
        let viewGasOrder = G00LoginExtVC(nibName: G00LoginExtVC.theClassName,
                                       bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.present(viewGasOrder, animated: true, completion: nil)
        }
//        viewGasOrder.requestNewTransactionStatus()
//        self.present(viewGasOrder, animated: true, completion: nil) 
//        if let topController = UIApplication.topViewController() {
//            topController.present(viewGasOrder, animated: true, completion: nil) 
//        }
    }
    /**
     * Handle when finish dismiss login screen
     */
    internal func finishDismissSplashScreen() -> Void {
        

    }

}
