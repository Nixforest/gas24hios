//
//  G00CheckLocation.swift
//  project
//
//  Created by SPJ on 10/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps
class G00CheckLocation: ChildExtViewController {
    /** Location */
    let locationManager:    CLLocationManager   = CLLocationManager()
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        G12F01S01VC._isFirstUse = false
        loadingView.startAnimating()
        // Location setting
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                locationManager.requestWhenInUseAuthorization()
                showAlert(message: DomainConst.CONTENT00529,
                          okHandler: {
                            alert in
                            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                })
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            showAlert(message: DomainConst.CONTENT00529,
                      okHandler: {
                        alert in
                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
            }
            )}
//        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
//            locationManager.requestWhenInUseAuthorization()
//            showAlert(message: DomainConst.CONTENT00529,
//                      okHandler: {
//                        alert in
//                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
//            })
//            //locationManager.startUpdatingLocation()
//        } else {
//            locationManager.startUpdatingLocation()
//        }
        // Do any additional setup after loading the view.
    }
    
    /**
     * Handle when finish open confirm screen
     */
    func finishOpenLogin() -> Void {
        print("finishOpenABC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.dismiss(animated: true, completion: finishDismissLogin)
        
    }
    /**
     * Handle when finish dismiss login screen
     */
    internal func finishDismissLogin() -> Void {
        print("finishDismissLogin")
        let view = G00LoginExtVC(nibName: G00LoginExtVC.theClassName, bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.present(view, animated: true, completion: finishOpenLogin)
        }
    }
}

// MARK: Protocol - CLLocationManagerDelegate
extension G00CheckLocation: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if let location: CLLocation = locations.last {
            if BaseModel.shared.checkIsLogin(){
                G12F01S01VC._currentPos = location.coordinate
                self.dismiss(animated: true, completion: nil)
            }
            else{
                G12F01S01VC._currentPos = location.coordinate
                self.dismiss(animated: true, completion: finishDismissLogin)
            }
            
        }
    }
    
    /**
     * Tells the delegate that the authorization status for the application changed.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            manager.startUpdatingLocation()
//        }
        switch status{
        case .denied, .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
            showAlert(message: DomainConst.CONTENT00529,
                      okHandler: {
                        alert in
                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
            })
            break
        case .authorizedWhenInUse : 
            manager.startUpdatingLocation()
            break
        default:
            manager.startUpdatingLocation()
            break
        }
    }
    
    /**
     * Tells the delegate that the location manager was unable to retrieve a location value.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

