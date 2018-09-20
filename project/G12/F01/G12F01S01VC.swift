//
//  G12F01S01VC.swift
//  project
//
//  Created by SPJ on 9/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps

class G12F01S01VC: BaseParentViewController {
    // MARK: Properties
    /** Location */
    let locationManager:    CLLocationManager   = CLLocationManager()
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
    /** Label Order */
    var lblOrder:               UILabel     = UILabel()
    /** Button order */
    var btnOrder:               UIButton    = UIButton()
    /** Button processing */
    var btnProcessing:          UIButton    = UIButton()
    /** Processing view */
    var processingView:         NVActivityIndicatorView? = nil
    /** Button finish */
    var btnFinish:              UIButton    = UIButton()
    /** Explain label */
    var lblExplain:             UILabel     = UILabel()
    /** Processing 1 label */
    var lblProcessing1:         UILabel     = UILabel()
    /** Processing 2 label */
    var lblProcessing2:         UILabel     = UILabel()
    /** Finish 1 label */
    var lblFinish1:             UILabel     = UILabel()
    /** Finish 2 label */
    var lblFinish2:             UILabel     = UILabel()
    /** Finish 3 label */
    var lblFinish3:             UILabel     = UILabel()
    /** Button cancel order */
    var btnCancelOrder:         UIButton    = UIButton(type: UIButtonType.custom)
    /** Button refer */
    var btnRefer:               UIButton    = UIButton()
    //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    /** Promote textfield */
    var txtPromote:             UITextField = UITextField()
    /** Button next */
    var btnNext:                UIButton    = UIButton(type: .custom)
    //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    /** Actions view */
    var actionsView:            UIView      = UIView()
    /** List of actions button */
    var listActionsButtons:     [UIButton]  = [UIButton]()
    /** List of actions label */
    var listActionsLabels:      [UILabel]   = [UILabel]()
    // Attemp list config
    var listActionsConfig:      [ConfigBean] = [
//        ConfigBean(id: DomainConst.ACTION_TYPE_SELECT_GAS, name: DomainConst.CONTENT00485),
        ConfigBean(id: DomainConst.ACTION_TYPE_SELECT_GAS, name: DomainConst.CONTENT00485),
        ConfigBean(id: DomainConst.ACTION_TYPE_SELECT_PROMOTE, name: DomainConst.CONTENT00486),
    ]
    /** Address text value */
    var addressText:            String      = DomainConst.BLANK
    /** Flag openned map */
    var isOpenedMap:            Bool        = false
    /** Flag cancel order (By system) */
    var isCancelOrder:          Bool        = false
    /** Mode */
    var mode:                   OrderStatusEnum      = OrderStatusEnum.STATUS_CREATE
    /** OrderConfig request retry count */
    var reqOrderConfigCount:    Int         = 0
    /** UpdateConfig request retry count */
    var reqUpdateConfigCount:   Int         = 0
    /** Preview view */
    var previewView:            OrderPreview      = OrderPreview()
    /** Id */
    var _id:                    String      = DomainConst.BLANK
    var _completeId:            String      = DomainConst.BLANK
    /** Flag showing preview */
    var isShowPreview:          Bool        = false
    /** Flag check if order is finish */
    var isOrderFinish:          Bool        = false
    /** Last order data */
    var _lastOrder:             OrderBean   = OrderBean()
    /** Flag check if transaction status request was ran */
    var _isRequestedTransactionStatus:    Bool    = false
    //++ BUG0165-SPJ (NguyenPT 20171123) Fix bug transaction status
    /** Flag check need stop request transaction status */
    var _isNeedStopTransStatus:             Bool    = false
    /**  Flag check if viewDidAppear is called*/
    var _isFirstCallDidAppear:              Bool    = true
    /**  Flag check if finish transaction status is called*/
    var _isFirstCallTransactionStatus:      Bool    = true
    //-- BUG0165-SPJ (NguyenPT 20171123) Fix bug transaction status
    //++ BUG0188-SPJ (NguyenPT 20180305) Gas24h - Get neareast agent from server
    /** Flag check if button order was tapped */
    var _isOrder:                           Bool    = false
    //-- BUG0188-SPJ (NguyenPT 20180305) Gas24h - Get neareast agent from server            
    
    // MARK: Static values
    /** Current position of map view */
    public static var _currentPos       = CLLocationCoordinate2D.init()
    /** Save neares agent information */
    public static var _nearestAgent     = AgentInfoBean()
    /** Material gas select */
    public static var _gasSelected      = MaterialBean()
    /** Material promote select */
    public static var _promoteSelected  = MaterialBean()
    
    // MARK: Constant
    // View mode
    let MODE_ORDER:             String  = DomainConst.NUMBER_ZERO_VALUE
    let MODE_PROCESSING:        String  = DomainConst.NUMBER_ONE_VALUE
    let MODE_FINISH:            String  = DomainConst.NUMBER_TWO_VALUE
    let MODE_MAP:               String  = DomainConst.NUMBER_THREE_VALUE
    let MODE_CANCEL:            String  = DomainConst.NUMBER_FOUR_VALUE
    let REQ_ORDER_CONFIG_MAX_COUNT:     Int     = 2
    let REQ_UPDATE_CONFIG_MAX_COUNT:    Int     = 2
    
    // Status
    var STATUS_VIEW_REAL_WIDTH_HD       = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var STATUS_VIEW_REAL_WIDTH_FHD      = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var STATUS_VIEW_REAL_WIDTH_FHD_L    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    // Category button
    var CATEGORY_BUTTON_REAL_SIZE_HD    = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_HD
    var CATEGORY_BUTTON_REAL_SIZE_FHD   = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD
    var CATEGORY_BUTTON_REAL_SIZE_FHD_L = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD_L
    
    // Order label
    var ORDER_LABEL_REAL_Y_POS_HD       = GlobalConst.ORDER_LABEL_Y_POS * BaseViewController.H_RATE_HD
    var ORDER_LABEL_REAL_Y_POS_FHD      = GlobalConst.ORDER_LABEL_Y_POS * BaseViewController.H_RATE_FHD
    var ORDER_LABEL_REAL_Y_POS_FHD_L    = GlobalConst.ORDER_LABEL_Y_POS * BaseViewController.H_RATE_FHD_L
    
    // Order button
    var ORDER_BUTTON_REAL_SIZE_HD       = GlobalConst.ORDER_BUTTON_SIZE * BaseViewController.H_RATE_HD
    var ORDER_BUTTON_REAL_SIZE_FHD      = GlobalConst.ORDER_BUTTON_SIZE * BaseViewController.H_RATE_FHD
    var ORDER_BUTTON_REAL_SIZE_FHD_L    = GlobalConst.ORDER_BUTTON_SIZE * BaseViewController.H_RATE_FHD_L
    
    // Category button
    var BUTTON_ACTION_REAL_SIZE_HD    = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_HD
    var BUTTON_ACTION_REAL_SIZE_FHD   = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD
    var BUTTON_ACTION_REAL_SIZE_FHD_L = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD_L
    
    // Order cancel button
    var CANCEL_ORDER_BUTTON_REAL_WIDTH_HD    = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.W_RATE_HD
    var CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD   = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.W_RATE_FHD
    var CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD_L = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.W_RATE_FHD_L
    var CANCEL_ORDER_BUTTON_REAL_HEIGHT_HD    = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * BaseViewController.H_RATE_HD / 2
    var CANCEL_ORDER_BUTTON_REAL_HEIGHT_FHD   = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_FHD / 2
    var CANCEL_ORDER_BUTTON_REAL_HEIGHT_FHD_L = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_FHD_L / 2
    
    // Refer button
    var REFER_BUTTON_REAL_WIDTH_HD      = GlobalConst.REFER_BUTTON_WIDTH * BaseViewController.W_RATE_HD
    var REFER_BUTTON_REAL_WIDTH_FHD     = GlobalConst.REFER_BUTTON_WIDTH * BaseViewController.W_RATE_FHD
    var REFER_BUTTON_REAL_WIDTH_FHD_L   = GlobalConst.REFER_BUTTON_WIDTH * BaseViewController.W_RATE_FHD_L
    var REFER_BUTTON_REAL_HEIGHT_HD     = GlobalConst.REFER_BUTTON_HEIGHT * BaseViewController.H_RATE_HD
    var REFER_BUTTON_REAL_HEIGHT_FHD    = GlobalConst.REFER_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD
    var REFER_BUTTON_REAL_HEIGHT_FHD_L  = GlobalConst.REFER_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD_L
    
    // Preview view
    var PREVIEW_VIEW_REAL_WIDTH_HD       = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var PREVIEW_VIEW_REAL_WIDTH_FHD      = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var PREVIEW_VIEW_REAL_WIDTH_FHD_L    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Navigation
//        self.createNavigationBar(title: "1900 1565")
        self.createNavigationBar(title: DomainConst.HOTLINE)
//        openLogin()
        changeMode(value: OrderStatusEnum.STATUS_CREATE)
//        changeMode(value: OrderStatusEnum.STATUS_CONFIRMED)
        // Location setting
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        switch CLLocationManager.authorizationStatus() {
//        case .denied, .notDetermined, .restricted:
//            locationManager.requestWhenInUseAuthorization()
//            showAlert(message: DomainConst.CONTENT00529,
//                      okHandler: {
//                        alert in
//                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
//            })
//            break
//        default:
//            break
//        }
//        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        // Mark to know where returned from Login process
        NotificationCenter.default.addObserver(
            self, selector: #selector(notifyLoginSuccess(_:)),
            name: NSNotification.Name(
                rawValue: G12Const.NOTIFY_NAME_G12_REQUEST_TRANSACTION_START),
            object: nil)
//        addBotMsg(note: DomainConst.CONTENT00495, description: DomainConst.CONTENT00495)
        addBotMsg(note: DomainConst.CONTENT00495, description: DomainConst.CONTENT00533)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //++ BUG0165-SPJ (NguyenPT 20171123) Fix bug transaction status
        // If this if first call -> ignore all next statement
        if _isFirstCallDidAppear {
            _isFirstCallDidAppear = false
            return
        }
        //-- BUG0165-SPJ (NguyenPT 20171123) Fix bug transaction status
        self.isOpenedMap = false
        updateMaterialSelector()
        if isShowPreview {
            // Get data from preview view
            let deliveryInfo = previewView.getData()
            self.addressText = deliveryInfo.2
            // Update last order value
            _lastOrder.first_name = deliveryInfo.0
            _lastOrder.phone = deliveryInfo.1
            
            // Request transaction complete
            requestTransactionComplete(isReview: true, lastOrder: _lastOrder)
        //++ BUG0170-SPJ (NguyenPT 20171202) Update bottom message view
            makeBotMsgVisible(isShow: !isShowPreview)
        } else {
            hideBotMsgView()
        }
        //-- BUG0170-SPJ (NguyenPT 20171202) Update bottom message view
        if !isOrderFinish && self.mode == .STATUS_COMPLETE {
            isOrderFinish = true
        }
        requestOrderConfig()
        //++ BUG0165-SPJ (NguyenPT 20171123) Start new request Transaction status
        requestNewTransactionStatus()
        //-- BUG0165-SPJ (NguyenPT 20171123) Start new request Transaction status
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
        // Status
        STATUS_VIEW_REAL_WIDTH_HD       = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
        STATUS_VIEW_REAL_WIDTH_FHD      = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
        STATUS_VIEW_REAL_WIDTH_FHD_L    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
        
        // Category button
        CATEGORY_BUTTON_REAL_SIZE_HD    = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_HD
        CATEGORY_BUTTON_REAL_SIZE_FHD   = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD
        CATEGORY_BUTTON_REAL_SIZE_FHD_L = GlobalConst.BUTTON_CATEGORY_SIZE_NEW * BaseViewController.H_RATE_FHD_L
        
        // Order label
        ORDER_LABEL_REAL_Y_POS_HD       = GlobalConst.ORDER_LABEL_Y_POS * BaseViewController.H_RATE_HD
        ORDER_LABEL_REAL_Y_POS_FHD      = GlobalConst.ORDER_LABEL_Y_POS * BaseViewController.H_RATE_FHD
        ORDER_LABEL_REAL_Y_POS_FHD_L    = GlobalConst.ORDER_LABEL_Y_POS * BaseViewController.H_RATE_FHD_L
        
        // Order button
        ORDER_BUTTON_REAL_SIZE_HD       = GlobalConst.ORDER_BUTTON_SIZE * BaseViewController.H_RATE_HD
        ORDER_BUTTON_REAL_SIZE_FHD      = GlobalConst.ORDER_BUTTON_SIZE * BaseViewController.H_RATE_FHD
        ORDER_BUTTON_REAL_SIZE_FHD_L    = GlobalConst.ORDER_BUTTON_SIZE * BaseViewController.H_RATE_FHD_L
        
        // Category button
        BUTTON_ACTION_REAL_SIZE_HD    = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_HD
        BUTTON_ACTION_REAL_SIZE_FHD   = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD
        BUTTON_ACTION_REAL_SIZE_FHD_L = GlobalConst.BUTTON_ACTION_SIZE * BaseViewController.H_RATE_FHD_L
        
        // Order cancel button
        CANCEL_ORDER_BUTTON_REAL_WIDTH_HD    = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_HD
        CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD   = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_FHD
        CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD_L = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_FHD_L
        
        CANCEL_ORDER_BUTTON_REAL_HEIGHT_HD    = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * BaseViewController.H_RATE_HD / 2
        CANCEL_ORDER_BUTTON_REAL_HEIGHT_FHD   = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_FHD / 2
        CANCEL_ORDER_BUTTON_REAL_HEIGHT_FHD_L = GlobalConst.BUTTON_CANCEL_ORDER_WIDTH * BaseViewController.H_RATE_FHD_L / 2
        
        // Refer button
        REFER_BUTTON_REAL_WIDTH_HD      = GlobalConst.REFER_BUTTON_WIDTH * BaseViewController.W_RATE_HD
        REFER_BUTTON_REAL_WIDTH_FHD     = GlobalConst.REFER_BUTTON_WIDTH * BaseViewController.W_RATE_FHD
        REFER_BUTTON_REAL_WIDTH_FHD_L   = GlobalConst.REFER_BUTTON_WIDTH * BaseViewController.W_RATE_FHD_L
        REFER_BUTTON_REAL_HEIGHT_HD     = GlobalConst.REFER_BUTTON_HEIGHT * BaseViewController.H_RATE_HD
        REFER_BUTTON_REAL_HEIGHT_FHD    = GlobalConst.REFER_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD
        REFER_BUTTON_REAL_HEIGHT_FHD_L  = GlobalConst.REFER_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD_L
        
        // Preview view
        PREVIEW_VIEW_REAL_WIDTH_HD       = STATUS_VIEW_REAL_WIDTH_HD
        PREVIEW_VIEW_REAL_WIDTH_FHD      = STATUS_VIEW_REAL_WIDTH_FHD
        PREVIEW_VIEW_REAL_WIDTH_FHD_L    = STATUS_VIEW_REAL_WIDTH_FHD_L
    }
    
    /**
     * Handle set background image
     */
    override func setBackgroundImage() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPHONE_IMG_NAME)
            break
        case .pad:
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:
                self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPAD_IMG_NAME)
            case .landscapeLeft, .landscapeRight:
                self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPAD_LANDSCAPE_IMG_NAME)
            default:
                self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPAD_IMG_NAME)
            }
            break
        default:
            self.setBackground(bkg: DomainConst.LOGIN_BKG_IPAD_IMG_NAME)
        }
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
            createOrderHD()
            createOrderButtonHD()
            createExplainLabel()
            createProcessingLabel()
            createFinishLabel()
            createCancelBtnHD()
            createReferBtnHD()
            createActionsViewHD()
            createPreviewViewHD()
            //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
            createPromoteTextField()
            //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                createStatusViewFHD()
                createOrderFHD()
                createOrderButtonFHD()
                createExplainLabel()
                createProcessingLabel()
                createFinishLabel()
                createCancelBtnFHD()
                createReferBtnFHD()
                createActionsViewFHD()
                createPreviewViewFHD()
                //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                createPromoteTextField()
                //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                createStatusViewFHD_L()
                createOrderFHD_L()
                createOrderButtonFHD_L()
                createExplainLabel()
                createProcessingLabel()
                createFinishLabel()
                createCancelBtnFHD_L()
                createReferBtnFHD_L()
                createActionsViewFHD_L()
                createPreviewViewFHD_L()
                //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                createPromoteTextField()
                //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(statusView)
        self.view.addSubview(lblStatus)
        self.view.addSubview(lblOrder)
        self.view.addSubview(btnOrder)
        self.view.addSubview(btnProcessing)
        self.view.addSubview(btnFinish)
        self.view.addSubview(processingView!)
        self.view.addSubview(lblExplain)
        self.view.addSubview(lblProcessing1)
        self.view.addSubview(lblProcessing2)
        self.view.addSubview(lblFinish1)
        self.view.addSubview(lblFinish2)
        self.view.addSubview(lblFinish3)
        self.view.addSubview(actionsView)
        for i in 0..<listActionsConfig.count {
            if listActionsConfig[i].id != DomainConst.ACTION_TYPE_NONE
                && listActionsConfig[i].id != DomainConst.ACTION_TYPE_SELECT_PROMOTE{
                self.view.addSubview(listActionsLabels[i])
            }
        }
        self.view.addSubview(btnCancelOrder)
        self.view.addSubview(btnRefer)
        //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
        self.view.addSubview(txtPromote)
        //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
        self.view.addSubview(previewView)
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
            updateOrderHD()
            updateOrderButtonHD()
            updateExplainLabel()
            updateProcessingLabel()
            updateFinishLabel()
            updateCancelBtnHD()
            updateReferBtnHD()
            updateActionsViewHD()
            updatePreviewViewHD()
            //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
            updatePromoteTextField()
            //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updateStatusViewFHD()
                updateOrderFHD()
                updateOrderButtonFHD()
                updateExplainLabel()
                updateProcessingLabel()
                updateFinishLabel()
                updateCancelBtnFHD()
                updateReferBtnFHD()
                updateActionsViewFHD()
                updatePreviewViewFHD()
                //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                updatePromoteTextField()
                //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updateStatusViewFHD_L()
                updateOrderFHD_L()
                updateOrderButtonFHD_L()
                updateExplainLabel()
                updateProcessingLabel()
                updateFinishLabel()
                updateCancelBtnFHD_L()
                updateReferBtnFHD_L()
                updateActionsViewFHD_L()
                updatePreviewViewFHD_L()
                //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                updatePromoteTextField()
                //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        makeBotMsgVisible(isShow: !isShowPreview)
    }
    
    override func clearData() {
        self.txtPromote.text = DomainConst.BLANK
    }
    
    // MARK: Event handler
    /**
     * Handle when tap on cancel order button
     */
    func btnCancelOrderTapped(_ sender: AnyObject) {
        requestCancelTransaction()
    }
    
    /**
     * Handle when tap on actions buttons
     * - parameter sender: Button object
     */
    func actionsButtonTapped(_ sender: AnyObject) {
        // Handle by button identify
        switch ((sender as! UIButton).accessibilityIdentifier!) {
        case DomainConst.ACTION_TYPE_SELECT_GAS:
            switch CLLocationManager.authorizationStatus() {
            case .denied, .notDetermined, .restricted:
                locationManager.requestWhenInUseAuthorization()
                showAlert(message: DomainConst.CONTENT00529,
                          okHandler: {
                            alert in
                            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
                })
                return
            default:
                break
            }
            openGasSelect()
            return
        case DomainConst.ACTION_TYPE_SELECT_PROMOTE:
            openPromoteSelect()
            return
        case DomainConst.ACTION_TYPE_SUPPORT:
            showAlert(message: "DomainConst.ACTION_TYPE_SUPPORT")
            return
        default:
            break
        }
    }
    
    /**
     * Handle order button tapped event
     */
    internal func btnOrderTapped(_ sender: AnyObject) {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
            showAlert(message: DomainConst.CONTENT00529,
                      okHandler: {
                        alert in
                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
            })
            return
        default:
            break
        }
        //++ BUG0188-SPJ (NguyenPT 20180305) Gas24h - Get neareast agent from server
//        btnOrder.isEnabled = false
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
        //changeMode(value: OrderStatusEnum.STATUS_WAIT_CONFIRM)
//        requestTransactionStart()
        // Check nearest agent info is not empty
        if !G12F01S01VC._nearestAgent.isEmpty() {
            startOrder()
        } else {
            requestNearestAgent(isOrder: true)
        }
        //-- BUG0188-SPJ (NguyenPT 20180305) Gas24h - Get neareast agent from server
    }
    
    //++ BUG0188-SPJ (NguyenPT 20180305) Gas24h - Get neareast agent from server
    /**
     * Start order process
     */
    private func startOrder() {
        btnOrder.isEnabled = false
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        requestTransactionStart()
    }
    //-- BUG0188-SPJ (NguyenPT 20180305) Gas24h - Get neareast agent from server
    
    /**
     * Handle processing button tapped event
     */
    internal func btnProcessingTapped(_ sender: AnyObject) {
//        changeMode(value: MODE_FINISH)
    }
    
    /**
     * Handle finish button tapped event
     */
    internal func btnFinishTapped(_ sender: AnyObject) {
        openOrderDetail(id: DomainConst.BLANK)
        BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
        changeMode(value: OrderStatusEnum.STATUS_CREATE)
    }
    
    /**
     * Handle when tap on refer button
     */
    func btnReferTapped(_ sender: AnyObject) {
        openPromotion()
        BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
        changeMode(value: OrderStatusEnum.STATUS_CREATE)
    }    
    
    //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    /**
     * Handle when tap on next button
     */
    func btnNextPromoteTapped(_ sender: AnyObject) {
        // Get value from text field
        if let value = txtPromote.text {
            // Check if value is empty or not
            if !value.isEmpty {
                // Hide keyboard
                self.view.endEditing(true)
                PromotionAddRequest.request(
                    action: #selector(finishRequestAddPromotionCode),
                    view: self,
                    code: value)
            }
        }
    }
    
    /**
     * Handler when finish request add promotion code
     */
    internal func finishRequestAddPromotionCode(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
//        showAlert(message: model.message)
        if model.isSuccess() {
            showAlert(message: model.message)
            txtPromote.text = DomainConst.BLANK
        } else {
            self.showAlert(message: model.message,
                           okHandler: {
                            alert in
                            self.updatePromoteCode(text: self.txtPromote.text!)
            })
        }
    }
    //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    
    /**
     * Handler when transaction status request is finish
     * - parameter model: Model object
     */
    public func finishRequestTransactionStatus(_ model: Any?) {
        let data = (model as! String)
        let model = OrderViewRespModel(jsonString: data)
        if model.isSuccess() {
            _id = model.record.id
            // Handle process base on status of order
            switch checkStatus(order: model.getRecord()) {
            case OrderStatusEnum.STATUS_CREATE:         // Status create
                if self.mode == .STATUS_DELIVERING {
                    NotificationCenter.default.post(
                        name: NSNotification.Name(
                            rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                        object: nil)
                }
                break
            case OrderStatusEnum.STATUS_WAIT_CONFIRM:   // Status waiting confirm
                if self.mode == .STATUS_DELIVERING {
                    NotificationCenter.default.post(
                        name: NSNotification.Name(
                            rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                        object: nil)
                    changeMode(value: OrderStatusEnum.STATUS_WAIT_CONFIRM)
                }
                if self.mode != OrderStatusEnum.STATUS_CONFIRMED {
                    changeMode(value: OrderStatusEnum.STATUS_WAIT_CONFIRM)
                }
                if self.mode != .STATUS_WAIT_CONFIRM {
                    NSObject.cancelPreviousPerformRequests(withTarget: self)
                }
                break
            case OrderStatusEnum.STATUS_CONFIRMED:      // Status confirmed
//                changeMode(value: OrderStatusEnum.STATUS_CONFIRMED)
                break
            case OrderStatusEnum.STATUS_DELIVERING:     // Status delivering
                if !isOpenedMap {
                    isOpenedMap = !isOpenedMap
                    openMap(data: model.getRecord())
                    changeMode(value: OrderStatusEnum.STATUS_DELIVERING)
                }
                break
            case OrderStatusEnum.STATUS_COMPLETE:       // Status complete
                if self.mode != OrderStatusEnum.STATUS_CREATE {
                    changeMode(value: OrderStatusEnum.STATUS_COMPLETE)
                }                
                break
            case OrderStatusEnum.STATUS_NUM:            // Status cancel
                if !isCancelOrder {
                    isCancelOrder = true
                    NotificationCenter.default.post(
                        name: NSNotification.Name(
                            rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                        object: nil)
                    BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
                    self.changeMode(value: OrderStatusEnum.STATUS_CREATE)
                }
                break
            }
        } else {
            // Do nothing
        }
        //++ BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
//        btnOrder.isEnabled = true
//        self.listActionsButtons[0].isEnabled = true
//        self.listActionsButtons[1].isEnabled = true
        if _isFirstCallTransactionStatus {
            btnOrder.isEnabled = true
            self.listActionsButtons[0].isEnabled = true
            self.listActionsButtons[1].isEnabled = true
            _isFirstCallTransactionStatus = false
            return
        }
        //-- BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
        
        //++ BUG0165-SPJ (NguyenPT 20171123) New request Transaction status was started
        logw(text: "\(#function)")
        logw(text: "_isNeedStopTransStatus is \(_isNeedStopTransStatus)")
        if _isNeedStopTransStatus {
            _isNeedStopTransStatus = false
        } else {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(
                    BaseModel.shared.getGas24hTimeCheckOrder() * 1000),
                execute: {
                    self.requestTransactionStatus(
                        completionHandler: self.finishRequestTransactionStatus)
            })
        }
        //-- BUG0165-SPJ (NguyenPT 20171123) New request Transaction status was started
    }
    
    //++ BUG0165-SPJ (NguyenPT 20171123) New request Transaction status was started
    /**
     * Handler when transaction status request is finish
     * - parameter model: Model object
     */
    public func finishNewRequestTransactionStatus(_ model: Any?) {
        let data = (model as! String)
        let model = OrderViewRespModel(jsonString: data)
        if model.isSuccess() {
            _id = model.record.id
            // Handle process base on status of order
            switch checkStatus(order: model.getRecord()) {
            case OrderStatusEnum.STATUS_CREATE:         // Status create
                if self.mode == .STATUS_DELIVERING {
                    NotificationCenter.default.post(
                        name: NSNotification.Name(
                            rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                        object: nil)
                }
                break
            case OrderStatusEnum.STATUS_WAIT_CONFIRM:   // Status waiting confirm
                if self.mode == .STATUS_DELIVERING {
                    NotificationCenter.default.post(
                        name: NSNotification.Name(
                            rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                        object: nil)
                    changeMode(value: OrderStatusEnum.STATUS_WAIT_CONFIRM)
                }
                if self.mode != OrderStatusEnum.STATUS_CONFIRMED {
                    changeMode(value: OrderStatusEnum.STATUS_WAIT_CONFIRM)
                }
                if self.mode != .STATUS_WAIT_CONFIRM {
                    NSObject.cancelPreviousPerformRequests(withTarget: self)
                }
                break
            case OrderStatusEnum.STATUS_CONFIRMED:      // Status confirmed
                //                changeMode(value: OrderStatusEnum.STATUS_CONFIRMED)
                break
            case OrderStatusEnum.STATUS_DELIVERING:     // Status delivering
                if !isOpenedMap {
                    isOpenedMap = !isOpenedMap
                    openMap(data: model.getRecord())
                    changeMode(value: OrderStatusEnum.STATUS_DELIVERING)
                }
                break
            case OrderStatusEnum.STATUS_COMPLETE:       // Status complete
                if self.mode != OrderStatusEnum.STATUS_CREATE {
                    changeMode(value: OrderStatusEnum.STATUS_COMPLETE)
                }
                break
            case OrderStatusEnum.STATUS_NUM:            // Status cancel
                if !isCancelOrder {
                    isCancelOrder = true
                    
                    NotificationCenter.default.post(
                        name: NSNotification.Name(
                            rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                        object: nil)
                    BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
                    self.changeMode(value: OrderStatusEnum.STATUS_CREATE)
                }
                break
            }
        } else {
            // Do nothing
        }
        //++ BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
//        btnOrder.isEnabled = true
//        self.listActionsButtons[0].isEnabled = true
//        self.listActionsButtons[1].isEnabled = true
        if _isFirstCallTransactionStatus {
            btnOrder.isEnabled = true
            self.listActionsButtons[0].isEnabled = true
            self.listActionsButtons[1].isEnabled = true
            _isFirstCallTransactionStatus = false
            return
        }
        //-- BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
        
        logw(text: "\(#function)")
        logw(text: "_isNeedStopTransStatus is \(_isNeedStopTransStatus)")
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(
                BaseModel.shared.getGas24hTimeCheckOrder() * 1000),
            execute: {
                self.requestTransactionStatus(
                    completionHandler: self.finishRequestTransactionStatus)
                self._isNeedStopTransStatus = false
        })
    }
    //-- BUG0165-SPJ (NguyenPT 20171123) New request Transaction status was started
    
    /**
     * Handler when transaction complete request is finish
     */
    func finishRequestTransactionComplete(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderTransactionCompleteRespModel(jsonString: data)
        if model.isSuccess() {
            let transactionData = BaseModel.shared.getTransactionData()
            transactionData.id = model.getRecord().transaction_id
            BaseModel.shared.setTransactionData(transaction: transactionData)
            _completeId = model.getRecord().id
            
            btnCancelOrder.isEnabled = true
            showHidePreview(isShow: false)
            changeMode(value: OrderStatusEnum.STATUS_WAIT_CONFIRM)
        } else {
            showAlert(message: model.message)
            changeMode(value: .STATUS_CREATE)
        }
        previewView.enableNextButton()
        //++ BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
        btnOrder.isEnabled = true
        //-- BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
    }
    
    /**
     * Handler when transaction complete (review) request is finish
     */
    func finishRequestTransactionCompleteReview(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderTransactionCompleteRespModel(jsonString: data)
        if model.isSuccess() {
//            self.showBotMsg(note: DomainConst.BLANK,
//                            description: DomainConst.BLANK,
//                            isShow: false)
            for item in model.getRecord().order_detail {
                if item.isGas() {
                    G12F01S01VC._gasSelected = item
                } else if item.isPromotion() {
                    G12F01S01VC._promoteSelected = item
                }
            }
            
            isShowPreview = true
            self.previewView.isHidden = !isShowPreview
            makeBotMsgVisible(isShow: !isShowPreview)
            previewView.setData(data: model.getRecord(), address: self.addressText)
        } else {
            showAlert(message: model.message)
            changeMode(value: .STATUS_CREATE)
        }
        previewView.enableNextButton()
        //++ BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
        btnOrder.isEnabled = true
        //-- BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
    }
    
    /**
     * Handler when order config request is finish
     */
    internal func finishRequestOrderConfig(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderConfigRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.saveOrderConfig(config: model.getRecord())
            if model.getRecord().agent.count != 1 {
                // Start update config
                startUpdateConfig()
            } else {
                G12F01S01VC._nearestAgent = model.getRecord().agent[0]
                updateMaterialSelector()
            }
        } else {
            // Check if need retry request Order config
            if self.reqOrderConfigCount < REQ_ORDER_CONFIG_MAX_COUNT {
                self.reqOrderConfigCount += 1
                print("Retry requestOrderConfig: \(self.reqOrderConfigCount)")
                requestOrderConfig()
            } else {
                showAlert(message: model.message)
            }
        }
    }
    /**
     * Finish request update config
     */
    internal func finishRequestUpdateConfig(_ notification: Notification) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let data = (notification.object as! String)
        let model = LoginRespModel(jsonString: data)
        LoadingView.shared.hideOverlayView(className: self.theClassName)
        if model.isSuccess() {
            BaseModel.shared.saveTempData(loginModel: model)
            setBotMsgContent(note: BaseModel.shared.getGas24hMenuText(),
                             description: DomainConst.CONTENT00533)
            updateNearestAgentInfo()
            //++ BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
            requestNewsList()
            //-- BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
        } else {
            // Check if need retry request Update config
            if self.reqUpdateConfigCount < REQ_UPDATE_CONFIG_MAX_COUNT {
                self.reqUpdateConfigCount += 1
                print("Retry reqUpdateConfigCount: \(self.reqUpdateConfigCount)")
                requestUpdateConfig()
            } else {
                showAlert(message: model.message)
            }
        }
    }
    //++ BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    internal func finishRequestNewsList(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = NewsListRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setListNews(data: model)
            self.updateBottomMsgViewContent()
        }
        requestPopUp()
    }
    
    internal func finishRequestNewsPopup(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = NewsPopUpRespModel(jsonString: data)
        if model.isSuccess() {
            // Training mode
            if BaseModel.shared.checkTrainningMode() {
                BaseModel.shared.setPopupData(data: model.getRecord())
                handleShowPopup()
            } else {
                // Main server
                if BaseModel.shared.isPopupChanged(data: model.getRecord()) {
                    BaseModel.shared.setPopupData(data: model.getRecord())
                    handleShowPopup()
                }
            }
        }        
    }
    //-- BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    
    /**
     * Finish request start transaction
     */
    internal func finishStartTransaction(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderTransactionStartRespModel(jsonString: data)
        if model.isSuccess() {
            // Save session id and key for transaction complete
            BaseModel.shared.setTransactionData(transaction: model.getRecord())
            if model.getRecord().isLastOrderEmpty() {
                _lastOrder = OrderBean()
                requestTransactionComplete(isReview: false)
            } else {
//                self.previewView.setData(data: model.getRecord().getLastOrderInfo())
                _lastOrder = model.getRecord().getLastOrderInfo()
                self.addressText = _lastOrder.address
                requestTransactionComplete(isReview: true, lastOrder: _lastOrder)
            }
        } else {
            showAlert(message: model.message)
            changeMode(value: .STATUS_CREATE)
            //++ BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
            btnOrder.isEnabled = true
            //-- BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
        }
        //++ BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
//        btnOrder.isEnabled = true
        //-- BUG0176-SPJ (NguyenPT 20171206) Prevent multi-tap on button Order
    }
    
    /**
     * Handle when finish request transaction confirm/cancel
     */
    func finishRequestTransactionCancelHandler(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
            changeMode(value: OrderStatusEnum.STATUS_CREATE)
//            requestTransactionStart()
        } else {
//            if model.code == "400" {
//                //
//            } else {
//                showAlert(message: model.message)
//            }
            showAlert(message: model.message)
        }
    }
    
    //++ BUG0188-SPJ (NguyenPT 20180228) Get nearest agent from server
    /**
     * Finish handle request nearest agent
     */
    func finishRequestNearestAgent(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = GetNearestAgentRespBean(jsonString: data)
        if model.isSuccess() {
            // Update nearest agent
            G12F01S01VC._nearestAgent = model.getRecord()
            
            // Not found any agent
            if G12F01S01VC._nearestAgent.isEmpty() {
                // Reset selected materials
                G12F01S01VC._gasSelected     = MaterialBean.init()
                G12F01S01VC._promoteSelected = MaterialBean.init()
            } else {    // Found
                // Save selected gas
                if !G12F01S01VC._nearestAgent.info_gas.isEmpty {
                    G12F01S01VC._gasSelected = G12F01S01VC._nearestAgent.info_gas[0]
                }
            }
            updateMaterialSelector(isCallTransactionStatus: true)
            if !_isRequestedTransactionStatus {
                // Start request transaction status
                requestTransactionStatus(completionHandler: finishRequestTransactionStatus)
                _isRequestedTransactionStatus = true
            }
            // Handle start order process if flag is ON
            if _isOrder {
                startOrder()
            }
        } else {
            showAlert(message: model.message)
        }
    }
    //-- BUG0188-SPJ (NguyenPT 20180228) Get nearest agent from server
    
    /**
     * Handle when back from Login process
     */
    override func notifyLoginSuccess(_ notification: Notification) {
        super.notifyLoginSuccess(notification)
        changeMode(value: .STATUS_CREATE)
        startUpdateConfig()
    }
    //++ BUG0162-SPJ (NguyenPT 20171120) Change mode to create after finish order (if select Home menu)
    /**
     * Handle left menu did closed event
     */
    func leftDidClose() {
        if isOrderFinish {
            BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
            changeMode(value: .STATUS_CREATE)
        }
//        requestNewTransactionStatus()
        
    }
    //-- BUG0162-SPJ (NguyenPT 20171120) Change mode to create after finish order (if select Home menu)
    
    // MARK: Utilities
    /**
     * Start logic of screen
     */
    internal func startLogic() {
        // Check if order config does exist
        if BaseModel.shared.getOrderConfig().isExist() {
            // Start update config
            startUpdateConfig()
        } else {
            requestOrderConfig()
        }
    }
    
    /**
     * Start update config
     */
    internal func startUpdateConfig() {
        // Check if user is logged in already
        if BaseModel.shared.checkIsLogin() {
            // Update config
            requestUpdateConfig()
        } else {    // User is not logged in yet
            // Open login screen
            openLogin()
        }
    }
    
    /**
     * Request update config
     */
    private func requestUpdateConfig() {
        UpdateConfigurationRequest.requestUpdateConfiguration(
            action: #selector(finishRequestUpdateConfig(_:)),
            view: self)
    }
    
    private func requestTransactionStart() {
        btnCancelOrder.isEnabled = false
//        if !BaseModel.shared.checkTransactionKey() {
            OrderTransactionStartRequest.requestOrderTransactionStart(
                action: #selector(finishStartTransaction(_:)),
                view: self)
//        }
    }
    
    /**
     * Request transaction status
     * - parameter completionHandler: Handler when finish
     */
    public func requestTransactionStatus(completionHandler: ((Any?)->Void)?) {
        if !BaseModel.shared.checkIsLogin() {
            return
        }
        logw(text: "\(#function)")
        TransactionStatusRequest.requestLoop(
            view: self,
            id: BaseModel.shared.getTransactionData().id,
            completionHandler: completionHandler)
    }
    
    //++ BUG0165-SPJ (NguyenPT 20171123) New request Transaction status was started
    /**
     * Request new transaction status
     */
    public func requestNewTransactionStatus() {
        if !BaseModel.shared.checkIsLogin() {
            return
        }
        logw(text: "\(#function)")
//        _isNeedStopTransStatus = true
        TransactionStatusRequest.requestLoop(
            view: self,
            id: BaseModel.shared.getTransactionData().id,
            completionHandler: finishNewRequestTransactionStatus(_:),
            isShowLoading: true)
    }
    //-- BUG0165-SPJ (NguyenPT 20171123) New request Transaction status was started
    
    /**
     * Request transaction complete
     * - parameter isReview: Review flag
     */
    internal func requestTransactionComplete(isReview: Bool = false,
                                             lastOrder: OrderBean = OrderBean()) {
        let userInfo = BaseModel.shared.getUserInfo()
        var orderDetail = DomainConst.BLANK
        var action = #selector(finishRequestTransactionComplete)
        var name  = DomainConst.BLANK
        var phone = DomainConst.BLANK
        var agentId = DomainConst.BLANK
        // Review order
        if isReview {
            orderDetail = String(getOrderDetailFromBean(bean: lastOrder).characters.dropLast())
            action = #selector(finishRequestTransactionCompleteReview)
            name  = lastOrder.first_name
            phone = lastOrder.phone
            agentId = lastOrder.agent_id
        } else {
            if lastOrder.phone.isEmpty && lastOrder.first_name.isEmpty {
                // First order
                orderDetail = String(getOrderDetail().characters.dropLast())
                action = #selector(finishRequestTransactionComplete)
                name  = userInfo.getName()
                phone = userInfo.getPhone()
                agentId = G12F01S01VC._nearestAgent.info_agent.agent_id
            } else {
                // Not first order
                orderDetail = String(getOrderDetailFromBean(bean: lastOrder).characters.dropLast())
                action = #selector(finishRequestTransactionComplete)
                name  = lastOrder.first_name
                phone = lastOrder.phone
                agentId = lastOrder.agent_id
            }
        }
        
        // Request server
        OrderTransactionCompleteRequest.requestOrderTransactionComplete(
            action: action,
            view: self,
            key:    BaseModel.shared.getTransactionData().name,
            id:     BaseModel.shared.getTransactionData().id,
            devicePhone:    phone,
            firstName:      name,
            phone:          phone,
            email:          userInfo.getEmail(),
            provinceId:     userInfo.getProvinceId(),
            districtId:     userInfo.getDistrictId(),
            wardId:         userInfo.getWardId(),
            streetId:       userInfo.getStreetId(),
            houseNum:       userInfo.getHouseNumber(),
            note:           DomainConst.BLANK,
            address:        self.addressText,
            orderDetail:    orderDetail,
            lat:            String(G12F01S01VC._currentPos.latitude),
            long:           String(G12F01S01VC._currentPos.longitude),
            agentId:        agentId,
            transactionType: DomainConst.TRANSACTION_TYPE_NORMAL,
            isReview:       isReview)
    }
    
    /**
     * Request order config
     */
    private func requestOrderConfig() {
        OrderConfigRequest.requestOrderConfig(
            action: #selector(finishRequestOrderConfig(_:)),
            view: self,
            agentId: G12F01S01VC._nearestAgent.info_agent.agent_id)
    }
    
    //++ BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    private func requestNewsList() {
        NewsListRequest.request(
            action: #selector(finishRequestNewsList(_:)),
            view: self, page: "0",
            //++ BUG0194-SPJ (NguyenPT 20180402) Add location information
            lat:            String(G12F01S01VC._currentPos.latitude),
            long:           String(G12F01S01VC._currentPos.longitude)
            //-- BUG0194-SPJ (NguyenPT 20180402) Add location information
        )
    }
    
    private func requestPopUp() {        
        NewsPopupRequest.request(
            action: #selector(finishRequestNewsPopup(_:)),
            view: self,
            //++ BUG0194-SPJ (NguyenPT 20180402) Add location information
            lat:            String(G12F01S01VC._currentPos.latitude),
            long:           String(G12F01S01VC._currentPos.longitude)
            //-- BUG0194-SPJ (NguyenPT 20180402) Add location information
        )
    }
    //-- BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    
    /**
     * Request cancel transaction
     */
    private func requestCancelTransaction() {
        var id = self._id
        if id.isEmpty {
            id = self._completeId
        }
        self.showAlert(message: DomainConst.CONTENT00256,
                       okHandler: {
                        (alert: UIAlertAction!) in
                        if self.mode == .STATUS_WAIT_CONFIRM || self.mode == .STATUS_CONFIRMED {
                            OrderTransactionCancelRequest.requestOrderTransactionCancel(
                                action: #selector(self.finishRequestTransactionCancelHandler(_:)),
                                view: self,
                                //                            id: BaseModel.shared.getTransactionData().id)
                                id: id)
                        }
                        
        },
                       cancelHandler: {
                        (alert: UIAlertAction!) in
        })
    }
    
    //++ BUG0188-SPJ (NguyenPT 20180228) Get nearest agent from server
    /**
     * Handle request nearest agent data from server
     */
    private func requestNearestAgent(isOrder: Bool = false) {
        _isOrder = isOrder
        GetNearestAgentRequest.request(
            action: #selector(finishRequestNearestAgent(_:)),
            view: self,
            lat: G12F01S01VC._currentPos.latitude.description,
            long: G12F01S01VC._currentPos.longitude.description)
    }
    //-- BUG0188-SPJ (NguyenPT 20180228) Get nearest agent from server
    
    /**
     * Update nearest agent information
     */
    private func updateNearestAgentInfo() {
        //++ BUG0188-SPJ (NguyenPT 20180228) Get nearest agent from server
//        var distance = Double.greatestFiniteMagnitude
//        // Loop for all agent and find nearest agent from current location
//        for item in BaseModel.shared.getAgentListFromOrderConfig() {
//            // Get lat and long value from agent information
//            let lat: CLLocationDegrees = (item.info_agent.agent_latitude as NSString).doubleValue
//            let long: CLLocationDegrees = (item.info_agent.agent_longitude as NSString).doubleValue
//            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            let currentDist = calculateDistance(pos1: G12F01S01VC._currentPos, pos2: location)
//            print(currentDist)
//            // Found a nearer agent
//            if distance > currentDist {
//                G12F01S01VC._nearestAgent = item
//                distance = currentDist
//            }
//        }
//        
//        // Check if min distance is outside of max range
//        if distance > BaseModel.shared.getMaxRangeDistantFromOrderConfig() {
//            G12F01S01VC._nearestAgent = AgentInfoBean.init()
//        }
//        
//        // Not found any agent
//        if G12F01S01VC._nearestAgent.isEmpty() {
//            // Reset selected materials
//            G12F01S01VC._gasSelected     = MaterialBean.init()
//            G12F01S01VC._promoteSelected = MaterialBean.init()
//        } else {    // Found
//            // Save selected gas
//            if !G12F01S01VC._nearestAgent.info_gas.isEmpty {
//                G12F01S01VC._gasSelected = G12F01S01VC._nearestAgent.info_gas[0]
//            }
//        }
//        updateMaterialSelector(isCallTransactionStatus: true)
//        if !_isRequestedTransactionStatus {
//            // Start request transaction status
//            requestTransactionStatus(completionHandler: finishRequestTransactionStatus)
//            _isRequestedTransactionStatus = true
//        }
        requestNearestAgent()
        //-- BUG0188-SPJ (NguyenPT 20180228) Get nearest agent from server
    }
    
    /**
     * Calculate the distance (in meters) from the receiver’s location to the specified location.
     * - parameter pos1: Receiver’s location
     * - parameter pos2: Specified location
     * - returns: This method measures the distance between the two locations by tracing a line between them that follows the curvature of the Earth. The resulting arc is a smooth curve and does not take into account specific altitude changes between the two locations
     */
    private func calculateDistance(pos1: CLLocationCoordinate2D, pos2: CLLocationCoordinate2D) -> Double {
        let position1 = CLLocation(latitude: pos1.latitude, longitude: pos1.longitude)
        let position2 = CLLocation(latitude: pos2.latitude, longitude: pos2.longitude)
        let distance: CLLocationDistance = position1.distance(from: position2)
        return distance
    }
    
    /**
     * Update material selector view data
     */
    private func updateMaterialSelector(isCallTransactionStatus: Bool = false) {
        var orderDetail = [OrderDetailBean]()
        // If found nearest agent information
        if !G12F01S01VC._gasSelected.isEmpty() {
//            self.listActionsLabels[0].text = G12F01S01VC._gasSelected.materials_name_short
            //            self.listActionsButtons[0].setImage(tinted, for: UIControlState.selected)
            orderDetail.append(OrderDetailBean(data: G12F01S01VC._gasSelected))
        } else {
            self.listActionsLabels[0].text = self.listActionsConfig[0].name
        }
        // If found nearest agent information
        if !G12F01S01VC._promoteSelected.isEmpty() {
//            self.listActionsLabels[1].text = G12F01S01VC._promoteSelected.materials_name_short
//            self.listActionsButtons[1].setImage(tinted, for: UIControlState.selected)
            orderDetail.append(OrderDetailBean(data: G12F01S01VC._promoteSelected))
        } else {
            self.listActionsLabels[1].text = self.listActionsConfig[1].name
        }
//        btnOrder.isEnabled = true
//        self.listActionsButtons[0].isEnabled = true
//        self.listActionsButtons[1].isEnabled = true
        
        if !orderDetail.isEmpty {
            _lastOrder.order_detail = orderDetail
        }
        if isCallTransactionStatus {
//            // Start request transaction status
//            requestTransactionStatus(completionHandler: finishRequestTransactionStatus)
        }
    }
    
    /**
     * Get order detail
     * - returns: Order detail in json format
     */
    private func getOrderDetail() -> String {
        var retVal = DomainConst.BLANK
        if !G12F01S01VC._gasSelected.isEmpty() {
            let detailGas = OrderDetailBean(
                data: G12F01S01VC._gasSelected,
                qty: DomainConst.NUMBER_ONE_VALUE)
            retVal = retVal + detailGas.createJsonData()
        }
        if !G12F01S01VC._promoteSelected.isEmpty() {
            let detailPromote = OrderDetailBean(
                data: G12F01S01VC._promoteSelected,
                qty: DomainConst.NUMBER_ONE_VALUE)
            retVal = retVal + detailPromote.createJsonData()
        }
        return retVal
    }
    
    /**
     * Get order detail
     */
    private func getOrderDetailFromBean(bean: OrderBean) -> String {
        var retVal = DomainConst.BLANK
        for item in bean.order_detail {
            // Only get gas and promotion (not cylinder)
            if item.isGas() || item.isPromotion() {
                retVal = retVal + item.createJsonData()
            }
        }
        return retVal
    }
    
    /**
     * Check status of current order
     * - parameter order: Order data
     * - returns: OrderStatusEnum
     */
    private func checkStatus(order: OrderBean) -> OrderStatusEnum {
        // Status is Cancel
        if order.status_number == DomainConst.ORDER_STATUS_CANCEL {
            return OrderStatusEnum.STATUS_NUM
        }
        // Status is Complete
        if order.status_number == DomainConst.ORDER_STATUS_COMPLETE {
            return OrderStatusEnum.STATUS_COMPLETE
        }
        
        // Current employee info does exist
        if !order.employee_code.isEmpty {
            return OrderStatusEnum.STATUS_DELIVERING
        }
        // Status is new
        if order.status_number == DomainConst.ORDER_STATUS_NEW {
            return OrderStatusEnum.STATUS_WAIT_CONFIRM
        }
        // Order is null
        return OrderStatusEnum.STATUS_CREATE
    }
    
    /**
     * Handle open map view
     */
    private func openMap(data: OrderBean) {
        let mapView = G12F01S02VC(nibName: G12F01S02VC.theClassName, bundle: nil)
        mapView.setData(bean: data)
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    private func openOrderDetail(id: String) {
        let view = G12F00S02VC(nibName: G12F00S02VC.theClassName,
                               bundle: nil)
        view.setId(id: BaseModel.shared.getTransactionData().id)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    internal override func openPromotion() {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(promotionView, animated: true)
    }
    
    override func openPromotionActiveQR() {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
//        promotionView.activeQRCode()
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(promotionView, animated: true)
            promotionView.activeQRCode()
        }
    }
    
    internal func openGasSelect() {
//        G12F01S03VC.setData(data: G12F01S01VC._nearestAgent.info_gas)
        let s03 = G12F01S03VC(nibName: G12F01S03VC.theClassName, bundle: nil)
        s03.setData(data: G12F01S01VC._nearestAgent.info_gas)
        self.navigationController?.pushViewController(s03, animated: true)
    }
    
    internal func openPromoteSelect() {
//        G12F01S03VC.setData(data: G12F01S01VC._nearestAgent.info_promotion)
        let s04 = G12F01S04VC(nibName: G12F01S04VC.theClassName, bundle: nil)
        s04.setData(data: G12F01S01VC._nearestAgent.info_promotion)
//        var title = DomainConst.CONTENT00524
//        if BaseModel.shared.checkTrainningMode() {
//            title += G12F01S01VC._nearestAgent.info_agent.agent_name
//        }
//        s04.createNavigationBar(title: title)
        self.navigationController?.pushViewController(s04, animated: true)
    }
    
    /**
     * Change screen mode
     * - parameter value: OrderStatus enum
     */
    private func changeMode(value: OrderStatusEnum) {
        listStatusButtons[self.mode.rawValue].isSelected = false
        listStatusButtons[value.rawValue].isSelected = true
        self.mode = value
        switch value {
        case OrderStatusEnum.STATUS_CREATE:         // Mode create
            showHideProcessingMode(isShow: false)
            showHideFinishMode(isShow: false)
            showHideOrderMode(isShow: true)
//            setBotMsgContent(note: DomainConst.CONTENT00495, description: DomainConst.CONTENT00495)
            setBotMsgContent(note: DomainConst.CONTENT00495, description: DomainConst.CONTENT00533)
            self.isCancelOrder = false
            self.isOrderFinish = false
            self.isShowPreview = false
            self.previewView.isHidden = true
//            BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
            break
        case OrderStatusEnum.STATUS_WAIT_CONFIRM:   // Mode waiting confirm
            showHideOrderMode(isShow: false)
            showHideFinishMode(isShow: false)
            showHideProcessingMode(isShow: true)
//            setBotMsgContent(note: DomainConst.CONTENT00496, description: DomainConst.CONTENT00496)
            setBotMsgContent(note: DomainConst.CONTENT00496, description: DomainConst.CONTENT00533)
//            let task = DispatchWorkItem {
//                self.showHideConfirmedMode()
            //            }
            perform(#selector(showHideConfirmedMode), with: nil,
                    afterDelay: TimeInterval(GlobalConst.CHANGE_CONFIRMED_STATUS_TIME_WAIT / 1000))
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(GlobalConst.CHANGE_CONFIRMED_STATUS_TIME_WAIT),
//                                          execute: {
//                                            self.showHideConfirmedMode()
//            })
//                execute: task )
            self.isOrderFinish = false
            break
        case OrderStatusEnum.STATUS_CONFIRMED:      // Mode confirmed
            showHideOrderMode(isShow: false)
            showHideFinishMode(isShow: false)
            showHideProcessingMode(isShow: false)
            showHideConfirmedMode()
//            setBotMsgContent(note: DomainConst.CONTENT00496, description: DomainConst.CONTENT00496)
            setBotMsgContent(note: DomainConst.CONTENT00496, description: DomainConst.CONTENT00533)
            self.isOrderFinish = false
            break
        case OrderStatusEnum.STATUS_COMPLETE:       // Mode Finish
            showHideOrderMode(isShow: false)
            showHideProcessingMode(isShow: false)
            showHideFinishMode(isShow: true)
//            setBotMsgContent(note: DomainConst.CONTENT00497, description: DomainConst.CONTENT00497)
            setBotMsgContent(note: DomainConst.CONTENT00497, description: DomainConst.CONTENT00533)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: G12Const.NOTIFY_NAME_G12_FINISH_ORDER),
                                            object: nil)
//            BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
            break
        default:
            break
        }
    }
    
    /**
     * Show/hide children views in order mode
     * - parameter isShow: Flag show or hide
     */
    private func showHideOrderMode(isShow: Bool) {
        lblOrder.isHidden = !isShow
        btnOrder.isHidden = !isShow
        lblExplain.isHidden = !isShow
        //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
        txtPromote.isHidden = !isShow
        //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
        for i in 0..<listActionsConfig.count {
            if listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_GAS
                || listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_PROMOTE {
                listActionsButtons[i].isHidden = !isShow
                listActionsLabels[i].isHidden = !isShow
            }
        }
    }
    
    /**
     * Show/hide children views in processing mode
     * - parameter isShow: Flag show or hide
     */
    private func showHideProcessingMode(isShow: Bool) {
        btnProcessing.isHidden = !isShow
        processingView?.isHidden = !isShow
        lblProcessing1.isHidden = !isShow
        lblProcessing2.isHidden = !isShow
        btnCancelOrder.isHidden = !isShow
        for i in 0..<listActionsConfig.count {
            if listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_GAS
                || listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_PROMOTE {
                listActionsButtons[i].isHidden = !isShow
                listActionsLabels[i].isHidden = !isShow
            }
        }
        if isShow {
            btnProcessing.setImage(
                ImageManager.getImage(
                    named: DomainConst.PROCESSING_BUTTON_ICON_IMG_NAME),
                for: UIControlState())
            lblProcessing1.text = DomainConst.CONTENT00487
            lblProcessing2.text = DomainConst.CONTENT00488
        }
    }
    
    func showHideConfirmedMode() {
        if mode != OrderStatusEnum.STATUS_WAIT_CONFIRM {
            return
        }
        listStatusButtons[mode.rawValue].isSelected = false
        mode = OrderStatusEnum.STATUS_CONFIRMED
        listStatusButtons[mode.rawValue].isSelected = true
        btnProcessing.setImage(
            ImageManager.getImage(
                named: DomainConst.CONFIRMED_BUTTON_ICON_IMG_NAME),
            for: UIControlState())
//        processingView?.isHidden = true
        lblProcessing1.text = DomainConst.CONTENT00521
        lblProcessing2.text = DomainConst.CONTENT00522
        for i in 0..<listActionsConfig.count {
            if listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_GAS
                || listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_PROMOTE {
                listActionsButtons[i].isHidden = true
                listActionsLabels[i].isHidden = true
            }
        }
    }
    
    /**
     * Show/hide children views in finish mode
     * - parameter isShow: Flag show or hide
     */
    private func showHideFinishMode(isShow: Bool) {
        btnFinish.isHidden = !isShow
        lblFinish1.isHidden = !isShow
        lblFinish2.isHidden = !isShow
        lblFinish3.isHidden = !isShow
        btnRefer.isHidden = !isShow
        for i in 0..<listActionsConfig.count {
            listActionsButtons[i].isHidden = isShow
            listActionsLabels[i].isHidden = isShow
        }
    }
    
    /**
     * Show hide preview
     * - parameter isShow: Flag show or hide
     */
    internal func showHidePreview(isShow: Bool) {
        isShowPreview = isShow
        makeBotMsgVisible(isShow: !isShowPreview)
        previewView.isHidden = !isShowPreview
    }
    
    public func getIsRequestedTransactionStatus() -> Bool {
        return self._isRequestedTransactionStatus
    }
    
    public func setIsRequestedTransactionStatus(value: Bool) {
        self._isRequestedTransactionStatus = value
    }
    
    //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    /**
     * Update promote code
     */
    internal func updatePromoteCode(text: String) {
        var txtValue:   UITextField?
        // Create alert
        let alert = UIAlertController(title: DomainConst.CONTENT00249,
                                      message: DomainConst.BLANK,
                                      preferredStyle: .alert)
        // Add textfield
        alert.addTextField(configurationHandler: {
            textField -> Void in
            txtValue = textField
            txtValue?.text = text
            txtValue?.textAlignment = .center
            txtValue?.clearButtonMode = .whileEditing
            txtValue?.returnKeyType = .done
            txtValue?.keyboardType = .default
            txtValue?.placeholder        = DomainConst.CONTENT00250
            txtValue?.returnKeyType      = .send
            txtValue?.font               = GlobalConst.BASE_FONT
            txtValue?.autocapitalizationType = .allCharacters
        })
        // Add cancel action
        let cancel = UIAlertAction(title: DomainConst.CONTENT00202, style: .cancel, handler: nil)
        // Add ok action
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .default) { action -> Void in
            if let value = txtValue?.text, !value.isEmpty {
                self.txtPromote.text = value
                PromotionAddRequest.request(
                    action: #selector(self.finishRequestAddPromotionCode),
                    view: self,
                    code: value)
            } else {
                self.showAlert(message: DomainConst.CONTENT00025, okTitle: DomainConst.CONTENT00251,
                               okHandler: {_ in
                                self.updatePromoteCode(text: text)
                },
                               cancelHandler: {_ in
                                self.txtPromote.text = DomainConst.BLANK
                })
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    
    //++ BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    /**
     * Handle show popup promotion
     */
    private func handleShowPopup() {
        let data = BaseModel.shared.getPopupData()
        let message = data.name.replacingOccurrences(
            of: "<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+>", with: "",
            options: .regularExpression,
            range: nil)
        let alert = UIAlertController(
            title: data.title,
            message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\(message)",
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: data.code_no_text, style: .default,
            handler: {
                alert in
                if let curVC = BaseViewController.getCurrentViewController() {
                    curVC.openPromotionActiveUsingCode(code: data.code_no)
                }
        })
        
        let actionCancel = UIAlertAction(
            title: DomainConst.CONTENT00541, style: .cancel,
            handler: {
                alert in
        })
        
        let actionOpenWeb = UIAlertAction(
            title: data.link_web_text, style: .destructive,
            handler: {
                alert in
//                if let url = URL(string: data.link_web) {
//                    UIApplication.shared.openURL(url)
//                }
                CommonProcess.openWeb(link: data.link_web)
                self.handleShowPopup()
        })
        
        if data.type == BottomMsgCellTypeEnum.openWeb.rawValue
            || data.type == BottomMsgCellTypeEnum.openWebUsingCode.rawValue {
            alert.addAction(actionOpenWeb)
        }
        let imgViewTitle = UIImageView(frame: CGRect(
            x: 0,
            y: 40, width: 8192/30,
            height: 230))
        imgViewTitle.getImgFromUrl(link: BaseModel.shared.getPopupData().url_banner_popup, contentMode: .scaleAspectFit)
        
        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    //-- BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    
    // MARK: Status Label
    private func createStatusLabel() {
        lblStatus.frame         = CGRect(
            x: 0, y: getTopHeight() + GlobalConst.MARGIN,
            width: UIScreen.main.bounds.width,
            height: GlobalConst.LABEL_H)
        lblStatus.text          = DomainConst.CONTENT00512
        lblStatus.textColor     = UIColor.black
        lblStatus.font          = GlobalConst.BASE_FONT
        lblStatus.textAlignment  = .center
    }
    
    private func updateStatusLabel() {
        CommonProcess.updateViewPos(
            view: lblStatus, x: 0,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: UIScreen.main.bounds.width,
            h: GlobalConst.LABEL_H)
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
            y: lblStatus.frame.maxY + GlobalConst.MARGIN,
            width: w, height: h)
        self.statusView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        createStatusContent()
    }
    
    // MARK: Status content
    /**
     * Create Status content
     */
    private func createStatusContent() {
        let btnWidth = statusView.frame.height - GlobalConst.MARGIN
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
        let btnWidth = statusView.frame.height - GlobalConst.MARGIN
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
            y: lblStatus.frame.maxY + GlobalConst.MARGIN,
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
    
    // MARK: Order label
    /**
     * Create order label
     */
    private func createOrderLabel() {
        lblOrder.text           = DomainConst.CONTENT00130.uppercased()
        lblOrder.textColor      = GlobalConst.MAIN_COLOR_GAS_24H
        lblOrder.font           = UIFont.boldSystemFont(ofSize: GlobalConst.NOTIFY_FONT_SIZE)
        lblOrder.textAlignment  = .center
    }
    
    private func createOrderHD() {
        createOrderLabel()
        lblOrder.frame = CGRect(x: 0,
                                y: ORDER_LABEL_REAL_Y_POS_HD,
                                width: UIScreen.main.bounds.width,
                                height: GlobalConst.LABEL_H * 2)
        
    }
    
    private func createOrderFHD() {
        createOrderLabel()
        lblOrder.frame = CGRect(x: 0,
                                y: ORDER_LABEL_REAL_Y_POS_FHD,
                                width: UIScreen.main.bounds.width,
                                height: GlobalConst.LABEL_H * 2)
        
    }
    
    private func createOrderFHD_L() {
        createOrderLabel()
        lblOrder.frame = CGRect(x: 0,
                                y: ORDER_LABEL_REAL_Y_POS_FHD_L,
                                width: UIScreen.main.bounds.width,
                                height: GlobalConst.LABEL_H * 2)
        
    }
    
    private func updateOrderHD() {
        CommonProcess.updateViewPos(view: lblOrder,
                                    x: 0, y: ORDER_LABEL_REAL_Y_POS_HD,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H * 2)
    }
    
    private func updateOrderFHD() {
        CommonProcess.updateViewPos(view: lblOrder,
                                    x: 0, y: ORDER_LABEL_REAL_Y_POS_FHD,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H * 2)
    }
    
    private func updateOrderFHD_L() {
        CommonProcess.updateViewPos(view: lblOrder,
                                    x: 0, y: ORDER_LABEL_REAL_Y_POS_FHD_L,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H * 2)
    }
    
    // MARK: Order button
    private func createOrderButton(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.btnOrder.frame = CGRect(x: x, y: y, width: w, height: h)
        self.btnOrder.setImage(ImageManager.getImage(named: DomainConst.ORDER_BUTTON_ICON_IMG_NAME),
                               for: UIControlState())
        self.btnOrder.addTarget(self, action: #selector(btnOrderTapped(_:)),
                                for: .touchUpInside)
        self.btnOrder.isEnabled = false
        self.btnProcessing.frame = CGRect(x: x, y: y, width: w, height: h)
        self.btnProcessing.setImage(ImageManager.getImage(named: DomainConst.PROCESSING_BUTTON_ICON_IMG_NAME),
                               for: UIControlState())
        self.btnProcessing.isUserInteractionEnabled = true
        self.btnProcessing.addTarget(self, action: #selector(btnProcessingTapped(_:)),
                                for: .touchUpInside)
        self.processingView = NVActivityIndicatorView(
            frame: btnProcessing.frame,
            type: NVActivityIndicatorType.ballScaleRippleMultiple)
        processingView?.startAnimating()
        let processingViewTappedRecog = UITapGestureRecognizer(
            target: self,
            action: #selector(handlTappedProcessingView(_:)))
        processingView?.addGestureRecognizer(processingViewTappedRecog)
        self.btnFinish.frame = CGRect(x: x, y: y, width: w, height: h)
        self.btnFinish.setImage(ImageManager.getImage(named: DomainConst.FINISH_BUTTON_ICON_IMG_NAME),
                                for: UIControlState())
        self.btnFinish.addTarget(self, action: #selector(btnFinishTapped(_:)),
                                for: .touchUpInside)
    }
    
    internal func handlTappedProcessingView(_ gestureRecognizer: UITapGestureRecognizer) {
//        openMap(data: OrderBean.init())
//        changeMode(value: MODE_FINISH)
    }
    
    private func createOrderButtonHD() {
        self.createOrderButton(
            x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_HD) / 2,
            y: lblOrder.frame.maxY + GlobalConst.MARGIN,
            w: ORDER_BUTTON_REAL_SIZE_HD, h: ORDER_BUTTON_REAL_SIZE_HD)
    }
    
    private func createOrderButtonFHD() {
        self.createOrderButton(
            x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD) / 2,
            y: lblOrder.frame.maxY + GlobalConst.MARGIN,
            w: ORDER_BUTTON_REAL_SIZE_FHD, h: ORDER_BUTTON_REAL_SIZE_FHD)
    }
    
    private func createOrderButtonFHD_L() {
        self.createOrderButton(
            x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD_L) / 2,
            y: lblOrder.frame.maxY + GlobalConst.MARGIN,
            w: ORDER_BUTTON_REAL_SIZE_FHD_L, h: ORDER_BUTTON_REAL_SIZE_FHD_L)
    }
    
    private func updateOrderButtonHD() {
        CommonProcess.updateViewPos(view: btnOrder,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_HD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_HD, h: ORDER_BUTTON_REAL_SIZE_HD)
        CommonProcess.updateViewPos(view: btnProcessing,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_HD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_HD, h: ORDER_BUTTON_REAL_SIZE_HD)
        CommonProcess.updateViewPos(view: processingView!,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_HD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_HD, h: ORDER_BUTTON_REAL_SIZE_HD)
        CommonProcess.updateViewPos(view: btnFinish,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_HD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_HD, h: ORDER_BUTTON_REAL_SIZE_HD)
    }
    
    private func updateOrderButtonFHD() {
        CommonProcess.updateViewPos(view: btnOrder,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD, h: ORDER_BUTTON_REAL_SIZE_FHD)
        CommonProcess.updateViewPos(view: btnProcessing,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD, h: ORDER_BUTTON_REAL_SIZE_FHD)
        CommonProcess.updateViewPos(view: processingView!,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD, h: ORDER_BUTTON_REAL_SIZE_FHD)
        CommonProcess.updateViewPos(view: btnFinish,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD, h: ORDER_BUTTON_REAL_SIZE_FHD)
    }
    
    private func updateOrderButtonFHD_L() {
        CommonProcess.updateViewPos(view: btnOrder,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD_L) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD_L, h: ORDER_BUTTON_REAL_SIZE_FHD_L)
        CommonProcess.updateViewPos(view: btnProcessing,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD_L) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD_L, h: ORDER_BUTTON_REAL_SIZE_FHD_L)
        CommonProcess.updateViewPos(view: processingView!,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD_L) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD_L, h: ORDER_BUTTON_REAL_SIZE_FHD_L)
        CommonProcess.updateViewPos(view: btnFinish,
                                    x: (UIScreen.main.bounds.width - ORDER_BUTTON_REAL_SIZE_FHD_L) / 2,
                                    y: lblOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: ORDER_BUTTON_REAL_SIZE_FHD_L, h: ORDER_BUTTON_REAL_SIZE_FHD_L)
    }
    
    // MARK: Explain label
    /**
     * Create explain label
     */
    private func createExplainLabel() {
        lblExplain.frame = CGRect(x: 0,
                                y: btnOrder.frame.maxY + GlobalConst.MARGIN,
                                width: UIScreen.main.bounds.width,
                                height: GlobalConst.LABEL_H)
        lblExplain.text           = DomainConst.CONTENT00483
        lblExplain.textColor      = UIColor.black
        lblExplain.font           = GlobalConst.BASE_FONT
        lblExplain.textAlignment  = .center
    }
    
    /**
     * Update login label
     */
    private func updateExplainLabel() {
        CommonProcess.updateViewPos(view: lblExplain,
                                    x: 0,
                                    y: btnOrder.frame.maxY + GlobalConst.MARGIN,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H)
    }
    
    // MARK: Actions view
    /**
     * Create actions view
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createActionsView(y: CGFloat, w: CGFloat, h: CGFloat) {
        self.actionsView.frame = CGRect(
            x: (UIScreen.main.bounds.width - w) / 2,
            y: y, width: w, height: h)
        self.actionsView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        createActionsViewContent()
    }
    
    /**
     * Create actions view (in HD mode)
     */
    private func createActionsViewHD() {
        createActionsView(y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_HD,
                          w: STATUS_VIEW_REAL_WIDTH_HD,
                          h: BUTTON_ACTION_REAL_SIZE_HD)
    }
    
    /**
     * Create actions view (in Full HD mode)
     */
    private func createActionsViewFHD() {
        createActionsView(y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD,
                          w: STATUS_VIEW_REAL_WIDTH_FHD,
                          h: BUTTON_ACTION_REAL_SIZE_FHD)
    }
    
    /**
     * Create actions view (in Full HD Landscape mode)
     */
    private func createActionsViewFHD_L() {
        createActionsView(y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD_L,
                          w: STATUS_VIEW_REAL_WIDTH_FHD_L,
                          h: BUTTON_ACTION_REAL_SIZE_FHD_L)
    }
    
    private func updateActionsView(y: CGFloat, w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: actionsView,
            x: (UIScreen.main.bounds.width - w) / 2,
            y: y, w: w, h: h)
        updateActionsViewContent()
    }
    
    /**
     * Update actions view (in HD mode)
     */
    private func updateActionsViewHD() {
        updateActionsView(
            y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_HD,
            w: STATUS_VIEW_REAL_WIDTH_HD,
            h: BUTTON_ACTION_REAL_SIZE_HD)
    }
    
    /**
     * Update actions view (in Full HD mode)
     */
    private func updateActionsViewFHD() {
        updateActionsView(
            y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD,
            w: STATUS_VIEW_REAL_WIDTH_FHD,
            h: BUTTON_ACTION_REAL_SIZE_FHD)
    }
    
    /**
     * Update actions view (in Full HD Landscape mode)
     */
    private func updateActionsViewFHD_L() {
        updateActionsView(
            y: UIScreen.main.bounds.height - 2 * BUTTON_ACTION_REAL_SIZE_FHD_L,
            w: STATUS_VIEW_REAL_WIDTH_FHD_L,
            h: BUTTON_ACTION_REAL_SIZE_FHD_L)
    }
    
    /**
     * Create actions view content
     */
    private func createActionsViewContent() {
        // Attemp list image
        var listImg = [(String, String)]()
        listImg.append((DomainConst.GAS_BUTTON_ICON_IMG_NAME, DomainConst.GAS_BUTTON_ICON_IMG_NAME))
        listImg.append((DomainConst.PROMOTE_BUTTON_ICON_IMG_NAME, DomainConst.PROMOTE_BUTTON_ICON_IMG_NAME))
        
        let btnWidth = actionsView.frame.height - GlobalConst.MARGIN
        let margin = GlobalConst.MARGIN
        let count = listActionsConfig.count
        let btnSpace    = (actionsView.frame.width - 2 * margin - btnWidth) / (CGFloat)(5 - 1)
        var font = UIFont.smallSystemFontSize
        if UIDevice.current.userInterfaceIdiom == .pad {
            font = UIFont.systemFontSize
        }
        let lblHeight = GlobalConst.LABEL_H * 4
        let lblYPos = actionsView.frame.minY + GlobalConst.LABEL_H - lblHeight
        for i in 0..<count {
            //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
//            var index = 2 * i + 1
//            if self.isFHD_LSize() {
//                index = 4 * i
//            }
            let index = 4 * i
            //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
            // Calculate frame of button
            let frame = CGRect(x: margin + CGFloat(index) * btnSpace,
                               y: margin / 2,
                               width: btnWidth,
                               height: btnWidth)
            let btn = CategoryButton(frame: frame, icon: listImg[i].0, iconActive: listImg[i].1, title: listActionsConfig[i].name, id: listActionsConfig[i].id, font: font, isUpperText: true)
//            self.adjustImageAndTitleOffsetsForButton(button: btn)
            btn.addTarget(self, action: #selector(actionsButtonTapped), for: .touchUpInside)
            let lbl = CustomLabel(frame: CGRect(x: btn.frame.minX + actionsView.frame.minX,
                                            y: lblYPos,
                                            width: btnWidth,
                                            height: lblHeight))
            lbl.text = listActionsConfig[i].name
            lbl.font = UIFont.systemFont(ofSize: font)
            lbl.textAlignment = .center
            lbl.textColor = UIColor.black
            lbl.lineBreakMode = .byWordWrapping
            lbl.numberOfLines = 0
            listActionsLabels.append(lbl)
            listActionsButtons.append(btn)
            if listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_GAS
                /*|| listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_PROMOTE*/ {
                btn.isEnabled = false
            }
            if listActionsConfig[i].id != DomainConst.ACTION_TYPE_NONE
                && listActionsConfig[i].id != DomainConst.ACTION_TYPE_SELECT_PROMOTE {
                self.actionsView.addSubview(btn)
//                self.actionsView.addSubview(lbl)
//                self.view.addSubview(lbl)
            }
        }
    }
    
    /**
     * Update actions view content
     */
    private func updateActionsViewContent() {
        let btnWidth = actionsView.frame.height - GlobalConst.MARGIN
        let margin = GlobalConst.MARGIN
        let count = listActionsButtons.count
        let btnSpace    = (actionsView.frame.width - 2 * margin - btnWidth) / (CGFloat)(5 - 1)
        
        let lblHeight = GlobalConst.LABEL_H * 4
        let lblYPos = actionsView.frame.minY + GlobalConst.LABEL_H - lblHeight
        for i in 0..<count {
            //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
//            var index = 2 * i + 1
//            if self.isFHD_LSize() {
//                index = 4 * i
//            }
            let index = 4 * i
            //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
            // Calculate frame of button
            listActionsButtons[i].frame = CGRect(x: margin + CGFloat(index) * btnSpace,
                                                 y: margin / 2,
                                                 width: btnWidth,
                                                 height: btnWidth)
            listActionsLabels[i].frame = CGRect(x: listActionsButtons[i].frame.minX + actionsView.frame.minX,
                                                y: lblYPos,
                                                width: btnWidth,
                                                height: lblHeight)
            if listActionsConfig[i].id == DomainConst.ACTION_TYPE_SELECT_PROMOTE {
                listActionsButtons[i].isHidden = true
            }
        }
    }
    
    // MARK: Group label
    /**
     * Create label
     * - parameter label:   Lable view
     * - parameter offset:  Y offset
     * - parameter text:    Lable content
     * - parameter color:   Color of text
     * - parameter isBold:  Flag is bold or not
     */
    private func createLabel(label: UILabel, offset: CGFloat, text: String, color: UIColor = UIColor.black, isBold: Bool = false) {
        label.frame = CGRect(x: 0,
                             y: offset,
                             width: UIScreen.main.bounds.width,
                             height: GlobalConst.LABEL_H)
        label.text          = text
        label.textColor     = color
        if isBold {
            label.font      = GlobalConst.BASE_BOLD_FONT
        } else {
//            label.font      = UIFont.italicSystemFont(ofSize: GlobalConst.BASE_FONT_SIZE)
            label.font      = UIFont.systemFont(ofSize: GlobalConst.BASE_FONT_SIZE)
        }
        label.textAlignment  = .center
    }
    
    /**
     * Update label
     * - parameter label:   Lable view
     * - parameter offset:  Y offset
     */
    private func updateLabel(label: UILabel, offset: CGFloat) {
        CommonProcess.updateViewPos(view: label,
                                    x: 0,
                                    y: offset,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H)
    }
    
    // MARK: Processing label
    /**
     * Create group label
     */
    private func createProcessingLabel() {
        self.createLabel(label: lblProcessing1,
                         offset: btnProcessing.frame.maxY + GlobalConst.MARGIN,
                         text: DomainConst.CONTENT00487)
        self.createLabel(label: lblProcessing2,
                         offset: lblProcessing1.frame.maxY,
                         text: DomainConst.CONTENT00488)
    }
    
    /**
     * Update group label
     */
    private func updateProcessingLabel() {
        self.updateLabel(label: lblProcessing1,
                         offset: btnProcessing.frame.maxY + GlobalConst.MARGIN)
        self.updateLabel(label: lblProcessing2,
                         offset: lblProcessing1.frame.maxY)
        
    }
    
    // MARK: Cancel order button
    /**
     * Create cancel order button
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createCancelOrderBtn(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        btnCancelOrder.frame = CGRect(x: x, y: y, width: w, height: GlobalConst.LABEL_H)
        btnCancelOrder.setTitle(DomainConst.CONTENT00320, for: UIControlState())
        btnCancelOrder.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btnCancelOrder.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        btnCancelOrder.backgroundColor = UIColor(white: 1, alpha: 0.0)
        btnCancelOrder.addTarget(self, action: #selector(btnCancelOrderTapped(_:)), for: .touchUpInside)
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            btnCancelOrder.setImage(ImageManager.getImage(named: DomainConst.CANCEL_ORDER_BUTTON_ICON_IMG_NAME), for: UIControlState())
//        } else {
//            btnCancelOrder.leftImage(image: ImageManager.getImage(named: DomainConst.CANCEL_ORDER_BUTTON_ICON_IMG_NAME)!)
//        }
        btnCancelOrder.setImage(ImageManager.getImage(named: DomainConst.CANCEL_ORDER_BUTTON_ICON_IMG_NAME), for: UIControlState())
        
        btnCancelOrder.imageView?.contentMode = .scaleAspectFit
//        btnCancelOrder.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    /**
     * Create facebook button (in HD mode)
     */
    private func createCancelBtnHD() {
        self.createCancelOrderBtn(
            x: (UIScreen.main.bounds.width - CANCEL_ORDER_BUTTON_REAL_WIDTH_HD) / 2,
            y: lblProcessing2.frame.maxY + GlobalConst.MARGIN,
            w: CANCEL_ORDER_BUTTON_REAL_WIDTH_HD,
            h: CANCEL_ORDER_BUTTON_REAL_HEIGHT_HD)
    }
    
    /**
     * Create facebook button (in Full HD mode)
     */
    private func createCancelBtnFHD() {
        self.createCancelOrderBtn(
            x: (UIScreen.main.bounds.width - CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD) / 2,
            y: lblProcessing2.frame.maxY + GlobalConst.MARGIN,
            w: CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD,
            h: CANCEL_ORDER_BUTTON_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create facebook button (in Full HD Landscape mode)
     */
    private func createCancelBtnFHD_L() {
        self.createCancelOrderBtn(
            x: (UIScreen.main.bounds.width - CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD_L) / 2,
            y: lblProcessing2.frame.maxY + GlobalConst.MARGIN,
            w: CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD_L,
            h: CANCEL_ORDER_BUTTON_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Update facebook button (in HD mode)
     */
    private func updateCancelBtnHD() {
        CommonProcess.updateViewPos(view: btnCancelOrder,
            x: (UIScreen.main.bounds.width - CANCEL_ORDER_BUTTON_REAL_WIDTH_HD) / 2,
            y: lblProcessing2.frame.maxY + GlobalConst.MARGIN,
            w: CANCEL_ORDER_BUTTON_REAL_WIDTH_HD,
            h: GlobalConst.LABEL_H)
    }
    
    /**
     * Update facebook button (in Full HD mode)
     */
    private func updateCancelBtnFHD() {
        CommonProcess.updateViewPos(view: btnCancelOrder,
            x: (UIScreen.main.bounds.width - CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD) / 2,
            y: lblProcessing2.frame.maxY + GlobalConst.MARGIN,
            w: CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD,
            h: GlobalConst.LABEL_H)
    }
    
    /**
     * Update facebook button (in Full HD Landscape mode)
     */
    private func updateCancelBtnFHD_L() {
        CommonProcess.updateViewPos(view: btnCancelOrder,
            x: (UIScreen.main.bounds.width - CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD_L) / 2,
            y: lblProcessing2.frame.maxY + GlobalConst.MARGIN,
            w: CANCEL_ORDER_BUTTON_REAL_WIDTH_FHD_L,
            h: GlobalConst.LABEL_H)
    }
    
    // MARK: Finish label
    /**
     * Create group label
     */
    private func createFinishLabel() {
        self.createLabel(label: lblFinish1,
                         offset: btnFinish.frame.maxY + GlobalConst.MARGIN,
                         text: DomainConst.CONTENT00489.uppercased(),
                         color: GlobalConst.MAIN_COLOR_GAS_24H,
                         isBold: true)
        self.createLabel(label: lblFinish2,
                         offset: lblFinish1.frame.maxY + GlobalConst.MARGIN,
                         text: DomainConst.CONTENT00490)
        self.createLabel(label: lblFinish3,
                         offset: lblFinish2.frame.maxY,
                         text: DomainConst.CONTENT00491)
    }
    
    /**
     * Update group label
     */
    private func updateFinishLabel() {
        self.updateLabel(label: lblFinish1,
                         offset: btnFinish.frame.maxY + GlobalConst.MARGIN)
        self.updateLabel(label: lblFinish2,
                         offset: lblFinish1.frame.maxY + GlobalConst.MARGIN)
        self.updateLabel(label: lblFinish3,
                         offset: lblFinish2.frame.maxY)
        
    }
    
    // MARK: Refer button
    /**
     * Create refer button
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createReferBtn(w: CGFloat, h: CGFloat) {
        btnRefer.frame = CGRect(
            x: (UIScreen.main.bounds.width - w) / 2,
            y: lblFinish3.frame.maxY,
            width: w, height: h)
//        btnRefer.setTitle(DomainConst.CONTENT00492.uppercased(), for: UIControlState())
//        btnRefer.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
//        btnRefer.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
//        btnRefer.titleLabel?.lineBreakMode = .byWordWrapping
//        btnRefer.titleLabel?.textAlignment = .center
//        btnRefer.backgroundColor = UIColor.clear
//        btnRefer.layer.borderColor = GlobalConst.MAIN_COLOR_GAS_24H.cgColor
//        btnRefer.layer.borderWidth = 1
        
        btnRefer.setImage(
            ImageManager.getImage(named: DomainConst.REFER_BUTTON_ICON_IMG_NAME),
            for: UIControlState())
        btnRefer.addTarget(self, action: #selector(btnReferTapped(_:)), for: .touchUpInside)
    }
    
    /**
     * Create refer button (in HD mode)
     */
    private func createReferBtnHD() {
        self.createReferBtn(
            w: REFER_BUTTON_REAL_WIDTH_HD,
            h: REFER_BUTTON_REAL_HEIGHT_HD)
    }
    
    /**
     * Create refer button (in Full HD mode)
     */
    private func createReferBtnFHD() {
        self.createReferBtn(
            w: REFER_BUTTON_REAL_WIDTH_FHD,
            h: REFER_BUTTON_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create refer button (in Full HD Landscape mode)
     */
    private func createReferBtnFHD_L() {
        self.createReferBtn(
            w: REFER_BUTTON_REAL_WIDTH_FHD_L,
            h: REFER_BUTTON_REAL_HEIGHT_FHD_L)
    }
    
    private func updateReferBtn(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(view: btnRefer,
                                    x: (UIScreen.main.bounds.width - w) / 2,
                                    y: lblFinish3.frame.maxY,
                                    w: w, h: h)
    }
    
    /**
     * Update refer button (in HD mode)
     */
    private func updateReferBtnHD() {
        self.updateReferBtn(
            w: REFER_BUTTON_REAL_WIDTH_HD,
            h: REFER_BUTTON_REAL_HEIGHT_HD)
    }
    
    /**
     * Update refer button (in Full HD mode)
     */
    private func updateReferBtnFHD() {
        self.updateReferBtn(
            w: REFER_BUTTON_REAL_WIDTH_FHD,
            h: REFER_BUTTON_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update refer button (in Full HD Landscape mode)
     */
    private func updateReferBtnFHD_L() {
        self.updateReferBtn(
            w: REFER_BUTTON_REAL_WIDTH_FHD_L,
            h: REFER_BUTTON_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Preview order View
    private func createPreviewView(w: CGFloat) {
        let yPos = statusView.frame.maxY + GlobalConst.MARGIN * 1.5
        previewView.setup(x: (UIScreen.main.bounds.width - w) / 2,
                          y: yPos,
                          w: w,
                          h: UIScreen.main.bounds.height - yPos - getTopHeight())
        previewView.delegate = self 
        previewView.isHidden = true
    }
    
    private func createPreviewViewHD() {
        createPreviewView(w: PREVIEW_VIEW_REAL_WIDTH_HD)
    }
    
    private func createPreviewViewFHD() {
        createPreviewView(w: PREVIEW_VIEW_REAL_WIDTH_FHD)
    }
    
    private func createPreviewViewFHD_L() {
        createPreviewView(w: PREVIEW_VIEW_REAL_WIDTH_FHD_L)
    }
    
    private func updatePreviewView(w: CGFloat) {
        let yPos = statusView.frame.maxY + GlobalConst.MARGIN * 1.5
        previewView.update(x: (UIScreen.main.bounds.width - w) / 2,
                          y: yPos,
                          w: w,
                          h: UIScreen.main.bounds.height - yPos - getTopHeight())
//        previewView.setData()
    }
    
    private func updatePreviewViewHD() {
        updatePreviewView(w: PREVIEW_VIEW_REAL_WIDTH_HD)
    }
    
    private func updatePreviewViewFHD() {
        updatePreviewView(w: PREVIEW_VIEW_REAL_WIDTH_FHD)
    }
    
    private func updatePreviewViewFHD_L() {
        updatePreviewView(w: PREVIEW_VIEW_REAL_WIDTH_FHD_L)
    }
    
    //++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
    // MARK: Promote textfield
    /**
     * Create promote text field
     */
    private func createPromoteTextField() {
        let x = actionsView.frame.minX + actionsView.frame.width / 3 - GlobalConst.MARGIN
        var y = actionsView.frame.minY + actionsView.frame.height / 4
        let w = actionsView.frame.width * 2 / 3
        var h = (actionsView.frame.height - GlobalConst.MARGIN) * 3 / 4
        if self.isPadSize() {
            y = actionsView.frame.minY + actionsView.frame.height / 4 + GlobalConst.MARGIN
            h = (actionsView.frame.height - GlobalConst.MARGIN) * 3 / 4 - 2 * GlobalConst.MARGIN
        }
        txtPromote.frame              = CGRect(x: x, y: y, width: w, height: h)
        txtPromote.placeholder        = DomainConst.CONTENT00250
        txtPromote.backgroundColor    = UIColor.white
        txtPromote.textAlignment      = .center
        txtPromote.layer.cornerRadius = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        txtPromote.returnKeyType      = .send
        txtPromote.font               = GlobalConst.BASE_FONT
        txtPromote.autocapitalizationType = .allCharacters
        txtPromote.delegate = self
        createNextBtn()
    }
    
    /**
     * Update promote textfield
     */
    internal func updatePromoteTextField() {
        let x = actionsView.frame.minX + actionsView.frame.width / 3 - GlobalConst.MARGIN
        var y = actionsView.frame.minY + actionsView.frame.height / 4
        let w = actionsView.frame.width * 2 / 3
        var h = (actionsView.frame.height - GlobalConst.MARGIN) * 3 / 4
        if self.isPadSize() {
            y = actionsView.frame.minY + actionsView.frame.height / 4 + GlobalConst.MARGIN
            h = (actionsView.frame.height - GlobalConst.MARGIN) * 3 / 4 - 2 * GlobalConst.MARGIN
        }
        CommonProcess.updateViewPos(
            view: txtPromote,
            x: x, y: y, w: w, h: h)
        updateNextBtn()
    }
    
    // MARK: Next button
    /**
     * Create next button
     */
    private func createNextBtn() {
        let sizeBtn = txtPromote.frame.height
        btnNext.frame = CGRect(
            x: txtPromote.frame.width - sizeBtn,
            y: (txtPromote.frame.height - sizeBtn) / 2,
            width: sizeBtn,
            height: sizeBtn)
        btnNext.setImage(ImageManager.getImage(named: DomainConst.NEXT_BUTTON_ICON_IMG_NAME),
                         for: .normal)
        btnNext.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: GlobalConst.MARGIN_CELL_X)
        btnNext.imageView?.contentMode = .scaleAspectFit
        btnNext.addTarget(self, action: #selector(btnNextPromoteTapped(_:)), for: .touchUpInside)
        txtPromote.rightView = btnNext
        txtPromote.rightViewMode = .always
    }
    
    private func updateNextBtn() {
        let sizeBtn = txtPromote.frame.height
        CommonProcess.updateViewPos(
            view: btnNext,
            x: txtPromote.frame.width - sizeBtn,
            y: (txtPromote.frame.height - sizeBtn) / 2,
            w: sizeBtn,
            h: sizeBtn)
    }
    //-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
}

// MARK: Protocol - NVActivityIndicatorViewable
extension G12F01S01VC: NVActivityIndicatorViewable {
    
}

// MARK: Protocol - CLLocationManagerDelegate
extension G12F01S01VC: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if let location: CLLocation = locations.last {
            // Save current location
            G12F01S01VC._currentPos = location.coordinate
//            G12F01S01VC._currentPos = CLLocationCoordinate2D(latitude: 10.819258114124, longitude: 106.724750036821)
            self.startLogic()
            GMSGeocoder().reverseGeocodeCoordinate(location.coordinate, completionHandler: {
                (response, error) in
                if error != nil, response == nil {
                    return
                }
                // Get Address
                if let result = response?.firstResult() {
                    if let lines = result.lines {
                        self.addressText = lines.joined(separator: DomainConst.ADDRESS_SPLITER)
                    }
                }
            })
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
// MARK: Protocol - CLLocationManagerDelegate
extension G12F01S01VC: OrderPreviewDelegate {
    /**
     * Handle tap on Gas select button.
     */
    func btnGasTapped(_ sender: AnyObject) {
        self.openGasSelect()
    }
    
    /**
     * Handle tap on Promote select button.
     */
    func btnPromoteTapped(_ sender: AnyObject) {
        self.openPromoteSelect()
    }
    
    /**
     * Handle tap on Delivery info update button.
     */
    func btnDeliveryInfoUpdateTapped(_ sender: AnyObject) {
        showAlert(message: DomainConst.CONTENT00362)
    }
    
    /**
     * Handle tap on Cancel button.
     */
    func btnCancelTapped(_ sender: AnyObject) {
        showHidePreview(isShow: false)
    }
    
    /**
     * Handle tap on Next button.
     */
    func btnNextTapped(_ sender: AnyObject) {
        previewView.enableNextButton(isEnabled: false)
        btnCancelOrder.isEnabled = false
        // Get data from preview view
        let deliveryInfo = previewView.getData()
        self.addressText = deliveryInfo.2
        // Update last order value
        _lastOrder.first_name = deliveryInfo.0
        _lastOrder.phone = deliveryInfo.1
        // Request transaction complete
        requestTransactionComplete(isReview: false, lastOrder: _lastOrder)
    }
    
    /**
     * Handle dismiss view controller
     */
    func dismissVC(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

//++ BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
// MARK: Protocol - UITextFieldDelegate
extension G12F01S01VC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let value = textField.text {
            self.updatePromoteCode(text: value)
        }
        return false
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let parent = BaseViewController.getCurrentViewController() {
            self.keyboardTopY = parent.keyboardTopY
        }
        UIView.animate(withDuration: 0.3, animations: {
            textField.frame = CGRect(x: (UIScreen.main.bounds.width - textField.frame.width) / 2,
                                    y: self.getTopHeight(),
                                    width: textField.frame.width,
                                    height: textField.frame.height)
        })
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.updatePromoteTextField()
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Get value from text field
        if let value = txtPromote.text {
            // Check if value is empty or not
            if !value.isEmpty {
                // Hide keyboard
                self.view.endEditing(true)
                PromotionAddRequest.request(
                    action: #selector(finishRequestAddPromotionCode),
                    view: self,
                    code: value)
            }
        }
        return true
    }
}
//-- BUG0173-SPJ (NguyenPT 20171207) Add promotion function into Gas Order screen
