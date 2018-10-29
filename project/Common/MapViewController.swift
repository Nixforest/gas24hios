//
//  MapViewController.swift
//  project
//
//  Created by SPJ on 1/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps
import GooglePlaces

//++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
//class MapViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate {
class MapViewController: ParentViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate {
//-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
    // MARK: Properties
    /** Top view */
    private var _topView                = UIView()
    /** Address textfield */
    private var _txtAddress             = UITextField()
    /** Bottom view */
    private var _bottomView             = UIView()
    /** Order button */
    private var _btnOrder               = UIButton()
    /** Material selector view */
    private var _materialSelect         = UIView()
    private var _gasSelector: MaterialSelector?     = nil
    private var _promoteSelector: MaterialSelector? = nil
    /** Type view */
    private var _categoryView           = UIView()
    /** List of category button */
    private var _listButton             = [UIButton]()
    /** Center mark */
    private var _centerMark             = UIImageView()
    /** Map view */
    private var _mapView: GMSMapView?   = nil
    /** Current position of map view */
    public static var _currentPos       = CLLocationCoordinate2D.init()
    /** Agent information */
    private static var _agentInfo       = [AgentInfoBean]()
    private static var _distance        = 0.0
    /** Flag show/hide children controls */
    private var _isShowChildren         = true
    /** Camera zoom value */
    public let _zoomValue: CGFloat      = BaseModel.shared.getZoomValue()
    /** Manager location */
    private let _location               =  CLLocationManager()
    /** Save neares agent information */
    public static var _nearestAgent     = AgentInfoBean()
    /** Material select */
    public static var _gasSelected      = MaterialBean()
    public static var _promoteSelected  = MaterialBean()
    public static var _currentAddress   = DomainConst.BLANK
    //++ BUG0054-SPJ (NguyenPT 20170418) Add new function G07
    /** Current position of user */
    public static var _originPos        = CLLocationCoordinate2D.init()
    //-- BUG0054-SPJ (NguyenPT 20170418) Add new function G07
    
    
    // MARK: Actions
    //++ BUG0048-SPJ (NguyenPT 20170309) Handle stop scroll map when open left menu
    /**
     * Handle left menu will open event
     */
    func leftWillOpen() {
        // Disable scroll map
        _mapView?.settings.scrollGestures   = false
    }
    
    /**
     * Handle left menu did closed event
     */
    func leftDidClose() {
        // Enable scroll map
        _mapView?.settings.scrollGestures   = true
    }
    //-- BUG0048-SPJ (NguyenPT 20170309) Handle stop scroll map when open left menu
    /**
     * Update agent information from server
     * - paramater data: AgentInfoBean object
     */
    public func saveAgentInfo() {
        MapViewController._agentInfo.append(contentsOf: BaseModel.shared.getOrderConfig().agent)
        MapViewController._distance = BaseModel.shared.getOrderConfig().distance_1
    }
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
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        // Menu item tap
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        // Handle display color when training mode is on
//        if BaseModel.shared.checkTrainningMode() {
//            GlobalConst.BUTTON_COLOR_RED = GlobalConst.TRAINING_COLOR
//        } else {    // Training mode off
//            GlobalConst.BUTTON_COLOR_RED = GlobalConst.MAIN_COLOR
//        }
        
        // Do any additional setup after loading the view.
        //++ BUG0059-SPJ (NguyenPT 20170420) Use location service when app is openned, not background
        //_location.requestAlwaysAuthorization()
        //-- BUG0059-SPJ (NguyenPT 20170420) Use location service when app is openned, not background
        _location.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            _location.delegate = self
            _location.desiredAccuracy = kCLLocationAccuracyKilometer
            //++ BUG0059-SPJ (NguyenPT 20170420) Use location service when app is openned, not background
            _location.startUpdatingLocation()
            //_location.startMonitoringSignificantLocationChanges()
            //-- BUG0059-SPJ (NguyenPT 20170420) Use location service when app is openned, not background
        }
        // Setup layout
        var offset  = getTopHeight()
        offset      = setupTopView(offset: offset)
        setupCenterMark()
        setupBottomView()
        
        // NavBar setup
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        //setupNavigationBar(title: BaseModel.shared.getAppName(), isNotifyEnable: BaseModel.shared.checkIsLogin(), isHiddenBackBtn: true)
        createNavigationBar(title: BaseModel.shared.getAppName())
        //-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        self.view.makeComponentsColor()
    }
    
    //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    internal func finishRequestOrderConfig(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderConfigRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.saveOrderConfig(config: model.getRecord())
            setData(notification)
        } else {
            showAlert(message: model.message)
        }
    }
    //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    
    /**
     * Set data event handler
     */
    override func setData(_ notification: Notification) {
        saveAgentInfo()
        // Create marker for all agent
        for item in MapViewController._agentInfo {
            createMarker(info: item.info_agent)
        }
        // Get data from server
        if BaseModel.shared.checkIsLogin() {
            //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//            RequestAPI.requestUpdateConfiguration(view: self)
            UpdateConfigurationRequest.requestUpdateConfiguration(action: #selector(finishRequestUpdateConfig(_:)),
                                                                  view: self)
            //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
        } else {
            // Show login view if user not login yet
            self.pushToView(name: DomainConst.G00_LOGIN_VIEW_CTRL)
        }
        updateNearestAgent()
    }
    
    //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
    /**
     * Finish request update config handler
     */
    func finishRequestUpdateConfig(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        self.updateNotificationStatus()
//        
//        // Get notification count from server
//        if BaseModel.shared.checkIsLogin() {
//            //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
////            RequestAPI.requestNotificationCount(view: self)
//            NotificationCountRequest.requestNotificationCount(action: #selector(updateNotificationStatus(_:)), view: self)
//            //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
//        }
//        //++ BUG0077-SPJ (NguyenPT 20170508) Handle Flag need change pass
//        if BaseModel.shared.getNeedChangePassFlag() {
//            self.pushToView(name: G00ChangePassVC.theClassName)
//        }
//        //-- BUG0077-SPJ (NguyenPT 20170508) Handle Flag need change pass
        
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let data = (notification.object as! String)
        let model = LoginRespModel(jsonString: data)
        LoadingView.shared.hideOverlayView(className: self.theClassName)
        if model.isSuccess() {
            BaseModel.shared.saveTempData(loginModel: model)
            self.updateNotificationStatus()
            if BaseModel.shared.checkIsLogin() {
//                NotificationCountRequest.requestNotificationCount(action: #selector(updateNotificationStatus(_:)), view: self)
            }
            if BaseModel.shared.getNeedChangePassFlag() {
                self.pushToView(name: G00ChangePassVC.theClassName)
            }
        } else {
            showAlert(message: model.message)
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    }
    //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
    
    /**
     * Create all agent marker from agent information
     * - parameter info: Basic agent information
     */
    func createMarker(info: BaseAgentInfoBean) {
        // Get lat and long value from agent information
        let lat         = (info.agent_latitude as NSString).doubleValue
        let long        = (info.agent_longitude as NSString).doubleValue
        let location    = CLLocationCoordinate2D(latitude: lat, longitude: long)
        //if calculateDistance(pos1: self._currentPos, pos2: location) <= MapViewController._distance {
            print(info.agent_name)
            let marker      = GMSMarker()
            // Set icon
            marker.icon     = ImageManager.getImage(named: BaseModel.shared.getAppAgentIcon())
            // Set marker position
            marker.position = location
            marker.title    = info.agent_name
            marker.snippet  = info.agent_address
            // Insert marker into map view
            marker.map      = self._mapView
        //}
    }
    
    /**
     * Calculate the distance (in meters) from the receiver’s location to the specified location.
     * - parameter pos1: Receiver’s location
     * - parameter pos2: Specified location
     * - returns: This method measures the distance between the two locations by tracing a line between them that follows the curvature of the Earth. The resulting arc is a smooth curve and does not take into account specific altitude changes between the two locations
     */
    func calculateDistance(pos1: CLLocationCoordinate2D, pos2: CLLocationCoordinate2D) -> Double {
        let position1 = CLLocation(latitude: pos1.latitude, longitude: pos1.longitude)
        let position2 = CLLocation(latitude: pos2.latitude, longitude: pos2.longitude)
        let distance: CLLocationDistance = position1.distance(from: position2)
        return distance
    }
    
    /**
     * Update nearest agent and material selector
     */
    func updateNearestAgent() {
        var distance = Double.greatestFiniteMagnitude
        for item in MapViewController._agentInfo {
            // Get lat and long value from agent information
            let lat: CLLocationDegrees = (item.info_agent.agent_latitude as NSString).doubleValue
            let long: CLLocationDegrees = (item.info_agent.agent_longitude as NSString).doubleValue
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let currentDist = calculateDistance(pos1: MapViewController._currentPos, pos2: location)
            if distance > currentDist {
                MapViewController._nearestAgent = item
                distance = currentDist
            }
        }
        if distance > MapViewController._distance {
            MapViewController._nearestAgent = AgentInfoBean.init()
        }
        
        // Not found agent
        if MapViewController._nearestAgent.isEmpty() {
            // Reset selected materials
            MapViewController._gasSelected      = MaterialBean.init()
            MapViewController._promoteSelected  = MaterialBean.init()
        } else {    // Found
            // Save selected gas
            if MapViewController._nearestAgent.info_gas.count > 0 {
                MapViewController._gasSelected = MapViewController._nearestAgent.info_gas[0]
            }
//            // Save selected promote
//            if MapViewController._nearestAgent.info_promotion.count > 0 {
//                MapViewController._promoteSelected = MapViewController._nearestAgent.info_promotion[0]
//            }
        }
        
        self.updateMaterialSelector()
    }
    
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        MapViewController._currentPos = (manager.location?.coordinate)!
        MapViewController._originPos = MapViewController._currentPos
        //++ BUG0059-SPJ (NguyenPT 20170420) Use location service when app is openned, not background
        if _mapView != nil {
            return
        }
        //-- BUG0059-SPJ (NguyenPT 20170420) Use location service when app is openned, not background
        let camera = GMSCameraPosition.camera(withLatitude: MapViewController._currentPos.latitude, longitude: MapViewController._currentPos.longitude, zoom: Float(self._zoomValue))
        // Create mapview
        _mapView = GMSMapView.map(withFrame: CGRect(x: 0,
                                                       y: self.getTopHeight(),
                                                       width:GlobalConst.SCREEN_WIDTH,
                                                       height:GlobalConst.SCREEN_HEIGHT - self.getTopHeight()),
                                     camera: camera)
        // Show compass button
        _mapView?.settings.compassButton    = true
        // Turn on my location
        _mapView?.isMyLocationEnabled       = true
        _mapView?.settings.myLocationButton = true
        _mapView?.settings.indoorPicker     = true
        _mapView?.delegate                  = self
        // Move up google logo and mylocation button
        _mapView?.padding = UIEdgeInsets(top: 0, left: 0,
                                         bottom: (GlobalConst.BUTTON_CATEGORY_SIZE * 2.5 + GlobalConst.BUTTON_H + GlobalConst.MARGIN + GlobalConst.MARGIN_CELL_X * 2),
                                         right: 0)
        
        self.view.insertSubview(_mapView!, at: 0)
        
        // Check if order config does exist
        if BaseModel.shared.getOrderConfig().agent.count != 0 {
            // Get from base model
            MapViewController._agentInfo.append(contentsOf: BaseModel.shared.getOrderConfig().agent)
            MapViewController._distance = BaseModel.shared.getOrderConfig().distance_1
        } else {
            // Request from server
            //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
            //OrderConfigRequest.requestOrderConfig(action: #selector(setData(_:)), view: self)
            OrderConfigRequest.requestOrderConfig(action: #selector(finishRequestOrderConfig(_:)), view: self)
            //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
        }
    }
    
    /**
     * Show/hide children control
     * - parameter isHide: True -> Hide all children control, False -> Show all children control
     */
    func showHideChildren(isHide: Bool) {
        _isShowChildren = isHide
        showChildren()
    }
    
    /**
     * Hide keyboard
     */
    func showChildren() {
        self.view.endEditing(true)
        if _isShowChildren {
            // Hide
            UIView.animate(withDuration: 0.3, animations: {
                self._topView.frame = CGRect(x: self._topView.frame.origin.x,
                                             y: self._topView.frame.origin.y - self._topView.frame.height,
                                             width: self._topView.frame.width,
                                             height: self._topView.frame.height)
                self._bottomView.frame = CGRect(x: self._bottomView.frame.origin.x,
                                                y: self._bottomView.frame.origin.y + self._bottomView.frame.height, width: self._bottomView.frame.width,
                                                height: self._bottomView.frame.height)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self._topView.frame = CGRect(x: self._topView.frame.origin.x,
                                             y: self._topView.frame.origin.y + self._topView.frame.height,
                                             width: self._topView.frame.width,
                                             height: self._topView.frame.height)
                self._bottomView.frame = CGRect(x: self._bottomView.frame.origin.x,
                                                y: self._bottomView.frame.origin.y - self._bottomView.frame.height, width: self._bottomView.frame.width,
                                                height: self._bottomView.frame.height)
            })
        }
        _isShowChildren =  !_isShowChildren
    }
    
    /**
     * Setup all components of top view
     * - parameter offset: Input offset
     * - returns: Output offset
     */
    func setupTopView(offset: CGFloat) -> CGFloat {
        // Address textfield
        _txtAddress.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                   y: GlobalConst.MARGIN,
                                   width: GlobalConst.BUTTON_W,
                                   height: GlobalConst.BUTTON_H)
        _txtAddress.placeholder         = DomainConst.BLANK
        _txtAddress.layer.cornerRadius  = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        _txtAddress.backgroundColor     = UIColor.white
        _txtAddress.font                = UIFont.systemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE_1)
        _txtAddress.delegate            = self
        setLeftViewForTextField(textField: _txtAddress, named: DomainConst.ADDRESS_IMG_NAME)
        
        // Top view
        self._topView.frame = CGRect(x: 0, y: offset,
                                     width: GlobalConst.SCREEN_WIDTH,
                                     height: GlobalConst.MARGIN * 2 + GlobalConst.EDITTEXT_H)
        self._topView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        self._topView.addSubview(_txtAddress)
        
        self.view.addSubview(_topView)
        return offset
    }
    
    /**
     * Create center marker
     */
    func setupCenterMark() {
        self._centerMark.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.CENTER_MARKER_SIZE_WIDTH) / 2,
                                        y: (GlobalConst.SCREEN_HEIGHT - getTopHeight()/* - GlobalConst.CENTER_MARKER_SIZE_HEIGHT*/) / 2 - GlobalConst.CENTER_MARKER_SIZE_HEIGHT/* + getTopHeight() - GlobalConst.MARGIN*/,
                                        width: GlobalConst.CENTER_MARKER_SIZE_WIDTH,
                                        height: GlobalConst.CENTER_MARKER_SIZE_HEIGHT)
        self._centerMark.image = ImageManager.getImage(named: DomainConst.CENTER_MARKER_IMG_NAME)
        self._centerMark.contentMode = .scaleAspectFit
        self.view.addSubview(self._centerMark)
    }
    
    /**
     * Setup bottom view layout
     */
    func setupBottomView() {
//        let img = ImageManager.getImage(named: DomainConst.ORDER_START_ICON_IMG_NAME)
//        let tintedImg = img?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        CommonProcess.createButtonLayout(btn: self._btnOrder,
//                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
//                                         y: 0,
//                                         text: DomainConst.CONTENT00236.uppercased())
//        self._btnOrder.addTarget(self, action: #selector(btnOrderTapped), for: .touchUpInside)
//        self._btnOrder.tintColor = UIColor.white
//        self._btnOrder.setImage(tintedImg, for: UIControlState())
//        self._btnOrder.imageView?.contentMode = .scaleAspectFit
        CommonProcess.createButtonLayout(btn: self._btnOrder,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: 0,
                                         text: DomainConst.CONTENT00236.uppercased(),
                                         action: #selector(btnOrderTapped),
                                         target: self,
                                         img: DomainConst.ORDER_START_ICON_IMG_NAME,
                                         tintedColor: UIColor.white)
        self._btnOrder.imageEdgeInsets = UIEdgeInsets(top: GlobalConst.MARGIN_CELL_X,
                                                      left: GlobalConst.MARGIN_CELL_X,
                                                      bottom: GlobalConst.MARGIN_CELL_X,
                                                      right: GlobalConst.MARGIN_CELL_X)
        setupMaterialSelector()
        setupCategoryView()
        // Bottom view
        let btmHeight = GlobalConst.BUTTON_CATEGORY_SIZE * 2.5 + GlobalConst.BUTTON_H + GlobalConst.MARGIN + GlobalConst.MARGIN_CELL_X * 2
        self._bottomView.frame = CGRect(x: 0,
                                        y: GlobalConst.SCREEN_HEIGHT - btmHeight,
                                        width: GlobalConst.SCREEN_WIDTH,
                                        height: btmHeight)
        self._bottomView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        self._bottomView.addSubview(_btnOrder)
        self._bottomView.addSubview(_materialSelect)
        self._bottomView.addSubview(_categoryView)
        self.view.addSubview(_bottomView)
    }
    
    func btnOrderTapped(_ sender: AnyObject) {
        
    }
    
    /**
     * Setup material selector and its components
     */
    func setupMaterialSelector() {
        let halfWidth = GlobalConst.SCREEN_WIDTH / 2 - GlobalConst.MARGIN
        _gasSelector = MaterialSelector(iconPath: DomainConst.CATEGORY_VIP_IMG_NAME,
                                        name: DomainConst.CONTENT00237,
                                        price: DomainConst.BLANK,
                                        width: halfWidth,
                                        height: GlobalConst.BUTTON_CATEGORY_SIZE * 1.5)
        _gasSelector?.frame = CGRect(x: 0, y: 0,
                                     width: halfWidth,
                                     height: GlobalConst.BUTTON_CATEGORY_SIZE * 1.5)
        self._materialSelect.addSubview(_gasSelector!)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gasSelectorTapped(_:)))
        _gasSelector?.addGestureRecognizer(gesture)
        
        _promoteSelector = MaterialSelector(iconPath: DomainConst.CATEGORY_VIP_IMG_NAME,
                                            name: DomainConst.CONTENT00238,
                                            price: DomainConst.BLANK,
                                            width: halfWidth,
                                            height: GlobalConst.BUTTON_CATEGORY_SIZE * 1.5)
        _promoteSelector?.frame = CGRect(x: (_gasSelector?.frame.maxX)!, y: 0,
                               width: halfWidth,
                               height: GlobalConst.BUTTON_CATEGORY_SIZE * 1.5)
        self._materialSelect.addSubview(_promoteSelector!)
        let gesturePromote = UITapGestureRecognizer(target: self, action: #selector(promoteSelectorTapped(_:)))
        _promoteSelector?.addGestureRecognizer(gesturePromote)
        
        self._materialSelect.frame = CGRect(x: GlobalConst.MARGIN,
                                            y: GlobalConst.BUTTON_H + GlobalConst.MARGIN,
                                            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN * 2,
                                            height: GlobalConst.BUTTON_CATEGORY_SIZE * 1.5)
        self._materialSelect.backgroundColor = UIColor.white
    }
    
    func gasSelectorTapped(_ sender: AnyObject) {
        G04F01S02VC.setData(data: MapViewController._nearestAgent.info_gas)
        self.pushToView(name: G04Const.G04_F01_S02_VIEW_CTRL)
    }
    public func setData1(_ notification: Notification) {
    }
    
    func promoteSelectorTapped(_ sender: AnyObject) {
        G04F01S03VC.setData(data: MapViewController._nearestAgent.info_promotion)
        self.pushToView(name: G04Const.G04_F01_S03_VIEW_CTRL)
    }
    
    /**
     * Update material selector view data
     */
    func updateMaterialSelector() {
        // Found nearest agent information
        if !MapViewController._gasSelected.material_id.isEmpty {
            self._gasSelector?.updateContent(iconPath: MapViewController._gasSelected.material_image,
                                             name: MapViewController._gasSelected.material_name,
                                             price: MapViewController._gasSelected.material_price)
        } else {
            self._gasSelector?.updateContent(iconPath: DomainConst.BLANK,
                                             name: DomainConst.CONTENT00237,
                                             price: DomainConst.BLANK)
        }
        // Found nearest agent information
        if !MapViewController._promoteSelected.material_id.isEmpty {
            self._promoteSelector?.updateContent(iconPath: MapViewController._promoteSelected.material_image,
                                             name: MapViewController._promoteSelected.material_name,
                                             price: MapViewController._promoteSelected.material_price)
        } else {
            self._promoteSelector?.updateContent(iconPath: DomainConst.BLANK,
                                             name: DomainConst.CONTENT00238,
                                             price: DomainConst.BLANK)
        }
    }
    
    /**
     * Setup category view and its components.
     */
    func setupCategoryView() {
        // Attemp list config
        var listConfig = [ConfigBean]()
        listConfig.append(ConfigBean(id: DomainConst.CATEGORY_TYPE_VIP, name: "VIP"))
        listConfig.append(ConfigBean(id: DomainConst.CATEGORY_TYPE_GAS, name: "GAS"))
        listConfig.append(ConfigBean(id: DomainConst.CATEGORY_TYPE_UTILITY, name: "PHỤ KIỆN"))
        // Attemp list image
        var listImg = [(String, String)]()
        listImg.append((DomainConst.CATEGORY_VIP_IMG_NAME, DomainConst.CATEGORY_VIP_ACTIVE_IMG_NAME))
        listImg.append((DomainConst.CATEGORY_GAS_IMG_NAME, DomainConst.CATEGORY_GAS_ACTIVE_IMG_NAME))
        listImg.append((DomainConst.CATEGORY_UTILITY_IMG_NAME, DomainConst.CATEGORY_UTILITY_ACTIVE_IMG_NAME))
        // Calculate size
        let btnWidth    = GlobalConst.BUTTON_CATEGORY_SIZE
        let margin      = GlobalConst.MARGIN
        let count       = listConfig.count
        let btnSpace    = (GlobalConst.SCREEN_WIDTH - 2 * margin - btnWidth) / (CGFloat)(count - 1)
        for i in 0..<listConfig.count {
            // Calculate frame of button
            let frame = CGRect(x: margin + CGFloat(i) * btnSpace, y: margin / 2,
                               width: btnWidth,
                               height: btnWidth)
            let btn = CategoryButton(frame: frame, icon: listImg[i].0, iconActive: listImg[i].1, title: listConfig[i].name, id: listConfig[i].id)
            
            btn.addTarget(self, action: #selector(enableButton), for: .touchUpInside)
            // Select default button
            if listConfig[i].id == DomainConst.CATEGORY_TYPE_GAS {
                btn.isSelected = true
            }
            _listButton.append(btn)
            self._categoryView.addSubview(btn)
        }
        // Set size of category view
        self._categoryView.frame = CGRect(x: 0,
                                          y: _materialSelect.frame.maxY + GlobalConst.MARGIN_CELL_X,
                                          width: GlobalConst.SCREEN_WIDTH,
                                          height: btnWidth + GlobalConst.MARGIN_CELL_X)
        self._categoryView.backgroundColor = UIColor.white
    }
    
    /**
     * Handle when tap on category buttons
     * - parameter sender: Button object
     */
    func enableButton(_ sender: AnyObject) {
        // Handle by button identify
        switch ((sender as! UIButton).accessibilityIdentifier!) {
        case DomainConst.CATEGORY_TYPE_VIP, DomainConst.CATEGORY_TYPE_UTILITY:
            showAlert(message: DomainConst.CONTENT00197)
            return
        case DomainConst.CATEGORY_TYPE_GAS:
            break
        default:
            break
        }
        // Release selection from all button
        for btn in self._listButton {
            btn.isSelected = false
        }
        // Select current tapped button
        (sender as! UIButton).isSelected = true
    }
    
    /**
     * Set left image for text field
     * - parameter textField:   Text field object
     * - parameter named:       Image name
     */
    func setLeftViewForTextField(textField: UITextField, named: String) {
        textField.leftViewMode = .always
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                width: GlobalConst.EDITTEXT_H - GlobalConst.MARGIN_CELL_X,
                                                height: GlobalConst.EDITTEXT_H - GlobalConst.MARGIN_CELL_X))
        let img             = ImageManager.getImage(named: named)
        imgView.image       = img
        textField.leftView  = imgView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Finish detect current location
     */
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let center = position.target
        GMSGeocoder().reverseGeocodeCoordinate(center) { (response, error) in
            if error != nil {
                return
            }
            // Get address
            let address = response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER)
            // Use line below to add country into address result
            //address = address?.appendingFormat(", %@", (response?.firstResult()?.country)!)
            // Set for address textbox value
            //self._txtAddress.text = address
            self.setAddressText(address: address!)
        }
        // Show children
        if !self._isShowChildren {
            self.showHideChildren(isHide: false)
        }
        MapViewController._currentPos = center
        
        updateNearestAgent()
    }
    
    /**
     * Mapview changing
     */
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didChange: " + "\(position)")
    }
    
    /**
     * Handle event start drag map view
     */
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove: " + "\(gesture)")
        // Hide children
        if self._isShowChildren {
            self.showHideChildren(isHide: true)
        }
    }
    
    /**
     * Tells the delegate that editing began in the specified text field.
     */
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        // Start search address from google toolkit
        let autocompleteController      = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    public func setAddressText(address: String) {
        self._txtAddress.text = address
        MapViewController._currentAddress = address
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /**
     * Move camera
     */
    public func moveCamera(position: CLLocationCoordinate2D) {
        MapViewController._currentPos = position
        let camera       = GMSCameraPosition.camera(withLatitude: position.latitude,
                                                    longitude: position.longitude,
                                                    zoom: Float(self._zoomValue))
        let bounds       = GMSCoordinateBounds.init()
        bounds.includingCoordinate(position)
        self._mapView?.camera = camera
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateMaterialSelector()
    }
}

/**
 * Implement GMSAutocompleteViewControllerDelegate
 */
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    /**
     * Handle the user's selection.
     */
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        // Update address text
        self.setAddressText(address: place.formattedAddress!)
        // Update camera position
        self.moveCamera(position: place.coordinate)
        // Hide current autocomplete view
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Handle fail event
     */
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    /**
     * User canceled the operation.
     */
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Turn the network activity indicator on and off again.
     */
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    /**
     * Turn the network activity indicator on and off again.
     */
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
