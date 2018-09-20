//
//  G12F01S02VC.swift
//  project
//
//  Created by SPJ on 9/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps
import GooglePlaces

class G12F01S02VC: BaseParentViewController {
    // MARK: Properties
    /** Map view */
    @IBOutlet weak var viewMap:     GMSMapView!
    /** Location */
    private let locationManager:    CLLocationManager   = CLLocationManager()
    /** Service request direction */
    public let directionService:    DirectionService    = DirectionService()
    /** Status Order */
    var lblStatus:              UILabel     = UILabel()
    /** Status view */
    var statusView:             UIView      = UIView()
    /** List status config */
    var listStatusConfig:       [ConfigBean] = [
        ConfigBean(id: String(OrderStatusEnum.STATUS_CREATE.rawValue),
                   name: DomainConst.CONTENT00130),
        ConfigBean(id: String(OrderStatusEnum.STATUS_WAIT_CONFIRM.rawValue),
                   name: DomainConst.CONTENT00513),
        ConfigBean(id: String(OrderStatusEnum.STATUS_CONFIRMED.rawValue),
                   name: DomainConst.CONTENT00514),
        ConfigBean(id: String(OrderStatusEnum.STATUS_DELIVERING.rawValue),
                   name: DomainConst.CONTENT00515),
        ConfigBean(id: String(OrderStatusEnum.STATUS_COMPLETE.rawValue),
                   name: DomainConst.CONTENT00520)
    ]
    /** List status icon */
    var listStatusIcon:         [(String, String)] = [
        (DomainConst.ORDER_STATUS_CREATE_INACTIVE_IMG_NAME,
         DomainConst.ORDER_STATUS_CREATE_ACTIVE_IMG_NAME),
        (DomainConst.ORDER_STATUS_WAITING_INACTIVE_IMG_NAME,
         DomainConst.ORDER_STATUS_WAITING_ACTIVE_IMG_NAME),
        (DomainConst.ORDER_STATUS_CONFIRMED_INACTIVE_IMG_NAME,
         DomainConst.ORDER_STATUS_CONFIRMED_ACTIVE_IMG_NAME),
        (DomainConst.ORDER_STATUS_DELIVERING_INACTIVE_IMG_NAME,
         DomainConst.ORDER_STATUS_DELIVERING_ACTIVE_IMG_NAME),
        (DomainConst.ORDER_STATUS_COMPLETE_INACTIVE_IMG_NAME,
         DomainConst.ORDER_STATUS_COMPLETE_ACTIVE_IMG_NAME)
    ]
    /** List of category button */
    var listStatusButtons:    [UIButton]  = [UIButton]()
    /** Collapse view */
    var collapseView:               UIView              = UIView()
    /** Flag collapsed */
    var isCollapsed:                Bool                = true
    /** Employee label */
    var lblEmployeeTitle:           UILabel             = UILabel()
    /** Button collapse */
    var btnCollapse:                UIButton            = UIButton()
    /** Top view */
    private var _topView:           UIView              = UIView()
    /** Avatar image */
    var imgAvatar:                  UIImageView         = UIImageView()
    /** Label Employee name */
    var lblEmployeeName:            UILabel             = UILabel()
    /** Label Employee code */
    var lblEmployeeCode:            UILabel             = UILabel()
    /** Label Employee code value */
    var lblEmployeeCodeValue:       UILabel             = UILabel()
    /** Label agent */
    var lblAgent:                   UILabel             = UILabel()
    /** Rating bar */
    var ratingBar:                  RatingBar           = RatingBar()
    /** Button chat */
    var btnChat:                    UIButton            = UIButton()
    /** Button phone */
    var btnPhone:                   UIButton            = UIButton()
    /** Center mark */
    private var _centerMark:        UIImageView         = UIImageView()
    /** Origin position */
    public var _source:             (lat: Double, long: Double) = (10.7968085, 106.705285)
    /** Origin position */
    public var _destination:        (lat: Double, long: Double) = (10.805353620543599,106.71155154705048)
//    /** Actions view */
//    var actionsView:                UIView      = UIView()
//    /** List of actions button */
//    var listActionsButtons:         [UIButton]  = [UIButton]()
//    /** List of actions label */
//    var listActionsLabels:          [UILabel]   = [UILabel]()
//    // Attemp list config
//    var listActionsConfig:          [ConfigBean] = [
//        ConfigBean(id: DomainConst.ACTION_TYPE_NONE, name: DomainConst.CONTENT00485),
//        ConfigBean(id: DomainConst.ACTION_TYPE_NONE, name: DomainConst.CONTENT00486),
//        ConfigBean(id: DomainConst.ACTION_TYPE_NONE, name: DomainConst.CONTENT00484),
//        ConfigBean(id: DomainConst.ACTION_TYPE_SUPPORT, name: DomainConst.CONTENT00484)
//    ]
    /** Data */
    var _data:                      OrderBean   = OrderBean()
    /** Detail direction */
    var detailDirection:            String      = DomainConst.BLANK
    
    // MARK: Constant
    // Top view
    var DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_HD = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_HD
    var DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD
    var DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD_L = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD_L
    var DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD     = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L  = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    
//    // Category button
//    var BUTTON_ACTION_REAL_SIZE_HD    = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_HD
//    var BUTTON_ACTION_REAL_SIZE_FHD   = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD
//    var BUTTON_ACTION_REAL_SIZE_FHD_L = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD_L
    
    // Status
    var STATUS_VIEW_REAL_WIDTH_HD       = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var STATUS_VIEW_REAL_WIDTH_FHD      = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var STATUS_VIEW_REAL_WIDTH_FHD_L    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    
    // Category button
    var CATEGORY_BUTTON_REAL_SIZE_HD    = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_HD
    var CATEGORY_BUTTON_REAL_SIZE_FHD   = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD
    var CATEGORY_BUTTON_REAL_SIZE_FHD_L = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Map view setting
        settingMap()
        
        // Location setting
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
        self.isCollapsed = true
        showHideTopView(isShow: !self.isCollapsed)
        
        // Navigation
        self.createNavigationBar(title: "Bản đồ")
        
        // Notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orderFinish(_:)),
            name: NSNotification.Name(rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
            object: nil)
        
        // Center mark
        createCenterMark()
//        self.addBotMsg(note: DomainConst.CONTENT00498,
//                       description: DomainConst.CONTENT00498)
        self.addBotMsg(note: DomainConst.CONTENT00498,
                       description: DomainConst.CONTENT00533)
        changeMode(value: OrderStatusEnum.STATUS_DELIVERING)
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
        // Top view
        DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_HD = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_HD
        DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD
        DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD_L = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD_L
        DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD     = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
        DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
        DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L  = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
        
//        // Category button
//        BUTTON_ACTION_REAL_SIZE_HD    = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_HD
//        BUTTON_ACTION_REAL_SIZE_FHD   = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD
//        BUTTON_ACTION_REAL_SIZE_FHD_L = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD_L
        
        // Status
        STATUS_VIEW_REAL_WIDTH_HD       = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
        STATUS_VIEW_REAL_WIDTH_FHD      = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
        STATUS_VIEW_REAL_WIDTH_FHD_L    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
        
        // Category button
        CATEGORY_BUTTON_REAL_SIZE_HD    = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_HD
        CATEGORY_BUTTON_REAL_SIZE_FHD   = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD
        CATEGORY_BUTTON_REAL_SIZE_FHD_L = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD_L
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        createStatusLabel()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            createStatusViewHD()
            createCollapseView()
            createTopViewHD()
//            createActionsViewHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                createStatusViewFHD()
                createCollapseView()
                createTopViewFHD()
//                createActionsViewFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                createStatusViewFHD_L()
                createCollapseView()
                createTopViewFHD_L()
//                createActionsViewFHD_L()
                break
            default:
                break
            }
            break
        default:
            break
        }
        self.createCenterMark()
        self.view.addSubview(_centerMark)
        self.view.addSubview(_topView)
        self.view.addSubview(collapseView)
        self.view.addSubview(lblStatus)
        self.view.addSubview(statusView)
//        self.view.addSubview(actionsView)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        updateStatusLabel()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            updateStatusViewHD()
            updateCollapseView()
            updateTopViewHD(isShow: !self.isCollapsed)
//            updateActionsViewHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updateStatusViewFHD()
                updateCollapseView()
                updateTopViewFHD(isShow: !self.isCollapsed)
//                updateActionsViewFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updateStatusViewFHD_L()
                updateCollapseView()
                updateTopViewFHD_L(isShow: !self.isCollapsed)
//                updateActionsViewFHD_L()
                break
            default:
                break
            }
            break
        default:
            break
        }
        self.updateMapView()
        self.updateCenterMark()
    }
    
    override func openPromotionActiveQR() {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(promotionView, animated: true)
            promotionView.activeQRCode()
        }
    }
    
    // MARK: Event handler
    /**
     * Handle when tap on actions buttons
     * - parameter sender: Button object
     */
    func actionsButtonTapped(_ sender: AnyObject) {
        // Handle by button identify
        switch ((sender as! UIButton).accessibilityIdentifier!) {
        case DomainConst.ACTION_TYPE_SUPPORT:
            showAlert(message: "DomainConst.ACTION_TYPE_SUPPORT")
            return
        default:
            break
        }
    }
    
    /**
     * Handle when tap on actions buttons
     * - parameter sender: Button object
     */
    internal func handleTappedCollapseView(_ gestureRecognizer: UITapGestureRecognizer) {
        self.isCollapsed = !self.isCollapsed
        showHideTopView(isShow: !self.isCollapsed)
    }
    
    internal func btnCollapsedTapped(_ sender: AnyObject) {
        self.isCollapsed = !self.isCollapsed
        showHideTopView(isShow: !self.isCollapsed)
    }
    
    internal func btnChatTapped(_ sender: AnyObject) {
        makeASMS(phone: _data.employee_phone)
    }
    
    internal func btnPhoneTapped(_ sender: AnyObject) {
        makeACall(phone: _data.employee_phone)
    }
    
    internal func orderFinish(_ notification: Notification) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Utility methods
    /**
     * Set data for this screen
     */
    public func setData(bean: OrderBean) {
        self._data = bean
        updateData()
    }
    
    internal func updateData() {
        if !_data.employee_image.isEmpty {
            self.imgAvatar.getImgFromUrl(link: _data.employee_image,
                                         contentMode: self.imgAvatar.contentMode)
        }        
        self.lblEmployeeName.text   = _data.employee_name
        self.lblEmployeeCode.text   = _data.employee_code
        self.lblAgent.text          = _data.agent_name
        self.setSrcAddress(position: CLLocationCoordinate2D(
            latitude: (_data.employee_latitude as NSString).doubleValue,
            longitude: (_data.employee_longitude as NSString).doubleValue))
        self.setDestAddress(position: CLLocationCoordinate2D(
            latitude: (_data.latitude as NSString).doubleValue,
            longitude: (_data.longitude as NSString).doubleValue))
        self.setBotMsgContent(
            note: String.init(
                format: "Chạm vào đơn hàng %@ để xem lại chi tiết\nLộ trình giao hàng khoảng %@", _data.code_no, detailDirection),
                description: "")
        setBotMsgColor(lstString: [_data.code_no, detailDirection])
    }
    /**
     * Setting for map properties
     */
    private func settingMap() {
        // Show compass button
        viewMap.settings.compassButton      = true
        // Show mylocation button
        viewMap.settings.myLocationButton   = true
        viewMap.isMyLocationEnabled         = true
        viewMap.delegate                    = self
    }
    
    /**
     * Change screen mode
     * - parameter value: OrderStatus enum
     */
    private func changeMode(value: OrderStatusEnum) {
        listStatusButtons[value.rawValue].isSelected = true
        switch value {
        case OrderStatusEnum.STATUS_CREATE:         // Mode create
            break
        case OrderStatusEnum.STATUS_WAIT_CONFIRM:   // Mode waiting confirm
            break
        case OrderStatusEnum.STATUS_CONFIRMED:      // Mode confirmed
            break
        case OrderStatusEnum.STATUS_COMPLETE:       // Mode Finish
            break
        default:
            break
        }
    }
    
    // MARK: Status Label
    private func createStatusLabel() {
        lblStatus.frame         = CGRect(
            x: 0, y: getTopHeight(),
            width: UIScreen.main.bounds.width,
            height: GlobalConst.LABEL_H + 2 * GlobalConst.MARGIN)
        lblStatus.text          = DomainConst.CONTENT00512
        lblStatus.textColor     = UIColor.black
        lblStatus.font          = GlobalConst.BASE_FONT
        lblStatus.textAlignment  = .center
        lblStatus.backgroundColor = UIColor(white: 1, alpha: 1.0)
    }
    
    private func updateStatusLabel() {
        CommonProcess.updateViewPos(
            view: lblStatus, x: 0,
            y: getTopHeight(),
            w: UIScreen.main.bounds.width,
            h: GlobalConst.LABEL_H + 2 * GlobalConst.MARGIN)
    }
    
    // MARK: Status view
    /**
     * Create Status view
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createStatusView(w: CGFloat, h: CGFloat) {
        self.statusView.frame = CGRect(
            x: (UIScreen.main.bounds.width - w) / 2,
            y: lblStatus.frame.maxY,
            width: w, height: h)
        self.statusView.backgroundColor = UIColor(white: 1, alpha: 1.0)
        createStatusContent()
    }
    
    // MARK: Status content
    /**
     * Create Status content
     */
    private func createStatusContent() {
        let btnWidth = statusView.frame.height - 3 * GlobalConst.MARGIN
        let margin: CGFloat = GlobalConst.MARGIN
        let count = OrderStatusEnum.STATUS_NUM.rawValue
        let btnSpace    = (statusView.frame.width - 2 * margin - btnWidth) / (CGFloat)(count - 1)
        
        for i in 0..<count {
            // Calculate frame of button
            let frame = CGRect(x: margin + CGFloat(i) * btnSpace, y: margin / 2,
                               width: btnWidth,
                               height: btnWidth)
            let btn = CategoryButton(frame: frame,
                                     icon: listStatusIcon[i].0,
                                     iconActive: listStatusIcon[i].1,
                                     title: listStatusConfig[i].name.uppercased(),
                                     id: listStatusConfig[i].id)
            btn.isUserInteractionEnabled = false
            listStatusButtons.append(btn)
            self.statusView.addSubview(btn)
        }
    }
    
    /**
     * Update category content
     */
    private func updateStatusContent() {
        let btnWidth = statusView.frame.height - 3 * GlobalConst.MARGIN
        let margin: CGFloat = GlobalConst.MARGIN
        let count = listStatusButtons.count
        let btnSpace    = (statusView.frame.width - 2 * margin - btnWidth) / (CGFloat)(count - 1)
        
        for i in 0..<count {
            // Calculate frame of button
            listStatusButtons[i].frame = CGRect(x: margin + CGFloat(i) * btnSpace, y: margin / 2,
                                                width: btnWidth,
                                                height: btnWidth + GlobalConst.MARGIN)
        }
    }
    
    /**
     * Create category view (in HD mode)
     */
    private func createStatusViewHD() {
        createStatusView(w: STATUS_VIEW_REAL_WIDTH_HD,
                         h: CATEGORY_BUTTON_REAL_SIZE_HD)
    }
    
    /**
     * Create category view (in Full HD mode)
     */
    private func createStatusViewFHD() {
        createStatusView(w: STATUS_VIEW_REAL_WIDTH_FHD,
                         h: CATEGORY_BUTTON_REAL_SIZE_FHD)
    }
    
    /**
     * Create category view (in Full HD Landscape mode)
     */
    private func createStatusViewFHD_L() {
        createStatusView(w: STATUS_VIEW_REAL_WIDTH_FHD_L,
                         h: CATEGORY_BUTTON_REAL_SIZE_FHD_L)
    }
    
    private func updateStatusView(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: statusView,
            x: (UIScreen.main.bounds.width - w) / 2,
            y: lblStatus.frame.maxY,
            w: w, h: h)
        updateStatusContent()
    }
    
    /**
     * Update category view (in HD mode)
     */
    private func updateStatusViewHD() {
        updateStatusView(w: STATUS_VIEW_REAL_WIDTH_HD,
                         h: CATEGORY_BUTTON_REAL_SIZE_HD)
    }
    
    /**
     * Update category view (in Full HD mode)
     */
    private func updateStatusViewFHD() {
        updateStatusView(w: STATUS_VIEW_REAL_WIDTH_FHD,
                         h: CATEGORY_BUTTON_REAL_SIZE_FHD)
    }
    
    /**
     * Update category view (in Full HD Landscape mode)
     */
    private func updateStatusViewFHD_L() {
        updateStatusView(w: STATUS_VIEW_REAL_WIDTH_FHD_L,
                         h: CATEGORY_BUTTON_REAL_SIZE_FHD_L)
    }
    
    // MARK: Collapse view
    /**
     * Create collapse view
     */
    func createCollapseView() {
        // Top view
        self.collapseView.frame = CGRect(
            x: 0,
            y: statusView.frame.maxY,
            width: UIScreen.main.bounds.width,
            height: GlobalConst.LABEL_H * 2)
        self.collapseView.backgroundColor = UIColor(white: 1, alpha: 1.0)
        self.collapseView.layer.addBorder(edge: .bottom,
                                          color: UIColor.gray,
                                          thickness: 1.0)
        self.collapseView.layer.addBorder(edge: .top,
                                          color: UIColor.gray,
                                          thickness: 1.0)
        createEmployeeTitleLabel()
        createCollapseButton()
        self.collapseView.addSubview(lblEmployeeTitle)
        self.collapseView.addSubview(btnCollapse)
    }
    
    /**
     * Update collapse view
     */
    func updateCollapseView() {
        CommonProcess.updateViewPos(view: collapseView,
            x: 0,
            y: statusView.frame.maxY/* + GlobalConst.MARGIN*/,
            w: UIScreen.main.bounds.width,
            h: GlobalConst.LABEL_H * 2)
        updateEmployeeTitle()
        updateCollapseButton()
    }
    
    // MARK: Collapse view - Employee title label
    /**
     * Create employee title label
     */
    private func createEmployeeTitleLabel() {
        lblEmployeeTitle.text           = DomainConst.CONTENT00493.uppercased()
        lblEmployeeTitle.textColor      = GlobalConst.MAIN_COLOR_GAS_24H
        lblEmployeeTitle.font           = UIFont.boldSystemFont(ofSize: GlobalConst.BASE_FONT_SIZE)
        lblEmployeeTitle.textAlignment  = .center
        lblEmployeeTitle.frame = CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: collapseView.frame.height)
        let tappedRecog = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTappedCollapseView(_:)))
        collapseView.addGestureRecognizer(tappedRecog)
    }
    
    private func updateEmployeeTitle() {
        CommonProcess.updateViewPos(view: lblEmployeeTitle,
                                    x: 0, y: 0,
                                    w: UIScreen.main.bounds.width,
                                    h: collapseView.frame.height)
    }
    
    // MARK: Collapse view - Collapse button
    private func createCollapseButton() {
        let btnSize = collapseView.frame.height / 2
        btnCollapse.frame = CGRect(
            x: UIScreen.main.bounds.width - btnSize - GlobalConst.MARGIN,
            y: (collapseView.frame.height - btnSize) / 2,
            width: btnSize,
            height: btnSize)
        
        
        let back = ImageManager.getImage(named: DomainConst.COLLAPSE_BUTTON_ICON_IMG_NAME)
        let tintedBack = back?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnCollapse.setImage(tintedBack, for: UIControlState())
//        btnCollapse.transform = CGAffineTransform(
//            rotationAngle: (270.0 * CGFloat(M_PI)) / 180.0)
        btnCollapse.tintColor = GlobalConst.MAIN_COLOR_GAS_24H
        btnCollapse.backgroundColor = UIColor.clear
        btnCollapse.imageView?.contentMode = .scaleAspectFit
        btnCollapse.addTarget(self, action: #selector(btnCollapsedTapped(_:)),
                              for: .touchUpInside)
    }
    
    private func updateCollapseButton() {
        let btnSize = collapseView.frame.height / 2
        CommonProcess.updateViewPos(view: btnCollapse,
                                    x: UIScreen.main.bounds.width - btnSize - GlobalConst.MARGIN,
                                    y: (collapseView.frame.height - btnSize) / 2,
                                    w: btnSize,
                                    h: btnSize)
    }
    
    // MARK: Top view
    /**
     * Setup all components of top view
     * - parameter width: Width of topview
     * - parameter height: Height of topview
     */
    func createTopView(width: CGFloat, height: CGFloat) {
        // Top view
        self._topView.frame = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: collapseView.frame.maxY,
            width: width,
            height: height + GlobalConst.MARGIN)
        self._topView.backgroundColor = UIColor(white: 1, alpha: 1.0)
        
        // Image avatar
        let imgSize = height - 2 * GlobalConst.MARGIN
        self.imgAvatar.frame = CGRect(x: GlobalConst.MARGIN,
                                      y: (height - imgSize) / 2,
                                      width: imgSize, height: imgSize)
        self.imgAvatar.contentMode = .scaleAspectFit
        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = imgSize / 2
        self.imgAvatar.layer.borderWidth = 2
        self.imgAvatar.layer.borderColor = UIColor.orange.cgColor
//        self.imgAvatar.getImgFromUrl(link: DomainConst.BLANK,
//                                     contentMode: .scaleAspectFit)
        self.imgAvatar.image = ImageManager.getImage(named: DomainConst.DEFAULT_IMG_NAME)
        
        let leftMargin = imgAvatar.frame.maxX + GlobalConst.MARGIN
        // Employee name
        self.lblEmployeeName.frame = CGRect(x: leftMargin,
                                            y: 0,
                                            width: width - height,
                                            height: height / 4)
        self.lblEmployeeName.text = "Nguyễn Thanh Tùng"
        self.lblEmployeeName.font = GlobalConst.BASE_FONT
        self.lblEmployeeName.textAlignment = .left
        
        // Employee code
        self.lblEmployeeCode.frame = CGRect(x: leftMargin,
                                            y: lblEmployeeName.frame.maxY,
                                            width: width - height,
                                            height: height / 4)
        self.lblEmployeeCode.text = "DKMN0948"
        self.lblEmployeeCode.font = GlobalConst.BASE_FONT
        self.lblEmployeeCode.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        self.lblEmployeeCode.textAlignment = .left
        
        // Employee agent
        self.lblAgent.frame = CGRect(x: leftMargin,
                                     y: lblEmployeeCode.frame.maxY,
                                     width: width - height,
                                     height: height / 4)
        self.lblAgent.text = "Đại lý Quận 10"
        self.lblAgent.font = GlobalConst.BASE_FONT
        self.lblAgent.textAlignment = .left
        
        // Rating bar
        let ratingSize = GlobalConst.LABEL_H
        let ratingWidth = ratingSize * (CGFloat)(ratingBar.getStarNumber()) + (ratingBar.getStarSpace() * (CGFloat)(ratingBar.getStarNumber() - 1))
        ratingBar.frame = CGRect(x: leftMargin,
                                 y: lblAgent.frame.maxY,
                                 width: ratingWidth,
                                 height: height / 4)
        
        //ratingBar.setBackgroundColor(color: GlobalConst.BACKGROUND_COLOR_GRAY)
        ratingBar.setRatingValue(value: 4)
        ratingBar.delegate = self
        ratingBar.isUserInteractionEnabled = false
        
        // Button chat and phone
        createChatButton(w: width, h: height)
        createPhoneButton(w: width, h: height)
        
        self._topView.addSubview(self.imgAvatar)
        self._topView.addSubview(self.lblEmployeeName)
        self._topView.addSubview(self.lblEmployeeCode)
        self._topView.addSubview(self.lblAgent)
        self._topView.addSubview(self.ratingBar)
        self._topView.addSubview(self.btnChat)
        self._topView.addSubview(self.btnPhone)
    }
    
    /**
     * Create top view in HD mode
     */
    private func createTopViewHD() {
        self.createTopView(width: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD,
                           height: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_HD)
    }
    
    /**
     * Create top view in Full HD mode
     */
    private func createTopViewFHD() {
        self.createTopView(width: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD,
                           height: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create top view in Full HD landscape mode
     */
    private func createTopViewFHD_L() {
        self.createTopView(width: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L,
                           height: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD_L)
    }
    
    private func updateTopView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: self._topView, x: x, y: y, w: w, h: h + GlobalConst.MARGIN)
        
        let imgSize = h - 2 * GlobalConst.MARGIN
        CommonProcess.updateViewPos(view: imgAvatar,
                                    x: GlobalConst.MARGIN,
                                    y: (h - imgSize) / 2,
                                    w: imgSize, h: imgSize)
        let leftMargin = imgAvatar.frame.maxX + GlobalConst.MARGIN
        CommonProcess.updateViewPos(view: lblEmployeeName,
                                    x: leftMargin,
                                    y: 0,
                                    w: w - h,
                                    h: h / 4)
        CommonProcess.updateViewPos(view: lblEmployeeCode,
                                    x: leftMargin,
                                    y: lblEmployeeName.frame.maxY,
                                    w: w - h,
                                    h: h / 4)
        CommonProcess.updateViewPos(view: lblAgent,
                                    x: leftMargin,
                                    y: lblEmployeeCode.frame.maxY,
                                    w: w - h,
                                    h: h / 4)
        CommonProcess.updateViewPos(view: ratingBar,
                                    x: leftMargin,
                                    y: lblAgent.frame.maxY,
                                    w: w - h,
                                    h: h / 4)
    }
    
    /**
     * Update top view in HD mode
     * - parameter isShow: Flag show/hide
     */
    private func updateTopViewHD(isShow: Bool = true) {
        if isShow {
            updateTopView(
                x: (UIScreen.main.bounds.width - DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD) / 2,
                y: collapseView.frame.maxY,
                w: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD,
                h: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_HD)
        } else {
            updateTopView(
                x: (UIScreen.main.bounds.width - DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD) / 2,
                y: collapseView.frame.maxY - DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_HD - GlobalConst.MARGIN,
                w: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_HD,
                h: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_HD)
        }
    }
    
    /**
     * Update top view in Full HD mode
     * - parameter isShow: Flag show/hide
     */
    private func updateTopViewFHD(isShow: Bool = true) {
        if isShow {
            updateTopView(
                x: (UIScreen.main.bounds.width - DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD) / 2,
                y: collapseView.frame.maxY,
                w: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD,
                h: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD)
        } else {
            updateTopView(
                x: (UIScreen.main.bounds.width - DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD) / 2,
                y: collapseView.frame.maxY - DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD - GlobalConst.MARGIN,
                w: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD,
                h: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD)
        }
    }
    
    /**
     * Update top view in Full HD Landscape mode
     * - parameter isShow: Flag show/hide
     */
    private func updateTopViewFHD_L(isShow: Bool = true) {
        if isShow {
            updateTopView(
                x: (UIScreen.main.bounds.width - DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L) / 2,
                y: collapseView.frame.maxY,
                w: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L,
                h: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD_L)
        } else {
            updateTopView(
                x: (UIScreen.main.bounds.width - DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L) / 2,
                y: collapseView.frame.maxY - DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD_L - GlobalConst.MARGIN,
                w: DELIVERY_MAP_TOP_VIEW_REAL_WIDTH_FHD_L,
                h: DELIVERY_MAP_TOP_VIEW_REAL_HEIGHT_FHD_L)
        }
    }
    
    // MARK: Top view - Chat button
    /**
     * Create chat button
     * - parameter w: Width of top view
     * - parameter h: Height of top view
     */
    private func createChatButton(w: CGFloat, h: CGFloat) {
        let btnSize = h / 4
        btnChat.frame = CGRect(
            x: w - btnSize * 2 - GlobalConst.MARGIN * 2, y: h - btnSize,
            width: btnSize, height: btnSize)
        
        let chat = ImageManager.getImage(named: DomainConst.CHAT_BUTTON_ICON_IMG_NAME)
        let tinted = chat?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnChat.setImage(tinted, for: UIControlState())
        btnChat.tintColor = GlobalConst.MAIN_COLOR_GAS_24H
        btnChat.backgroundColor = UIColor.clear
        btnChat.imageView?.contentMode = .scaleAspectFit
        btnChat.addTarget(self, action: #selector(btnChatTapped(_:)),
                          for: .touchUpInside)
    }
    
    // MARK: Top view - Phone button
    /**
     * Create phone button
     * - parameter w: Width of top view
     * - parameter h: Height of top view
     */
    private func createPhoneButton(w: CGFloat, h: CGFloat) {
        let btnSize = h / 4
        btnPhone.frame = CGRect(
            x: btnChat.frame.maxX + GlobalConst.MARGIN, y: h - btnSize,
            width: btnSize, height: btnSize)
        
        let phone = ImageManager.getImage(named: DomainConst.PHONE_BUTTON_ICON_IMG_NAME)
        let tinted = phone?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnPhone.setImage(tinted, for: UIControlState())
        btnPhone.tintColor = GlobalConst.MAIN_COLOR_GAS_24H
        btnPhone.backgroundColor = UIColor.clear
        btnPhone.imageView?.contentMode = .scaleAspectFit
        btnPhone.addTarget(self, action: #selector(btnPhoneTapped(_:)),
                          for: .touchUpInside)
    }
    
    // MARK: Top view - Show/Hide
    private func showHideTopView(isShow: Bool) {
        let duration = 0.5
        var rotateAngle: CGFloat = 1.0
        if isShow {
            rotateAngle = -1.0
        }
        UIView.animate(withDuration: duration, animations: {
            self.btnCollapse.layer.transform = CATransform3DConcat(
                self.btnCollapse.layer.transform,
                CATransform3DMakeRotation(CGFloat(M_PI), rotateAngle, 0.0, 0.0))
        })
        
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            UIView.animate(withDuration: duration, animations: {
                self.updateTopViewHD(isShow: isShow)
            })
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                UIView.animate(withDuration: duration, animations: {
                    self.updateTopViewFHD(isShow: isShow)
                })
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                UIView.animate(withDuration: duration, animations: {
                    self.updateTopViewFHD_L(isShow: isShow)
                })
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    // MARK: Center marker
    /**
     * Create center marker
     */
    func createCenterMark() {
        self._centerMark.frame = CGRect(
            x: (UIScreen.main.bounds.width - GlobalConst.CENTER_MARKER_SIZE_WIDTH) / 2,
            y: (UIScreen.main.bounds.height - getTopHeight()) / 2 - GlobalConst.CENTER_MARKER_SIZE_HEIGHT + getTopHeight(),
            width: GlobalConst.CENTER_MARKER_SIZE_WIDTH,
            height: GlobalConst.CENTER_MARKER_SIZE_HEIGHT)
        self._centerMark.image = ImageManager.getImage(named: DomainConst.CENTER_MARKER_IMG_NAME)
        self._centerMark.contentMode = .scaleAspectFit
    }
    
    /**
     * Update center marker
     */
    func updateCenterMark() {
        self._centerMark.frame = CGRect(
            x: (UIScreen.main.bounds.width - GlobalConst.CENTER_MARKER_SIZE_WIDTH) / 2,
            y: (UIScreen.main.bounds.height - getTopHeight()) / 2 - GlobalConst.CENTER_MARKER_SIZE_HEIGHT + getTopHeight(),
            width: GlobalConst.CENTER_MARKER_SIZE_WIDTH,
            height: GlobalConst.CENTER_MARKER_SIZE_HEIGHT)
    }
    
    // MARK: Map view
    func updateMapView() {
        viewMap.frame = CGRect(x: 0, y: collapseView.frame.maxY,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height - collapseView.frame.maxY)
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    public func setDestAddress(position: CLLocationCoordinate2D) {
//        var address = DomainConst.BLANK
//        GMSGeocoder().reverseGeocodeCoordinate(position, completionHandler: {
//            (response, error) in
//            if error != nil {
//                return
//            }
//            // Get address
//            address = (response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER))!
//        })
        self._destination.lat = position.latitude
        self._destination.long = position.longitude
    }
    
    /**
     * Move camera
     * - parameter position: Position to move
     */
    public func moveCamera(position: CLLocationCoordinate2D) {
        let camera       = GMSCameraPosition.camera(withLatitude: position.latitude,
                                                    longitude: position.longitude,
                                                    zoom: self.viewMap.camera.zoom)
        //self.viewMap.camera = camera
        self.viewMap.animate(to: camera)
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    public func setSrcAddress(position: CLLocationCoordinate2D, isFirstTime: Bool = false) {
//        var address = DomainConst.BLANK
//        GMSGeocoder().reverseGeocodeCoordinate(position, completionHandler: {
//            (response, error) in
//            if error != nil {
//                return
//            }
//            // Get address
//            address = (response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER))!
//        })
        self._source.lat = position.latitude
        self._source.long = position.longitude
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.width * image.size.height / image.size.width))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /** Handle direction */
    public func direction() {
        self.viewMap.clear()
        let origin: String = "\(self._source.lat),\(self._source.long)"
        let destination: String =
        "\(self._destination.lat),\(self._destination.long)"
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: self._destination.lat, longitude: self._destination.long))
        marker.map = self.viewMap
        marker.icon = self.imageWithImage(
            image: ImageManager.getImage(named: DomainConst.DESTINATION_MARKER_IMG_NAME)!,
            scaledToSize: CGSize(
                width: GlobalConst.CENTER_MARKER_SIZE_WIDTH,
                height: GlobalConst.CENTER_MARKER_SIZE_HEIGHT))
        
        let sourceMarker = GMSMarker(position: CLLocationCoordinate2D(
            latitude: self._source.lat,
            longitude: self._source.long))
        sourceMarker.icon = self.imageWithImage(
            image: ImageManager.getImage(named: DomainConst.SOURCE_MARKER_IMG_NAME)!,
            scaledToSize: CGSize(
                width: GlobalConst.CENTER_MARKER_SIZE_WIDTH,
                height: GlobalConst.CENTER_MARKER_SIZE_WIDTH))
        sourceMarker.map = self.viewMap
        
        self.directionService.getDirections(
            origin: origin,
            destination: destination,
            travelMode: TravelModes.driving) {
                [weak self] (success) in
                if success {
                    DispatchQueue.main.async {
                        self?.drawRoute()
                        if let totalDistance = self?.directionService.totalDistanceInMeters/*,
                            let totalDuration = self?.directionService.totalDuration*/ {
                                var unit = "km"
                                var value = totalDistance / 1000
                                if totalDistance < 1000 {
                                    unit = "m"
                                    value = totalDistance
                                }
                            self?.detailDirection = "\(value) \(unit)"
                                self?.updateData()
                        }
                    }
                } else {
                    print("error direction")
                }
        }
    }
    
    /**
     * Handle draw route
     */
    private func drawRoute() {
        for step in self.directionService.selectSteps {
            if step.polyline.points != "" {
                let path = GMSPath(fromEncodedPath: step.polyline.points)
                let routePolyline = GMSPolyline(path: path)
                routePolyline.strokeColor = GlobalConst.MAIN_COLOR_GAS_24H
                routePolyline.strokeWidth = 3.0
                routePolyline.map = self.viewMap
                if let pathValue = path {
                    let mapBound = GMSCoordinateBounds(path: pathValue)
                    updateCamera(bound: mapBound)
                }
            } else {
                return
            }
        }
    }
    
    /**
     * Update camera from bound
     * - parameter bound: Map bounding
     */
    private func updateCamera(bound: GMSCoordinateBounds) {
        let cameraUpdate = GMSCameraUpdate.fit(bound, withPadding: 30)
        self.viewMap.moveCamera(cameraUpdate)
    }
    
//    /**
//     * Create actions view
//     * - parameter x: X position
//     * - parameter y: Y position
//     * - parameter w: Width of view
//     * - parameter h: Height of view
//     */
//    private func createActionsView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
//        self.actionsView.frame = CGRect(x: x, y: y, width: w, height: h)
//        self.actionsView.backgroundColor = UIColor(white: 1, alpha: 0.0)
//        createActionsViewContent()
//    }
//    
//    /**
//     * Create actions view (in HD mode)
//     */
//    private func createActionsViewHD() {
//        createActionsView(x: 0,
//                          y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_HD,
//                          w: UIScreen.main.bounds.width,
//                          h: BUTTON_ACTION_REAL_SIZE_HD)
//    }
//    
//    /**
//     * Create actions view (in Full HD mode)
//     */
//    private func createActionsViewFHD() {
//        createActionsView(x: 0,
//                          y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD,
//                          w: UIScreen.main.bounds.width,
//                          h: BUTTON_ACTION_REAL_SIZE_FHD)
//    }
//    
//    /**
//     * Create actions view (in Full HD Landscape mode)
//     */
//    private func createActionsViewFHD_L() {
//        createActionsView(x: 0,
//                          y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD_L,
//                          w: UIScreen.main.bounds.width,
//                          h: BUTTON_ACTION_REAL_SIZE_FHD_L)
//    }
//    
//    /**
//     * Update actions view (in HD mode)
//     */
//    private func updateActionsViewHD() {
//        CommonProcess.updateViewPos(
//            view: actionsView,
//            x: 0,
//            y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_HD,
//            w: UIScreen.main.bounds.width,
//            h: BUTTON_ACTION_REAL_SIZE_HD)
//        updateActionsViewContent()
//    }
//    
//    /**
//     * Update actions view (in Full HD mode)
//     */
//    private func updateActionsViewFHD() {
//        CommonProcess.updateViewPos(
//            view: actionsView,
//            x: 0,
//            y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD,
//            w: UIScreen.main.bounds.width,
//            h: BUTTON_ACTION_REAL_SIZE_FHD)
//        updateActionsViewContent()
//    }
//    
//    /**
//     * Update actions view (in Full HD Landscape mode)
//     */
//    private func updateActionsViewFHD_L() {
//        CommonProcess.updateViewPos(
//            view: actionsView,
//            x: 0,
//            y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD_L,
//            w: UIScreen.main.bounds.width,
//            h: BUTTON_ACTION_REAL_SIZE_FHD_L)
//        updateActionsViewContent()
//    }
//    
//    /**
//     * Create actions view content
//     */
//    private func createActionsViewContent() {
//        // Attemp list image
//        var listImg = [(String, String)]()
//        listImg.append((DomainConst.GAS_BUTTON_ICON_IMG_NAME, DomainConst.GAS_BUTTON_ICON_IMG_NAME))
//        listImg.append((DomainConst.PROMOTE_BUTTON_ICON_IMG_NAME, DomainConst.PROMOTE_BUTTON_ICON_IMG_NAME))
//        listImg.append((DomainConst.SUPPORT_BUTTON_ICON_IMG_NAME, DomainConst.SUPPORT_BUTTON_ICON_IMG_NAME))
//        listImg.append((DomainConst.SUPPORT_BUTTON_ICON_IMG_NAME, DomainConst.SUPPORT_BUTTON_ICON_IMG_NAME))
//        let btnWidth = actionsView.frame.height - GlobalConst.MARGIN
//        let margin = GlobalConst.MARGIN
//        let count = listActionsConfig.count
//        let btnSpace    = (UIScreen.main.bounds.width - 2 * margin - btnWidth) / (CGFloat)(count - 1)
//        var font = UIFont.smallSystemFontSize
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            font = UIFont.systemFontSize
//        }
//        for i in 0..<count {
//            // Calculate frame of button
//            let frame = CGRect(x: margin + CGFloat(i) * btnSpace, y: margin / 2,
//                               width: btnWidth,
//                               height: btnWidth)
//            let btn = CategoryButton(frame: frame, icon: listImg[i].0, iconActive: listImg[i].1, title: listActionsConfig[i].name, id: listActionsConfig[i].id, font: font, isUpperText: true)
//            //            self.adjustImageAndTitleOffsetsForButton(button: btn)
//            btn.addTarget(self, action: #selector(actionsButtonTapped), for: .touchUpInside)
//            let lbl = UILabel(frame: CGRect(x: margin + CGFloat(i) * btnSpace,
//                                            y: 0.0,
//                                            width: btnWidth,
//                                            height: GlobalConst.LABEL_H))
//            lbl.text = listActionsConfig[i].name
//            lbl.font = UIFont.systemFont(ofSize: font)
//            lbl.textAlignment = .center
//            lbl.textColor = UIColor.black
//            listActionsLabels.append(lbl)
//            listActionsButtons.append(btn)
//            if listActionsConfig[i].id != DomainConst.ACTION_TYPE_NONE {
//                self.actionsView.addSubview(btn)
//                self.actionsView.addSubview(lbl)
//            }
//        }
//    }
//    
//    /**
//     * Update actions view content
//     */
//    private func updateActionsViewContent() {
//        let btnWidth = actionsView.frame.height - GlobalConst.MARGIN
//        let margin = GlobalConst.MARGIN
//        let count = listActionsButtons.count
//        let btnSpace    = (UIScreen.main.bounds.width - 2 * margin - btnWidth) / (CGFloat)(count - 1)
//        
//        for i in 0..<count {
//            // Calculate frame of button
//            listActionsButtons[i].frame = CGRect(x: margin + CGFloat(i) * btnSpace,
//                                                 y: margin / 2,
//                                                 width: btnWidth,
//                                                 height: btnWidth)
//            listActionsLabels[i].frame = CGRect(x: margin + CGFloat(i) * btnSpace,
//                                                y: 0.0,
//                                                width: btnWidth,
//                                                height: GlobalConst.LABEL_H)
//        }
//    }
}

// MARK: Protocol - CLLocationManagerDelegate
extension G12F01S02VC: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location: CLLocation = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: Float(BaseModel.shared.getZoomValue()))
//            let camera = GMSCameraPosition.camera(withLatitude: self._source.lat,
//                                                  longitude: self._source.long,
//                                                  zoom: Float(BaseModel.shared.getZoomValue()))
            self.updateMapView()
            if viewMap.isHidden {
                viewMap.isHidden = false
                viewMap.camera = camera
            } else {
                viewMap.animate(to: camera)
            }
            self.direction()
//            self.updateData()
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

// MARK: Protocol - GMSMapViewDelegate
extension G12F01S02VC: GMSMapViewDelegate {
    /**
     * Handle long press inside map
     */
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//        self.setDestAddress(position: coordinate)
        self.moveCamera(position: coordinate)
    }
    
    /**
     * Finish detect current location
     */
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        self.setSrcAddress(position: position.target, isFirstTime: true)
    }
}

// MARK: Protocol - RatingBarDelegate
extension G12F01S02VC: RatingBarDelegate {
    func rating(_ sender: AnyObject) {
        // Do nothing
    }
}
