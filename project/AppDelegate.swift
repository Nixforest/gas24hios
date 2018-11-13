//
//  AppDelegate.swift
//  project
//
//  Created by Lâm Phạm on 7/21/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import UserNotifications
import harpyframework
import GoogleMaps
import GooglePlaces
import Firebase
import FBSDKCoreKit
import FBSDKCoreKit.FBSDKAppEvents
import FacebookCore
//import FBSDKLoginKit
//import FBSDKShareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var loginStatus:Bool = false

    internal var rootNav: UINavigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Register push notifications
        registerForPushNotifications(application: application)
        
        // Override point for customization after application launch.
        //self.window?.rootViewController = testViewController()
        //self.window?.makeKeyWindow()
 
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        SlideMenuOptions.leftViewWidth = GlobalConst.POPOVER_WIDTH
        SlideMenuOptions.panGesturesEnabled = true
        SlideMenuOptions.hideStatusBar = false
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        
        //let firstVC = mainStoryboard.instantiateViewController(withIdentifier: DomainConst.G00_HOME_VIEW_CTRL)
        //++ BUG0156-SPJ (NguyenPT 20170921) Re-design Gas24h
        //++
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let firstVC = mainStoryboard.instantiateViewController(withIdentifier: "LoadingVC") as! ParentViewController
        ///******
        let firstVC = G12F01S01VC(nibName: G12F01S01VC.theClassName, bundle: nil)
        //--
        //-- BUG0156-SPJ (NguyenPT 20170921) Re-design Gas24h
        rootNav = UINavigationController(rootViewController: firstVC)
        rootNav.isNavigationBarHidden = false
        //++ BUG0156-SPJ (NguyenPT 20170922) Re-design Gas24h
        let menu = MenuVC(nibName: MenuVC.theClassName, bundle: nil)
        //-- BUG0156-SPJ (NguyenPT 20170922) Re-design Gas24h
        
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        let slide = BaseSlideMenuViewController(
            mainViewController: rootNav,
            //++ BUG0156-SPJ (NguyenPT 20170922) Re-design Gas24h
//            leftMenuViewController: mainStoryboard.instantiateViewController(
//                withIdentifier: "BaseMenuViewController"))
            leftMenuViewController: menu)
            //-- BUG0156-SPJ (NguyenPT 20170922) Re-design Gas24h
        slide.delegate = firstVC
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        self.window?.rootViewController = slide
        self.window?.makeKeyAndVisible()
        ///*****
 
        //----- Handle notification receive -----
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            handleNotification(data: notification)
        }
        
        // Google maps
        //let key = "AIzaSyDpiyIoQSxkj1GAqwUSxk-3wxxUcuQa_6k"
        //let key = "AIzaSyBAp4n2BAmthIPvaF4FCOmQ19WEnb6trfs"
        let key = DomainConst.GOOGLE_API_KEY
        GMSServices.provideAPIKey(key)
        GMSPlacesClient.provideAPIKey(key)
        // Google Direct API
        // AIzaSyB9aMZnBX9TENtEDdhsJtpGI8kfbSFtKgo
        
        //++ BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
        // Facebook
       // SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //-- BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
        
        //++ BUG0168-SPJ (NguyenPT 20171124) Reset Cache data when terminal app
        // Reset cache data
        URLCache.shared.removeAllCachedResponses()
        //-- BUG0168-SPJ (NguyenPT 20171124) Reset Cache data when terminal app
        //++ BUG0193-SPJ (NguyenPT 20180402) Add firebase core
        FirebaseApp.configure()
        //-- BUG0193-SPJ (NguyenPT 20180402) Add firebase core
        //++ add Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //--
        
        return true
    }
    //++ add Facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        // Add any custom logic here.
        
        return handled
    }
    //-- add Facebook
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //++ BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
        //AppEventsLogger.activate(application)
        //-- BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
        //++ BUG0165-SPJ (NguyenPT 20171122) Can not start Transaction Status request after login
        if let currentVC = BaseViewController.getCurrentViewController() {
            if currentVC.theClassName == G12F01S01VC.theClassName {
                // Start new request Transaction Status
                (currentVC as! G12F01S01VC).requestNewTransactionStatus()
            }
        }
        //-- BUG0165-SPJ (NguyenPT 20171122) Can not start Transaction Status request after login
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillEnterForeground")
    }

    /**
     * Register for push notifications
     * - parameter application: Application
     */
    func registerForPushNotifications(application: UIApplication) {
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.badge, .alert, .sound],
                completionHandler: { (granted, error) in })
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
        }
    }
    
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != .none {
//            application.registerForRemoteNotifications()
//        }
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        BaseModel.shared.setDeviceToken(token: tokenString)
        print(tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error when register device token: ", error)
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("receive notification 2")
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let data = userInfo as! [String: AnyObject]
        handleNotification(data: data, isManual: true)
        
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, willCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([UNNotificationPresentOptions.alert, UNNotificationPresentOptions.sound,
//                           UNNotificationPresentOptions.badge   ])
//    }
    
    /**
     * Handle when receive notification
     * - parameter data: Data object
     */
    func handleNotification(data: [String: AnyObject], isManual: Bool = false) {
        let notifyType  = data["notify_type"] as? String ?? ""
        let id          = data["id"] as? String ?? ""
        let notifyId    = data["notify_id"] as? String ?? ""
        let type        = data["type"] as? String ?? ""
        let replyId     = data["reply_id"] as? String ?? ""
        var message     = DomainConst.BLANK
        if let aps = data["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let msg = alert["message"] as? NSString {
                    // Do stuff
                    message = msg as String
                }
            } else if let alert = aps["alert"] as? NSString {
                // Do stuff
                message = alert as String
            }
        }
        
        // Save to setting
        BaseModel.shared.setNotificationData(id: id, notify_id: notifyId, notify_type: notifyType, type: type, reply_id: replyId, message: message)
        let notify = NotificationBean.init(id: id, notify_id: notifyId,
                                           notify_type: notifyType, type: type,
                                           reply_id: replyId, message: message)
        if let currentView = BaseViewController.getCurrentViewController() {
            currentView.handleNotification(notify: notify, isManual: isManual)
        }
        
        //++ BUG0049-SPJ (NguyenPT 20170313) Handle notification received
//        // Create alert
//        if isManual && BaseModel.shared.canHandleNotification() {
//            let alert = UIAlertController(title: DomainConst.CONTENT00044, message: message, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: DomainConst.CONTENT00223, style: .default, handler: {
//                (alert: UIAlertAction!) in
//                ConfirmNotifyRequest.requestConfirmNotify(notifyId: notifyId, type: type, objId: id)
//                if let navigationController = self.window?.rootViewController as? UINavigationController {
//                    if navigationController.visibleViewController is G00HomeVC {
//                        navigationController.visibleViewController?.viewDidAppear(true)
//                    } else {
//                        navigationController.popToRootViewController(animated: true)
//                    }
//                }
//            })
//            alert.addAction(okAction)
//            let cancelAction = UIAlertAction(title: DomainConst.CONTENT00224, style: .cancel, handler: {
//                (alert: UIAlertAction!) in
//                if let navigationController = self.window?.rootViewController as? UINavigationController {
//                    //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
////                    RequestAPI.requestNotificationCount(view: (navigationController.visibleViewController as! BaseViewController))
//                    let view = (navigationController.visibleViewController as! BaseViewController)
//                    NotificationCountRequest.requestNotificationCount(action: #selector(view.emptyMethod(_:)), view: view)
//                    //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//                }
//                BaseModel.shared.clearNotificationData()
//            })
//            alert.addAction(cancelAction)
//            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//        } else {
//            // Reply confirm notify to server
//            ConfirmNotifyRequest.requestConfirmNotify(notifyId: notifyId, type: type, objId: id)
//        }
        //-- BUG0049-SPJ (NguyenPT 20170313) Handle notification received
        
        // Move to detail
        print(message)
    }
    
    /**
     * Asks the delegate for the interface orientations to use for the view controllers in the specified window.
     */
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIInterfaceOrientationMask.portrait
        case .pad:
            return UIInterfaceOrientationMask.all
        default:
            break
        }
        return UIInterfaceOrientationMask.all
    }
    
    //++ BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
    /**
     * Asks the delegate to open a resource identified by a URL.
     */
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        let handled: Bool = SDKApplicationDelegate.shared.application(
//            application,
//            open: url,
//            sourceApplication: sourceApplication,
//            annotation: annotation)
//        return handled
//    }
    //-- BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
    //++
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logViewedContentEvent(contentType : String, contentData : String, contentId : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .contentType : contentType,
            .content : contentData,
            .contentId : contentId,
            .currency : currency
        ]
        let event = AppEvent(name: .viewedContent, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }

    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logSearchedEvent(contentType : String, contentData : String, contentId : String, searchString : String, success : Bool) {
        let params : AppEvent.ParametersDictionary = [
            .contentType : contentType,
            .content : contentData,
            .contentId : contentId,
            .searchedString : searchString,
            .successful : NSNumber(value: success ? 1 : 0)
        ]
        let event = AppEvent(name: .searched, parameters: params)
        AppEventsLogger.log(event)
    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logRatedEvent(contentType : String, contentData : String, contentId : String, maxRatingValue : Int, ratingGiven : Double) {
        let params : AppEvent.ParametersDictionary = [
            .contentType : contentType,
            .content : contentData,
            .contentId : contentId,
            .maxRatingValue : NSNumber(value:maxRatingValue)
        ]
        let event = AppEvent(name: .rated, parameters: params, valueToSum: ratingGiven)
        AppEventsLogger.log(event)
    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logAddedToWishlistEvent(contentData : String, contentId : String, contentType : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .currency : currency
        ]
        let event = AppEvent(name: .addedToWishlist, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logAddedToCartEvent(contentData : String, contentId : String, contentType : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .currency : currency
        ]
        let event = AppEvent(name: .addedToCart, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logInitiatedCheckoutEvent(contentData : String, contentId : String, contentType : String, numItems : Int, paymentInfoAvailable : Bool, currency : String, totalPrice : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .itemCount : NSNumber(value:numItems),
            .paymentInfoAvailable : NSNumber(value: paymentInfoAvailable ? 1 : 0),
            .currency : currency
        ]
        let event = AppEvent(name: .initiatedCheckout, parameters: params, valueToSum: totalPrice)
        AppEventsLogger.log(event)
    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logAddedPaymentInfoEvent(success : Bool) {
        let params : AppEvent.ParametersDictionary = [.successful : NSNumber(value: success ? 1 : 0)]
        let event = AppEvent(name: .addedPaymentInfo, parameters: params)
        AppEventsLogger.log(event)
    }
    
    /**
     * Call the built-in SDK function:
     * amount is Double (required)
     * currency is String from http://en.wikipedia.org/wiki/ISO_4217 (optional).
     * parameters is ParametersDictionary (optional).
     */
    //AppEvent.purchased(amount: amount, currency: currency, extraParameters: parameters)
    
    
    
    //--
}

