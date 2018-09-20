//
//  HomeViewController.swift
//  project
//
//  Created by Lâm Phạm on 10/20/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00HomeVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
class G00HomeVC: ParentViewController, UITableViewDataSource, UITableViewDelegate {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    /** List text content */
    var aList:[String] = [DomainConst.CONTENT00130, DomainConst.CONTENT00041, DomainConst.CONTENT00099, DomainConst.CONTENT00098, DomainConst.CONTENT00100]
    /** List icon image */
    var aListIcon:[String] = [
        DomainConst.ORDER_GAS_IMG_NAME,
        DomainConst.UPHOLD_REQUEST_IMG_NAME,
        DomainConst.UPHOLD_LIST_IMG_NAME,
        DomainConst.SERVICE_RATING_IMG_NAME,
        DomainConst.ACCOUNT_IMG_NAME
    ]
    /** Table view */
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: Actions
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(configItemTap(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_COFIG_ITEM_HOMEVIEW),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(registerItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_REGISTER_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(logoutItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_LOGOUT_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(issueItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_ISSUE_ITEM), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(loginItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_LOGIN_ITEM), object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    //MARK: ViewDidLoad
    /**
     * View did load
     */
     override func viewDidLoad() {
        super.viewDidLoad()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        // Menu item tap
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        
        // Handle display color when training mode is on
        if BaseModel.shared.checkTrainningMode() {
            GlobalConst.BUTTON_COLOR_RED = GlobalConst.TRAINING_COLOR
        } else {    // Training mode off
            GlobalConst.BUTTON_COLOR_RED = GlobalConst.MAIN_COLOR
        }
        
        // Background
        self.view.layer.borderWidth = GlobalConst.PARENT_BORDER_WIDTH
        self.view.layer.borderColor = GlobalConst.PARENT_BORDER_COLOR_GRAY.cgColor
        
        // ViewBackgnd Frame
        let marginX: CGFloat = 0.0
        let marginY: CGFloat = 0.0
        homeTableView.translatesAutoresizingMaskIntoConstraints = true
        homeTableView.frame = CGRect(x: GlobalConst.PARENT_BORDER_WIDTH + marginX,
                                     y: marginY,
                                     width: GlobalConst.SCREEN_WIDTH - 2 * marginX,
                                     height: GlobalConst.SCREEN_HEIGHT - 2 * marginY)
        homeTableView.backgroundColor = GlobalConst.PARENT_BORDER_COLOR_GRAY
        homeTableView.separatorStyle = .none
        
        // NavBar setup
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00108, isNotifyEnable: BaseModel.shared.checkIsLogin(), isHiddenBackBtn: true)
        createNavigationBar(title: DomainConst.CONTENT00108)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        
        /** Cell register */
        self.homeTableView.register(UINib(nibName: DomainConst.G00_HOME_CELL, bundle: nil), forCellReuseIdentifier: DomainConst.G00_HOME_CELL)
        
        // Notify set data
        //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//        NotificationCenter.default.addObserver(self, selector: #selector(G00HomeVC.setData(_:)), name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_SET_DATA_HOMEVIEW), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationStatus(_:)), name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_UPDATE_NOTIFY_HOMEVIEW), object: nil)
        //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
        
        // Get data from server
        if BaseModel.shared.checkIsLogin() {
            //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//            RequestAPI.requestUpdateConfiguration(view: self)
            UpdateConfigurationRequest.requestUpdateConfiguration(action: #selector(self.setData(_:)),
                                                                  view: self)
            //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
        }
        
        // Handle waiting register code confirm
        if !BaseModel.shared.getTempToken().isEmpty {
            self.processInputConfirmCode(message: "")
        }
    }
    
    /**
     * Set data.
     */
    override func setData(_ notification: Notification) {
        self.homeTableView.reloadData()
        self.updateNotificationStatus()
        
        // Get notification count from server
        if BaseModel.shared.checkIsLogin() {
            //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//            RequestAPI.requestNotificationCount(view: self)
//            NotificationCountRequest.requestNotificationCount(action: #selector(updateNotificationStatus(_:)), view: self)
            //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
        }
    }

    /**
     * Did receive memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table view setup
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.G00_HOME_CELL, for: indexPath) as! G00HomeCell
        cell.homeCellImageView.image = ImageManager.getImage(named: aListIcon[(indexPath as NSIndexPath).row])
        cell.titleLbl.text = aList[(indexPath as NSIndexPath).row]
        // cell text color
        cell.titleLbl.textColor = UIColor.white
        // cell selection style
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // cell background color
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.backgroundColor = ColorFromRGB().getColorFromRGB(0x29B6F6)
        case 1:
            cell.backgroundColor = ColorFromRGB().getColorFromRGB(0x666666)
        case 2:
            cell.backgroundColor = ColorFromRGB().getColorFromRGB(0xFAB102)
        case 3:
            cell.backgroundColor = ColorFromRGB().getColorFromRGB(0xFF673E)
        case 4:
            cell.backgroundColor = ColorFromRGB().getColorFromRGB(0x8C60FF)
        default: break
        }
        setShowHideItem(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    /**
     * Handle show/hide item on home view
     * - parameter cell:        Cell item
     * - parameter indexPath:   Indexpath
     */
    func setShowHideItem(cell: G00HomeCell, indexPath: IndexPath) {
        // User is logging
        if BaseModel.shared.checkIsLogin() {
            switch (indexPath as NSIndexPath).row {
            case 0:         // Order gas
                //cell.isHidden = !BaseModel.shared.isCustomerUser()
                cell.isHidden = true
            case 1:         // Create uphold
                cell.isHidden = !BaseModel.shared.checkAllowAccess(key: DomainConst.KEY_UPHOLD_CREATE)
            case 2:         // Uphold list
                cell.isHidden = !BaseModel.shared.checkAllowAccess(key: DomainConst.KEY_UPHOLD_LIST)
            case 3:         // Uphold rating
                cell.isHidden = !BaseModel.shared.checkAllowAccess(key: DomainConst.KEY_UPHOLD_RATING)
            case 4:         // Account -> Always show
                cell.isHidden = false
            default: break
            }
        } else {    // Not login
            switch (indexPath as NSIndexPath).row {
            case 0:      // Order gas + Create uphold -> Always show
                //cell.isHidden = false
                cell.isHidden = true
            case 1, 2, 3, 4:   // Uphold list + Uphold rating + Account -> Always hide
                cell.isHidden = true
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return setCellHeight(indexPath: indexPath)
    }
    
    /**
     * Set cell height
     * - parameter indexPath:   Indexpath
     */
    func setCellHeight(indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0.0
        if BaseModel.shared.checkIsLogin() {
            switch (indexPath as NSIndexPath).row {
            case 0:         // Order gas
                //rowHeight = BaseModel.shared.isCustomerUser() ? GlobalConst.CELL_HEIGHT_SHOW : GlobalConst.CELL_HEIGHT_HIDE
                rowHeight = 0
            case 1:         // Create uphold
                rowHeight = BaseModel.shared.checkAllowAccess(key: DomainConst.KEY_UPHOLD_CREATE) ? GlobalConst.CELL_HEIGHT_SHOW : GlobalConst.CELL_HEIGHT_HIDE
            case 2:         // Uphold list
                rowHeight = BaseModel.shared.checkAllowAccess(key: DomainConst.KEY_UPHOLD_LIST) ? GlobalConst.CELL_HEIGHT_SHOW : GlobalConst.CELL_HEIGHT_HIDE
            case 3:         // Uphold rating
                rowHeight = BaseModel.shared.checkAllowAccess(key: DomainConst.KEY_UPHOLD_RATING) ? GlobalConst.CELL_HEIGHT_SHOW : GlobalConst.CELL_HEIGHT_HIDE
            case 4:         // Account -> Always show
                rowHeight = GlobalConst.CELL_HEIGHT_SHOW
            default: break
            }
        } else {    // Not login
            switch (indexPath as NSIndexPath).row {
            case 0:      // Order gas + Create uphold -> Always show
                //rowHeight = GlobalConst.CELL_HEIGHT_SHOW
                rowHeight = 0
            case 1, 2, 3, 4:   // Uphold list + Uphold rating + Account -> Always hide
                rowHeight = GlobalConst.CELL_HEIGHT_HIDE
            default: break
            }
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:     // New uphold
            if BaseModel.shared.user_info == nil {
                // User information does not exist
                //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
                //RequestAPI.requestUserProfile(action: #selector(emptyMethod(_:)), view: self)
                UserProfileRequest.requestUserProfile(action: #selector(emptyMethod(_:)), view: self)
                //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
            }
            self.pushToView(name: DomainConst.G01_F01_VIEW_CTRL)
        case 2: // List uphold
            self.pushToView(name: DomainConst.G01_F00_S01_VIEW_CTRL)
        case 4: // User profile
            self.pushToView(name: DomainConst.G00_ACCOUNT_VIEW_CTRL)
        case 3:
            if !BaseModel.shared.lastUpholdId.isEmpty {
                BaseModel.shared.sharedString = BaseModel.shared.lastUpholdId
                // Move to G01_F03 rating view
                self.pushToView(name: DomainConst.G01_F03_VIEW_CTRL)
            }
        default:
            break
        }
    }
    
    /**
     * View did appear
     */
    override func viewDidAppear(_ animated: Bool) {
        //notification button enable/disable
        self.updateNotificationStatus()
        self.homeTableView.reloadData()
        
        // Get notification count from server
        if BaseModel.shared.checkIsLogin() {
            //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//            RequestAPI.requestNotificationCount(view: self)
            NotificationCountRequest.requestNotificationCount(action: #selector(updateNotificationStatus(_:)), view: self)
            //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
        }
        
        //++ BUG0049-SPJ (NguyenPT 20170313) Handle notification received
        // Check open by notification
//        if BaseModel.shared.checkNotificationExist() {
//            if BaseModel.shared.checkIsLogin() {
//                if BaseModel.shared.isUpholdNotification() {
//                    self.pushToView(name: DomainConst.G01_F00_S01_VIEW_CTRL)
//                }
//            } else {
//                moveToLoginVC()
//            }
//        }
        //-- BUG0049-SPJ (NguyenPT 20170313) Handle notification received
        
        // Handle display color when training mode is on
        if BaseModel.shared.checkTrainningMode() {
            GlobalConst.BUTTON_COLOR_RED = GlobalConst.TRAINING_COLOR
        } else {    // Training mode off
            GlobalConst.BUTTON_COLOR_RED = GlobalConst.MAIN_COLOR
        }
    }
    
    /**
     * Move to login view
     */
    func moveToLoginVC() {
        self.pushToView(name: DomainConst.G00_LOGIN_VIEW_CTRL)
    }
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view.addSubview(mapView)
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
}
