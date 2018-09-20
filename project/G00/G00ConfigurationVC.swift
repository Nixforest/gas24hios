//
//  ConfigurationViewController.swift
//  project
//
//  Created by Lâm Phạm on 9/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework
import UserNotifications

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00ConfigurationVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
class G00ConfigurationVC: ParentViewController, UITableViewDelegate, UITableViewDataSource {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    /** Search bar */
    @IBOutlet weak var searchBar: UISearchBar!
    /** Config view */
    @IBOutlet weak var configView: UIView!
    /** Config table view */
    @IBOutlet weak var configTableView: UITableView!
    var _data:      [ConfigBean] = [ConfigBean]()
    
    // MARK: Actions
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.gasServiceItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_GAS_SERVICE_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(issueItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_ISSUE_ITEM),
//                                               object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        // Config view
        configView.translatesAutoresizingMaskIntoConstraints = true
        configView.frame = CGRect(
            x: 0,
            y: configView.frame.minY,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
        
        // Config table view
        configTableView.backgroundColor = GlobalConst.BACKGROUND_COLOR_GRAY
        configTableView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height - searchBar.frame.size.height - getTopHeight())
        searchBar.placeholder = DomainConst.CONTENT00128
        
        // Search bar
        searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchBar.frame = CGRect(
            x: 0,
            y: searchBar.frame.minY,
            width: self.view.frame.size.width,
            height: searchBar.frame.size.height)
        
        // Setup navigation
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00128, isNotifyEnable: true)
        createNavigationBar(title: DomainConst.CONTENT00128)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        setData()
    }
    
    private func setData() {
        _data.append(ConfigBean(id: "1", name: "Test Google Map"))
        _data.append(ConfigBean(id: "2", name: "Test QR code"))
        _data.append(ConfigBean(id: "3", name: "Test Loading"))
        _data.append(ConfigBean(id: "4", name: "Test multi-device"))
        _data.append(ConfigBean(id: "Device name", name: UIDevice.current.name))
        _data.append(ConfigBean(id: "Device model", name: UIDevice.current.model))
        _data.append(ConfigBean(id: "BatteryLevel", name: "\(UIDevice.current.batteryLevel)"))
        _data.append(ConfigBean(id: "BatteryState", name: "\(UIDevice.current.batteryState)"))
        if let identify = UIDevice.current.identifierForVendor {
            _data.append(ConfigBean(id: "IdentifierForVendor", name: "\(identify.description)"))
        }
        
        _data.append(ConfigBean(id: "IsBatteryMonitoringEnabled", name: "\(UIDevice.current.isBatteryMonitoringEnabled)"))
        _data.append(ConfigBean(id: "IsGeneratingDeviceOrientationNotifications", name: "\(UIDevice.current.isGeneratingDeviceOrientationNotifications)"))
        _data.append(ConfigBean(id: "IsMultitaskingSupported", name: "\(UIDevice.current.isMultitaskingSupported)"))
        _data.append(ConfigBean(id: "isProximityMonitoringEnabled", name: "\(UIDevice.current.isProximityMonitoringEnabled)"))
        _data.append(ConfigBean(id: "localizedModel", name: "\(UIDevice.current.localizedModel)"))
        _data.append(ConfigBean(id: "orientation", name: "\(UIDevice.current.orientation)"))
        _data.append(ConfigBean(id: "proximityState", name: "\(UIDevice.current.proximityState)"))
        _data.append(ConfigBean(id: "systemName", name: "\(UIDevice.current.systemName)"))
        _data.append(ConfigBean(id: "systemVersion", name: "\(UIDevice.current.systemVersion)"))
        _data.append(ConfigBean(id: "userInterfaceIdiom", name: "\(UIDevice.current.userInterfaceIdiom)"))
        _data.append(ConfigBean(id: "OS version", name: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"))
        _data.append(ConfigBean(id: "test_local_notify_request", name: "Request local notify Auth"))
        _data.append(ConfigBean(id: "test_local_notify_push", name: "Push local notify"))
        _data.append(ConfigBean(id: "Current date", name: CommonProcess.getCurrentDate()))
        _data.append(ConfigBean(id: "Current time", name: CommonProcess.getCurrentTime()))
        _data.append(ConfigBean(id: "APNS Token", name: BaseModel.shared.getDeviceToken()))
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 2
        switch section {
        case 0:
            return 2
        case 1:
            if BaseModel.shared.checkTrainningMode() {
                return _data.count
            }
            return 0
        default:
            return 0
        }
    }
    
    /**
     * Handle tap on cell.
     */
    func cellAction(_ sender: UIButton) {
        switch sender.tag {
            case 0:     // Information view
                self.pushToView(name: DomainConst.G00_INFORMATION_VIEW_CTRL)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ConfigurationTableViewCell.PARENT_WIDTH = GlobalConst.SCREEN_WIDTH
        let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL, for: indexPath) as! ConfigurationTableViewCell
        switch indexPath.section {
        case 0:                     // Configuration section
            // Custom cell
            switch (indexPath as NSIndexPath).row {
            case 0:             // Information
                cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                             name: DomainConst.CONTENT00139,
                             value: DomainConst.VERSION_CODE_WITH_NAME)
                
            case 1:             // Information
                cell.setData(leftImg: DomainConst.VERSION_TYPE_ICON_IMG_NAME,
                             name: DomainConst.CONTENT00441,
                             value: DomainConst.BLANK)
            default:
                break
                
            }
        case 1:                     // Test section
            if BaseModel.shared.checkTrainningMode() {
                let data = _data[indexPath.row]
                switch data.id {
                case "1":         // Test google map
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test Google Map",
                                 value: DomainConst.BLANK)
                case "2":         // Test QR code
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test QR code",
                                 value: DomainConst.BLANK)
                case "3":         // Test QR code
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test Loading",
                                 value: DomainConst.BLANK)
                case "4":         // Test QR code
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test multi-device",
                                 value: DomainConst.BLANK)
                default:
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: data.id,
                                 value: data.name)
                    break
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell //ConfigurationTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:                     // Configuration section
            switch indexPath.row {
            case 0:
                self.pushToView(name: DomainConst.G00_INFORMATION_VIEW_CTRL)
            case 1:
                self.updateVersionAppStore()
            default:
                break
            }
            break
        case 1:                     // Test section
            let data = _data[indexPath.row]
            switch data.id {
            case "1":
                testGoogleMap()
            case "2":
                testQRCode()
            case "3":
                testLoadingView()
            case "4":
                testMultiDevice()
            case "test_local_notify_request":
                LocalNotification.registerForLocalNotification(on: UIApplication.shared)
            case "test_local_notify_push":
                LocalNotification.dispatchLocalNotification(with: "Notification Title for iOS10+", body: "This is the notification body, works on all versions", at: Date())
            case "APNS Token":
                UIPasteboard.general.string = BaseModel.shared.getDeviceToken()
                self.showAlert(message: "Đã copy giá trị device token vào clipboard. Nhấn OK để tiếp tục.")
            default:
                showAlert(message: data.name)
                break
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
        return 50
    }
    
    private func testGoogleMap() {
        let googleMap = GoogleMapVC(nibName: GoogleMapVC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(googleMap, animated: true)
    }
    
    private func testQRCode() {
        let frameworkBundle = Bundle(identifier: DomainConst.HARPY_FRAMEWORK_BUNDLE_NAME)
        let scan = ScanCodeVC(nibName: ScanCodeVC.theClassName, bundle: frameworkBundle)
        self.navigationController?.pushViewController(scan, animated: true)
    }
    
    private func testLoadingView() {
        let view = LoadingViewVC(nibName: LoadingViewVC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    private func testMultiDevice() {
        let view = MultiDeviceVC(nibName: MultiDeviceVC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(view, animated: true)
    }
}
