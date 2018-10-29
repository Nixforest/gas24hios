//
//  LoadingVC.swift
//  project
//
//  Created by SPJ on 10/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps

class LoadingVC: BaseViewController {
    // MARK: Properties
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    /** Location */
    let locationManager:    CLLocationManager   = CLLocationManager()
    // MARK: Static values
    /** Current position of map view */
    public static var _currentPos       = CLLocationCoordinate2D.init()
    /** Save neares agent information */
    public static var _nearestAgent     = AgentInfoBean()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //extendedLayoutIncludesOpaqueBars = true
        //loadingView.startAnimating()
        // Do any additional setup after loading the view.
        // Navigation
        //self.createNavigationBar(title: DomainConst.HOTLINE)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
//            let view = G12F01S01VC(nibName: G12F01S01VC.theClassName,
//                                   bundle: nil)
//            if let controller = BaseViewController.getCurrentViewController() {
//                controller.navigationController?.pushViewController(view, animated: true)
//            }
        }
        
        //view.setNeedsLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.isTranslucent = true
          self.navigationController?.view.backgroundColor = .clear
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
            //            let view = G12F01S01VC(nibName: G12F01S01VC.theClassName,
            //                                   bundle: nil)
            //            if let controller = BaseViewController.getCurrentViewController() {
            //                controller.navigationController?.pushViewController(view, animated: true)
            //            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //extendedLayoutIncludesOpaqueBars
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.view.backgroundColor = GlobalConst.MAIN_COLOR_GAS_24H
        //view.layoutIfNeeded()
    }
    
    
//    override func setNavigationBarTitle(title: String) {
//    }
//    override func setupNavigationBarParentItems() {
//    }
    
}

// MARK: Protocol - CLLocationManagerDelegate
extension LoadingVC: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if let location: CLLocation = locations.last {
            // Save current location
//            G12F01S01VC._currentPos = location.coordinate
//            let view = G12F01S01VC(nibName: G12F01S01VC.theClassName,
//                                       bundle: nil)
//            if let controller = BaseViewController.getCurrentViewController() {
//                controller.navigationController?.pushViewController(view, animated: true)
//            }
            //            G12F01S01VC._currentPos = CLLocationCoordinate2D(latitude: 10.819258114124, longitude: 106.724750036821)
//            GMSGeocoder().reverseGeocodeCoordinate(location.coordinate, completionHandler: {
//                (response, error) in
//                if error != nil, response == nil {
//                    return
//                }
//                // Get Address
//                if let result = response?.firstResult() {
//                    if let lines = result.lines {
//                        self.addressText = lines.joined(separator: DomainConst.ADDRESS_SPLITER)
//                    }
//                }
//            })
        }
    }
    
    /**
     * Tells the delegate that the authorization status for the application changed.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    /**
     * Tells the delegate that the location manager was unable to retrieve a location value.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}


