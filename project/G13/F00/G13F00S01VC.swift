//
//  G13F00S01VC.swift
//  project
//
//  Created by SPJ on 9/27/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G13F00S01VC: BaseParentViewController {
    // MARK: Properties
    /** Segment */
    var segment:            UISegmentedControl  = UISegmentedControl(
        items: [
            DomainConst.CONTENT00500.uppercased(),
            DomainConst.CONTENT00499.uppercased()
        ])
    
    /** Refer view */
    var referView:          UIView              = UIView()
    /** Label note */
    var lblReferNote:       UILabel             = UILabel()
    /** Label note */
    var lblReferPoint:      UILabel             = UILabel()
    /** Segment refer view */
    var referSegment:       UISegmentedControl  = UISegmentedControl(
        items: [
            DomainConst.CONTENT00501.uppercased(),
            DomainConst.CONTENT00502.uppercased()
        ])
    /** Code textfield */
    var txtCode:            UITextField         = UITextField()
    /** QR code view */
    var imgQRCode:          UIImageView         = UIImageView()
    /** Button share code */
    var btnShareCode:       UIButton            = UIButton(type: UIButtonType.custom)
    
    /** Using code view */
    var usingCodeView:      UIView              = UIView()
    /** Label */
    var lblUsingCodeNote:   UILabel             = UILabel()
    /** Segment refer view */
    var usingCodeSegment:   UISegmentedControl  = UISegmentedControl(
        items: [
            DomainConst.CONTENT00501.uppercased(),
            DomainConst.CONTENT00502.uppercased()
        ])
    /** Code textfield */
    var txtUsingCode:       UITextField         = UITextField()
    /** Button next */
    var btnNext:            UIButton            = UIButton(type: .custom)
    /** Table list promotion */
    var tblPromotion:       UITableView         = UITableView()
    /** Current page */
    var page:               Int                 = 0
    /** Current data */
    var _data:              PromotionListRespModel      = PromotionListRespModel()
    /** Refrest control */
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    /** Flag active Refer-QR code tab */
    var _isActiveReferQRCode:   Bool            = false
    /** Flag active Refer-QR code tab */
    var _isActiveUsingCode:     Bool            = false
    
    /** Mode */
    var mode:               Int                 = -1
    /** Refering mode: */
    var refMode:            Int                 = 0
    /** Using code mode: */
    var usingCodeMode:      Int                 = 0
    /** Refer code value */
    var referCode:          String              = DomainConst.BLANK
    /** Refer link */
//    var referLink:          String              = BaseModel.shared.getServerURL() + "referral/code?code="
    var referLink:          String              = DomainConst.REFER_LINK
    
    // MARK: Static values
    
    // MARK: Constant
    /** Refer mode */
    let MODE_REFER:         Int                 = 1
    /** Using code mode */
    let MODE_USING_CODE:    Int                 = 0
    /** Refer mode: Normal code */
    let MODE_NORMAL_CODE:   Int                 = 0
    /** Refer mode: QR code */
    let MODE_QR_CODE:       Int                 = 1
    
    // Segment
    var SEGMENT_PROMOTE_REAL_HEIGHT_HD      = BaseViewController.H_RATE_HD * GlobalConst.SEGMENT_PROMOTE_HEIGHT
    var SEGMENT_PROMOTE_REAL_HEIGHT_FHD     = BaseViewController.H_RATE_FHD * GlobalConst.SEGMENT_PROMOTE_HEIGHT
    var SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L   = BaseViewController.H_RATE_FHD_L * GlobalConst.SEGMENT_PROMOTE_HEIGHT
    var WIDTH_REAL_HD                       = BaseViewController.W_RATE_HD * GlobalConst.HD_SCREEN_BOUND.w - 2 * GlobalConst.MARGIN
    var WIDTH_REAL_FHD                      = BaseViewController.W_RATE_FHD * GlobalConst.HD_SCREEN_BOUND.w - 2 * GlobalConst.MARGIN
    var WIDTH_REAL_FHD_L                    = BaseViewController.W_RATE_FHD_L * GlobalConst.HD_SCREEN_BOUND.w - 2 * GlobalConst.MARGIN
    // Segment refer size
    var REFER_BTN_REAL_WIDTH_HD        = GlobalConst.RESEND_BUTTON_WIDTH * BaseViewController.W_RATE_HD * 2
    var REFER_BTN_REAL_WIDTH_FHD       = GlobalConst.RESEND_BUTTON_WIDTH * BaseViewController.W_RATE_FHD * 2
    var REFER_BTN_REAL_WIDTH_FHD_L     = GlobalConst.RESEND_BUTTON_WIDTH * BaseViewController.W_RATE_FHD_L * 2
    
    // Refer text
    var TEXTFIELD_PROMOTE_REAL_WIDTH_HD       = GlobalConst.TEXTFIELD_PROMOTE_WIDTH * BaseViewController.W_RATE_HD
    var TEXTFIELD_PROMOTE_REAL_HEIGHT_HD      = GlobalConst.SEGMENT_PROMOTE_HEIGHT * BaseViewController.H_RATE_HD
    var TEXTFIELD_PROMOTE_REAL_WIDTH_FHD      = GlobalConst.TEXTFIELD_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD
    var TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD     = GlobalConst.SEGMENT_PROMOTE_HEIGHT * BaseViewController.H_RATE_FHD
    var TEXTFIELD_PROMOTE_REAL_WIDTH_FHD_L    = GlobalConst.TEXTFIELD_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD_L
    var TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD_L   = GlobalConst.SEGMENT_PROMOTE_HEIGHT * BaseViewController.H_RATE_FHD_L
    
    // Share code button
    var SHARE_CODE_BUTTON_REAL_WIDTH_HD    = GlobalConst.BUTTON_SHARE_PROMOTE_WIDTH * BaseViewController.W_RATE_HD
    var SHARE_CODE_BUTTON_REAL_WIDTH_FHD   = GlobalConst.BUTTON_SHARE_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD
    var SHARE_CODE_BUTTON_REAL_WIDTH_FHD_L = GlobalConst.BUTTON_SHARE_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD_L
    
    var SHARE_CODE_BUTTON_REAL_HEIGHT_HD    = GlobalConst.LABEL_H
    var SHARE_CODE_BUTTON_REAL_HEIGHT_FHD   = GlobalConst.LABEL_H
    var SHARE_CODE_BUTTON_REAL_HEIGHT_FHD_L = GlobalConst.LABEL_H
    
    /** QR code image */
    var QR_CODE_REAL_SIZE_HD                = GlobalConst.QR_CODE_SIZE * BaseViewController.H_RATE_HD
    var QR_CODE_REAL_SIZE_FHD               = GlobalConst.QR_CODE_SIZE * BaseViewController.H_RATE_FHD
    var QR_CODE_REAL_SIZE_FHD_L             = GlobalConst.QR_CODE_SIZE * BaseViewController.H_RATE_FHD_L
    
    // Next button
    var CONFIRM_NEXT_BUTTON_REAL_SIZE_HD      = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * BaseViewController.H_RATE_HD
    var CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD     = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * BaseViewController.H_RATE_FHD
    var CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD_L   = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * BaseViewController.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00247)
        //requestReferInfo()
        //++
//        if BaseModel.shared.sharedCode == DomainConst.BLANK{
//            requestReferInfo()
//        }
//        else{
//            self.mode = MODE_USING_CODE
//            //switchMode()
//            segment.selectedSegmentIndex = 0
//            referView.isHidden = true
//            usingCodeView.isHidden = false
//            tblPromotion.isHidden = false
//            let fullName : String = BaseModel.shared.sharedCode
//            let fullNameArr : [String] = fullName.components(separatedBy: "/")
//            var id : String = fullName
//            if fullNameArr.count > 0 {
//                id = fullNameArr[fullNameArr.count - 1]
//            }
//            txtUsingCode.text = id
//            btnNextTapped(self)
//        }
        //--
    }
    
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
        SEGMENT_PROMOTE_REAL_HEIGHT_HD      = BaseViewController.H_RATE_HD * GlobalConst.SEGMENT_PROMOTE_HEIGHT
        SEGMENT_PROMOTE_REAL_HEIGHT_FHD     = BaseViewController.H_RATE_FHD * GlobalConst.SEGMENT_PROMOTE_HEIGHT
        SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L   = BaseViewController.H_RATE_FHD_L * GlobalConst.SEGMENT_PROMOTE_HEIGHT
        WIDTH_REAL_HD                       = BaseViewController.W_RATE_HD * GlobalConst.HD_SCREEN_BOUND.w - 2 * GlobalConst.MARGIN
        WIDTH_REAL_FHD                      = BaseViewController.W_RATE_FHD * GlobalConst.HD_SCREEN_BOUND.w - 2 * GlobalConst.MARGIN
        WIDTH_REAL_FHD_L                    = BaseViewController.W_RATE_FHD_L * GlobalConst.HD_SCREEN_BOUND.w - 2 * GlobalConst.MARGIN
        // Segment refer size
        REFER_BTN_REAL_WIDTH_HD        = GlobalConst.RESEND_BUTTON_WIDTH * BaseViewController.W_RATE_HD * 2
        REFER_BTN_REAL_WIDTH_FHD       = GlobalConst.RESEND_BUTTON_WIDTH * BaseViewController.W_RATE_FHD * 2
        REFER_BTN_REAL_WIDTH_FHD_L     = GlobalConst.RESEND_BUTTON_WIDTH * BaseViewController.W_RATE_FHD_L * 2
        
        // Refer text
        TEXTFIELD_PROMOTE_REAL_WIDTH_HD       = GlobalConst.TEXTFIELD_PROMOTE_WIDTH * BaseViewController.W_RATE_HD
        TEXTFIELD_PROMOTE_REAL_HEIGHT_HD      = GlobalConst.SEGMENT_PROMOTE_HEIGHT * BaseViewController.H_RATE_HD
        TEXTFIELD_PROMOTE_REAL_WIDTH_FHD      = GlobalConst.TEXTFIELD_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD
        TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD     = GlobalConst.SEGMENT_PROMOTE_HEIGHT * BaseViewController.H_RATE_FHD
        TEXTFIELD_PROMOTE_REAL_WIDTH_FHD_L    = GlobalConst.TEXTFIELD_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD_L
        TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD_L   = GlobalConst.SEGMENT_PROMOTE_HEIGHT * BaseViewController.H_RATE_FHD_L
        
        // Share code button
        SHARE_CODE_BUTTON_REAL_WIDTH_HD    = GlobalConst.BUTTON_SHARE_PROMOTE_WIDTH * BaseViewController.W_RATE_HD
        SHARE_CODE_BUTTON_REAL_WIDTH_FHD   = GlobalConst.BUTTON_SHARE_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD
        SHARE_CODE_BUTTON_REAL_WIDTH_FHD_L = GlobalConst.BUTTON_SHARE_PROMOTE_WIDTH * BaseViewController.W_RATE_FHD_L
        SHARE_CODE_BUTTON_REAL_HEIGHT_HD    = GlobalConst.LABEL_H
        SHARE_CODE_BUTTON_REAL_HEIGHT_FHD   = GlobalConst.LABEL_H
        SHARE_CODE_BUTTON_REAL_HEIGHT_FHD_L = GlobalConst.LABEL_H
        
        /** QR code image */
        QR_CODE_REAL_SIZE_HD                = GlobalConst.QR_CODE_SIZE * BaseViewController.H_RATE_HD
        QR_CODE_REAL_SIZE_FHD               = GlobalConst.QR_CODE_SIZE * BaseViewController.H_RATE_FHD
        QR_CODE_REAL_SIZE_FHD_L             = GlobalConst.QR_CODE_SIZE * BaseViewController.H_RATE_FHD_L
        
        // Next button
        CONFIRM_NEXT_BUTTON_REAL_SIZE_HD      = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * BaseViewController.H_RATE_HD
        CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD     = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * BaseViewController.H_RATE_FHD
        CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD_L   = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * BaseViewController.H_RATE_FHD_L
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            createSegmentHD()
            createReferViewHD()
            createUsingCodeViewHD()
            createNextBtnHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                createSegmentFHD()
                createReferViewFHD()
                createUsingCodeViewFHD()
                createNextBtnFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                createSegmentFHD_L()
                createReferViewFHD_L()
                createUsingCodeViewFHD_L()
                createNextBtnFHD_L()
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(tblPromotion)
        createPromotionList()
        self.view.addSubview(segment)
        self.view.addSubview(referView)
        self.view.addSubview(usingCodeView)
//        segment.selectedSegmentIndex = MODE_USING_CODE
//        self.mode = MODE_USING_CODE
//        switchMode()
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
           updateSegmentHD()
           updateReferViewHD()
           updateUsingCodeViewHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updateSegmentFHD()
                updateReferViewFHD()
                updateUsingCodeViewFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updateSegmentFHD_L()
                updateReferViewFHD_L()
                updateUsingCodeViewFHD_L()
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        updatePromotionList()
    }
    
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = PromotionListRespModel(jsonString: data)
        if model.isSuccess() {
            _data.clearData()
            _data.total_page = model.total_page
            _data.total_record = model.total_record
            _data.append(contentOf: model.getRecord())
            tblPromotion.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Event handler
    internal func segmentChanged(_ sender: AnyObject) {
        self.mode = segment.selectedSegmentIndex
        switchMode()
    }
    
    internal func refSegmentChanged(_ sender: AnyObject) {
        self.refMode = referSegment.selectedSegmentIndex
        switchReferMode()
    }
    
    internal func usingCodeSegmentChanged(_ sender: AnyObject) {
        self.usingCodeMode = usingCodeSegment.selectedSegmentIndex
        switchUsingCodeMode()
    }
    
    /**
     * Handle when tap on cancel order button
     */
    func btnShareCodeTapped(_ sender: AnyObject) {
        let text = String.init(format: DomainConst.CONTENT00526,
                               referCode,
                               referLink + referCode)
        let textToShare = [text]
        // Setup activity view controller
        let activityVC = UIActivityViewController(activityItems: textToShare,
                                                  applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.btnShareCode
        // Exclude some activity types from the list
//        activityVC.excludedActivityTypes = [
//            .addToReadingList,
//            .airDrop, .assignToContact, .copyToPasteboard,
//            .mail, .message,
//            .postToFacebook, .postToFlickr,
//            .postToTencentWeibo,
//            .postToTwitter,
//            .postToVimeo,
//            .print,
//            .saveToCameraRoll,
//        ]
        
        // Present
        self.present(activityVC,
                     animated: true,
                     completion: nil)
    }
    
    /**
     * Handle when tap on next button
     */
    func btnNextTapped(_ sender: AnyObject) {
        if !(txtUsingCode.text?.isEmpty)! {
            PromotionAddRequest.request(
                action: #selector(finishRequestAddPromotionCode),
                view: self,
                code: txtUsingCode.text!)
        }
    }
    
    internal func finishScanQRCode(_ notification: Notification) {
        var data = (notification.object as! String)
        // Check if data is link, remove link
        if data.contains(referLink) {
            data = data.substring(from: referLink.characters.count)
        }
        txtUsingCode.text = data.uppercased()
        usingCodeMode = MODE_NORMAL_CODE
        usingCodeSegment.selectedSegmentIndex = MODE_NORMAL_CODE
    }
    
    internal func finishRequestReferInfo(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = ReferInfoRespModel(jsonString: data)
        if model.isSuccess() {
            referCode = model.getRecord().invite_code.uppercased()
            txtCode.text = referCode.uppercased()
            createQRCode()
            updateReferNoteLabel(value: model.getRecord().invited_list.count)
            updateReferPointLabel(value: model.getRecord().current_point)
        } else {
            showAlert(message: model.message)
        }
    }
    
    internal func finishRequestAddPromotionCode(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        showAlert(message: model.message)
        //++ BUG0163-SPJ (NguyenPT 20171122) Reload list promotion
        requestData()
        //-- BUG0163-SPJ (NguyenPT 20171122) Reload list promotion
    }
    
    // MARK: Logic
    /**
     * Request data
     */
    internal func requestData(action: Selector = #selector(setData(_:))) {
        PromotionListRequest.requestPromotionList(
            action: action,
            view: self,
            page: String(self.page))
    }
    
    /**
     * Reset data
     */
    private func resetData() {
        _data.clearData()
        // Reset current search value
        self.page      = 0
        // Reload table
        tblPromotion.reloadData()
    }
    
    /**
     * Handle refresh
     */
    internal func handleRefresh(_ sender: AnyObject) {
        self.resetData()
        requestData(action: #selector(finishHandleRefresh(_:)))
    }
    
    /**
     * Handle finish refresh
     */
    internal func finishHandleRefresh(_ notification: Notification) {
        setData(notification)
        refreshControl.endRefreshing()
    }
    
    // MARK: Utilities
    private func requestReferInfo() {
        ReferInfoRequest.request(action: #selector(finishRequestReferInfo),
                                 view: self)
    }
    /**
     * Switch screen mode
     */
    private func switchMode() {
        switch mode {
        case MODE_REFER:            // Refer mode
            referView.isHidden = false
            usingCodeView.isHidden = true
            tblPromotion.isHidden = true
            requestReferInfo()
            break
        case MODE_USING_CODE:       // Using code mode
            referView.isHidden = true
            usingCodeView.isHidden = false
            tblPromotion.isHidden = false
            requestData()
            break
        default:
            break
        }
    }
    
    /**
     * Switch screen mode
     */
    private func switchReferMode() {
        switch refMode {
        case MODE_NORMAL_CODE:          // Normal code
            txtCode.isHidden = false
            imgQRCode.isHidden = true
            break
        case MODE_QR_CODE:              // QR code
            txtCode.isHidden = true
            imgQRCode.isHidden = false
            break
        default:
            break
        }
        updateShareCodeBtnFull()
    }
    
    /**
     * Switch screen mode
     */
    private func switchUsingCodeMode() {
        switch usingCodeMode {
        case MODE_NORMAL_CODE:          // Normal code
            break
        case MODE_QR_CODE:              // QR code
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(finishScanQRCode(_:)),
                name: NSNotification.Name(rawValue: G13Const.NOTIFY_NAME_G13_SCAN_QR_FINISH),
                object: nil)
            openScanner()
            break
        default:
            break
        }
    }
    
    /**
     * Open QR scanner
     */
    private func openScanner() {
        ScannerVC._notificationName = G13Const.NOTIFY_NAME_G13_SCAN_QR_FINISH
        let frameworkBundle = Bundle(identifier: DomainConst.HARPY_FRAMEWORK_BUNDLE_NAME)
        let scan = ScannerVC(nibName: ScannerVC.theClassName, bundle: frameworkBundle)
        self.navigationController?.pushViewController(scan, animated: true)
        usingCodeMode = MODE_NORMAL_CODE
        usingCodeSegment.selectedSegmentIndex = MODE_NORMAL_CODE
    }
    
    /**
     * Create QR code
     */
    private func createQRCode() {
        imgQRCode.image = {
            if var qrCode = QRCode(referLink + referCode) {
                qrCode.size = imgQRCode.bounds.size
                qrCode.errorCorrection = .High
                return qrCode.image
            } else {
                return UIImage()
            }
        }()
    }
    
    /**
     * Show Refer-QR code tab
     */
    public func activeQRCode() {
        _isActiveReferQRCode = true
        segment.selectedSegmentIndex = MODE_REFER
        self.mode = segment.selectedSegmentIndex
        switchMode()
        referSegment.selectedSegmentIndex = MODE_QR_CODE
        self.refMode = referSegment.selectedSegmentIndex
        switchReferMode()
        _isActiveReferQRCode = false
    }
    
    public func activeUsingCode(code: String) {
        _isActiveUsingCode = true
        self.mode = MODE_USING_CODE
        self.usingCodeMode = MODE_NORMAL_CODE
        self.txtUsingCode.text = code
//        segment.selectedSegmentIndex = MODE_USING_CODE
//        self.mode = segment.selectedSegmentIndex
//        switchMode()
//        usingCodeSegment.selectedSegmentIndex = MODE_NORMAL_CODE
//        self.usingCodeMode = MODE_NORMAL_CODE
//        switchUsingCodeMode()
        _isActiveUsingCode = false
        self.btnNextTapped(self)
    }
    
    // MARK: Segment control
    /**
     * create segment control
     * - parameter w: Width of control
     * - parameter h: Height of control
     */
    private func createSegment(w: CGFloat, h: CGFloat) {
        segment.frame = CGRect(x: (UIScreen.main.bounds.width - w ) / 2,
                               y: getTopHeight() + GlobalConst.MARGIN,
                               width: w, height: h)
        if self.mode == -1 {
            self.mode = MODE_REFER
        }
//        segment.selectedSegmentIndex = MODE_REFER
//        self.mode = segment.selectedSegmentIndex
        segment.selectedSegmentIndex = self.mode
        switchMode()
        let segAttribute: NSDictionary = [
            NSForegroundColorAttributeName: GlobalConst.MAIN_COLOR_GAS_24H
        ]
        let segAttributeGray: NSDictionary = [
            NSForegroundColorAttributeName: ColorFromRGB().getColorFromRGB(0x999999)
        ]
        segment.setTitleTextAttributes(segAttribute as? [AnyHashable : Any], for: .selected)
        segment.setTitleTextAttributes(segAttributeGray as? [AnyHashable : Any], for: .normal)
        segment.layer.borderWidth = 0.0
        segment.layer.borderColor = GlobalConst.PROMOTION_BKG_COLOR.cgColor
        segment.tintColor = GlobalConst.PROMOTION_BKG_COLOR
        segment.addTarget(self, action: #selector(segmentChanged(_:)),
                          for: .valueChanged)
    }
    
    private func createSegmentHD() {
        createSegment(w: WIDTH_REAL_HD, h: SEGMENT_PROMOTE_REAL_HEIGHT_HD)
    }
    
    private func createSegmentFHD() {
        createSegment(w: WIDTH_REAL_FHD, h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    private func createSegmentFHD_L() {
        createSegment(w: WIDTH_REAL_FHD_L, h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    private func updateSegment(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(view: segment,
                                    x: (UIScreen.main.bounds.width - w ) / 2,
                                    y: getTopHeight() + GlobalConst.MARGIN,
                                    w: w, h: h)
    }
    
    private func updateSegmentHD() {
        updateSegment(w: WIDTH_REAL_HD, h: SEGMENT_PROMOTE_REAL_HEIGHT_HD)
    }
    
    private func updateSegmentFHD() {
        updateSegment(w: WIDTH_REAL_FHD, h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    private func updateSegmentFHD_L() {
        updateSegment(w: WIDTH_REAL_FHD_L, h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Refer View
    private func createReferView(h: CGFloat) {
        referView.frame = CGRect(x: segment.frame.minX,
                                 y: segment.frame.maxY,
                                 width: segment.frame.width,
                                 height: h)
//        referView.isHidden = false
        referView.backgroundColor = GlobalConst.PROMOTION_BKG_COLOR
        referView.layer.cornerRadius = GlobalConst.BOTTOM_MSG_VIEW_CORNER_RADIUS
        
        referView.addSubview(lblReferNote)
        referView.addSubview(lblReferPoint)
        referView.addSubview(referSegment)
        referView.addSubview(txtCode)
        referView.addSubview(imgQRCode)
        referView.addSubview(btnShareCode)
    }
    
    private func createReferViewHD() {
        // Create note label
        createReferNoteLabel()
        createReferSegmentHD()
        createReferTextFieldHD()
        createQRCodeImgHD()
        createShareCodeBtnHD()
        createReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func createReferViewFHD() {
        // Create note label
        createReferNoteLabel()
        createReferSegmentFHD()
        createReferTextFieldFHD()
        createQRCodeImgFHD()
        createShareCodeBtnFHD()
        createReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func createReferViewFHD_L() {
        // Create note label
        createReferNoteLabel()
        createReferSegmentFHD_L()
        createReferTextFieldFHD_L()
        createQRCodeImgFHD_L()
        createShareCodeBtnFHD_L()
        createReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func updateReferView(h: CGFloat) {
        CommonProcess.updateViewPos(
            view: referView,
            x: segment.frame.minX,
            y: segment.frame.maxY,
            w: segment.frame.width,
            h: h)
    }
    
    private func updateReferViewHD() {
        updateReferNoteLabel()
        updateReferSegmentHD()
        updateReferTextFieldHD()
        updateQRCodeImgHD()
        updateShareCodeBtnHD()
        updateReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func updateReferViewFHD() {
        updateReferNoteLabel()
        updateReferSegmentFHD()
        updateReferTextFieldFHD()
        updateQRCodeImgFHD()
        updateShareCodeBtnFHD()
        updateReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func updateReferViewFHD_L() {
        updateReferNoteLabel()
        updateReferSegmentFHD_L()
        updateReferTextFieldFHD_L()
        updateQRCodeImgFHD_L()
        updateShareCodeBtnFHD_L()
        updateReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    // MARK: Refer View - Note label
    private func createReferNoteLabel() {
        lblReferNote.frame = CGRect(x: 0, y: GlobalConst.MARGIN,
                                    width: segment.frame.width,
                                    height: GlobalConst.LABEL_H)
        lblReferNote.textColor = UIColor.black
        lblReferNote.textAlignment = .center
        lblReferNote.text = "Bạn đã giới thiệu 0 người sử dụng"
        lblReferNote.font = GlobalConst.BASE_FONT
        createReferPointLabel()
    }
    
    private func updateReferNoteLabel() {
        CommonProcess.updateViewPos(
            view: lblReferNote,
            x: 0, y: GlobalConst.MARGIN,
            w: segment.frame.width,
            h: GlobalConst.LABEL_H)
        updateReferPointLabel()
    }
    
    private func updateReferNoteLabel(value: Int) {
        let text = String.init(format: DomainConst.CONTENT00534,
                               value)
        lblReferNote.text = text
        CommonProcess.makeMultiColorLabel(lbl: lblReferNote,
                                          lstString: [String(value)],
                                          colors: [GlobalConst.MAIN_COLOR_GAS_24H])
    }
    
    // MARK: Refer View - Point label
    private func createReferPointLabel() {
        lblReferPoint.frame = CGRect(x: 0,
                                     y: lblReferNote.frame.maxY + GlobalConst.MARGIN,
                                    width: segment.frame.width,
                                    height: GlobalConst.LABEL_H)
        lblReferPoint.textColor = UIColor.black
        lblReferPoint.textAlignment = .center
        lblReferPoint.text = "Bạn đang có 0 điểm thưởng"
        lblReferPoint.font = GlobalConst.BASE_FONT
    }
    
    private func updateReferPointLabel() {
        CommonProcess.updateViewPos(
            view: lblReferPoint,
            x: 0, y: lblReferNote.frame.maxY + GlobalConst.MARGIN,
            w: segment.frame.width,
            h: GlobalConst.LABEL_H)
    }
    
    private func updateReferPointLabel(value: String) {
        let text = String.init(format: DomainConst.CONTENT00535,
                               value)
        lblReferPoint.text = text
        CommonProcess.makeMultiColorLabel(lbl: lblReferPoint,
                                          lstString: [String(value)],
                                          colors: [GlobalConst.MAIN_COLOR_GAS_24H])
    }
    
    // MARK: Refer View - Refer segment
    private func createReferSegment(w: CGFloat, h: CGFloat) {
        referSegment.frame = CGRect(x: (segment.frame.width - w ) / 2,
                               y: lblReferPoint.frame.maxY + GlobalConst.MARGIN,
                               width: w, height: h)
        referSegment.tintColor = GlobalConst.MAIN_COLOR_GAS_24H
        referSegment.selectedSegmentIndex = 0
        referSegment.addTarget(self, action: #selector(refSegmentChanged(_:)),
                          for: .valueChanged)
    }
    
    private func createReferSegmentHD() {
        createReferSegment(
            w: REFER_BTN_REAL_WIDTH_HD,
            h: SEGMENT_PROMOTE_REAL_HEIGHT_HD)
    }
    
    private func createReferSegmentFHD() {
        createReferSegment(
            w: REFER_BTN_REAL_WIDTH_FHD,
            h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    private func createReferSegmentFHD_L() {
        createReferSegment(
            w: REFER_BTN_REAL_WIDTH_FHD_L,
            h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    private func updateReferSegment(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: referSegment,
            x: (segment.frame.width - w) / 2,
            y: lblReferPoint.frame.maxY + GlobalConst.MARGIN,
            w: w, h: h)
        if _isActiveReferQRCode {
            referSegment.selectedSegmentIndex = MODE_QR_CODE
            self.refMode = referSegment.selectedSegmentIndex
            switchReferMode()
            _isActiveReferQRCode = false
        }
    }
    
    private func updateReferSegmentHD() {
        updateReferSegment(w: REFER_BTN_REAL_WIDTH_HD,
                           h: SEGMENT_PROMOTE_REAL_HEIGHT_HD)
    }
    
    private func updateReferSegmentFHD() {
        updateReferSegment(w: REFER_BTN_REAL_WIDTH_FHD,
                           h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    private func updateReferSegmentFHD_L() {
        updateReferSegment(w: REFER_BTN_REAL_WIDTH_FHD_L,
                           h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Refer View - Refer textfield
    /**
     * Create code text field
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createReferTextField(w: CGFloat, h: CGFloat) {
        txtCode.frame              = CGRect(x: (segment.frame.width - w) / 2,
                                            y: referSegment.frame.maxY + GlobalConst.MARGIN,
                                            width: w, height: h)
        txtCode.placeholder        = DomainConst.BLANK
        txtCode.backgroundColor    = UIColor.white
        txtCode.textAlignment      = .center
        txtCode.layer.cornerRadius = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        txtCode.keyboardType       = .default
        txtCode.returnKeyType      = .done
        txtCode.autocapitalizationType = .allCharacters
        txtCode.isUserInteractionEnabled = false
    }
    
    /**
     * Create code text field (in HD mode)
     */
    private func createReferTextFieldHD() {
        self.createReferTextField(
            w: TEXTFIELD_PROMOTE_REAL_WIDTH_HD,
            h: TEXTFIELD_PROMOTE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create code text field (in Full HD mode)
     */
    private func createReferTextFieldFHD() {
        self.createReferTextField(
            w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD,
            h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create code text field (in Full HD Landscape mode)
     */
    private func createReferTextFieldFHD_L() {
        self.createReferTextField(
            w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD_L,
            h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    private func updateReferTextField(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: txtCode,
            x: (segment.frame.width - w) / 2,
            y: referSegment.frame.maxY + GlobalConst.MARGIN,
            w: w, h: h)
    }
    
    /**
     * Update refer text field (in HD mode)
     */
    private func updateReferTextFieldHD() {
        updateReferTextField(w: TEXTFIELD_PROMOTE_REAL_WIDTH_HD,
                             h: TEXTFIELD_PROMOTE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update refer text field (in Full HD mode)
     */
    private func updateReferTextFieldFHD() {
        updateReferTextField(w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD,
                             h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update refer text field (in Full HD Landscape mode)
     */
    private func updateReferTextFieldFHD_L() {
        updateReferTextField(w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD_L,
                             h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Refer View - Share code
    private func createShareCodeButton(w: CGFloat, h: CGFloat) {
        var yPos = txtCode.frame.maxY
        if refMode == MODE_QR_CODE {
            yPos = imgQRCode.frame.maxY
        }
        btnShareCode.frame = CGRect(
            x: (segment.frame.width - w) / 2,
            y: yPos + GlobalConst.MARGIN,
            width: w, height: h)
        btnShareCode.setTitle(DomainConst.CONTENT00503, for: UIControlState())
        btnShareCode.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btnShareCode.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        btnShareCode.backgroundColor = UIColor(white: 1, alpha: 0.0)
        btnShareCode.addTarget(self, action: #selector(btnShareCodeTapped(_:)), for: .touchUpInside)
        btnShareCode.setImage(ImageManager.getImage(named: DomainConst.DISCOUNT_SHARE_ICON_IMG_NAME), for: UIControlState())
        btnShareCode.imageView?.contentMode = .scaleAspectFit
        
    }
    
    private func createShareCodeBtnHD() {
        createShareCodeButton(w: SHARE_CODE_BUTTON_REAL_WIDTH_HD,
                              h: SHARE_CODE_BUTTON_REAL_HEIGHT_HD)
    }
    
    private func createShareCodeBtnFHD() {
        createShareCodeButton(w: SHARE_CODE_BUTTON_REAL_WIDTH_FHD,
                              h: SHARE_CODE_BUTTON_REAL_HEIGHT_FHD)
    }
    
    private func createShareCodeBtnFHD_L() {
        createShareCodeButton(w: SHARE_CODE_BUTTON_REAL_WIDTH_FHD_L,
                              h: SHARE_CODE_BUTTON_REAL_HEIGHT_FHD_L)
    }
    
    private func updateShareCodeButton(w: CGFloat, h: CGFloat) {
        var yPos = txtCode.frame.maxY
        if refMode == MODE_QR_CODE {
            yPos = imgQRCode.frame.maxY
        }
        CommonProcess.updateViewPos(
            view: btnShareCode,
            x: (segment.frame.width - w) / 2,
            y: yPos + GlobalConst.MARGIN,
            w: w, h: h)
    }
    
    private func updateShareCodeBtnHD() {
        updateShareCodeButton(w: SHARE_CODE_BUTTON_REAL_WIDTH_HD,
                              h: SHARE_CODE_BUTTON_REAL_HEIGHT_HD)
    }
    
    private func updateShareCodeBtnFHD() {
        updateShareCodeButton(w: SHARE_CODE_BUTTON_REAL_WIDTH_FHD,
                              h: SHARE_CODE_BUTTON_REAL_HEIGHT_FHD)
    }
    
    private func updateShareCodeBtnFHD_L() {
        updateShareCodeButton(w: SHARE_CODE_BUTTON_REAL_WIDTH_FHD_L,
                              h: SHARE_CODE_BUTTON_REAL_HEIGHT_FHD_L)
    }
    
    private func updateShareCodeBtnFull() {
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            updateShareCodeBtnHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updateShareCodeBtnFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updateShareCodeBtnFHD_L()
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        if mode == MODE_REFER {
            updateReferView(h: btnShareCode.frame.maxY + GlobalConst.MARGIN)
        } else if mode == MODE_USING_CODE {
            updateReferView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
        }
    }
    
    // MARK: Refer View - QR code image
    private func createQRCodeImg(size: CGFloat) {
        imgQRCode.frame = CGRect(
            x: (segment.frame.width - size) / 2,
            y: referSegment.frame.maxY + GlobalConst.MARGIN,
            width: size, height: size)
        imgQRCode.isHidden = true
        createQRCode()
    }
    
    private func createQRCodeImgHD() {
        createQRCodeImg(size: QR_CODE_REAL_SIZE_HD)
    }
    
    private func createQRCodeImgFHD() {
        createQRCodeImg(size: QR_CODE_REAL_SIZE_FHD)
    }
    
    private func createQRCodeImgFHD_L() {
        createQRCodeImg(size: QR_CODE_REAL_SIZE_FHD_L)
    }
    
    private func updateQRCodeImg(size: CGFloat) {
        CommonProcess.updateViewPos(
            view: imgQRCode,
            x: (segment.frame.width - size) / 2,
            y: referSegment.frame.maxY + GlobalConst.MARGIN,
            w: size, h: size)
    }
    
    private func updateQRCodeImgHD() {
        updateQRCodeImg(size: QR_CODE_REAL_SIZE_HD)
    }
    
    private func updateQRCodeImgFHD() {
        updateQRCodeImg(size: QR_CODE_REAL_SIZE_FHD)
    }
    
    private func updateQRCodeImgFHD_L() {
        updateQRCodeImg(size: QR_CODE_REAL_SIZE_FHD_L)
    }
    
    // MARK: Using code View
    private func createUsingCodeView(h: CGFloat) {
        usingCodeView.frame = CGRect(
            x: segment.frame.minX,
            y: segment.frame.maxY,
            width: segment.frame.width,
            height: h)
//        usingCodeView.isHidden = true
        usingCodeView.backgroundColor = GlobalConst.PROMOTION_BKG_COLOR
        
//        usingCodeView.addSubview(lblUsingCodeNote)
        usingCodeView.addSubview(usingCodeSegment)
        usingCodeView.addSubview(txtUsingCode)
    }
    
    private func createUsingCodeViewHD() {
        createUsingCodeNoteLabel()
        createUsingCodeSegmentHD()
        createUsingCodeTextFieldHD()
        createUsingCodeView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func createUsingCodeViewFHD() {
        createUsingCodeNoteLabel()
        createUsingCodeSegmentFHD()
        createUsingCodeTextFieldFHD()
        createUsingCodeView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func createUsingCodeViewFHD_L() {
        createUsingCodeNoteLabel()
        createUsingCodeSegmentFHD_L()
        createUsingCodeTextFieldFHD_L()
        createUsingCodeView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func updateUsingCodeView(h: CGFloat) {
        CommonProcess.updateViewPos(
            view: usingCodeView,
            x: segment.frame.minX,
            y: segment.frame.maxY,
            w: segment.frame.width,
            h: h)
    }
    
    private func updateUsingCodeViewHD() {
        updateUsingCodeNoteLabel()
        updateUsingCodeSegmentHD()
        updateUsingCodeTextFieldHD()
        updateUsingCodeView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func updateUsingCodeViewFHD() {
        updateUsingCodeNoteLabel()
        updateUsingCodeSegmentFHD()
        updateUsingCodeTextFieldFHD()
        updateUsingCodeView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    private func updateUsingCodeViewFHD_L() {
        updateUsingCodeNoteLabel()
        updateUsingCodeSegmentFHD_L()
        updateUsingCodeTextFieldFHD_L()
        updateUsingCodeView(h: txtUsingCode.frame.maxY + GlobalConst.MARGIN)
    }
    
    // MARK: Using code View - Note label
    private func createUsingCodeNoteLabel() {
        lblUsingCodeNote.frame = CGRect(x: 0, y: GlobalConst.MARGIN,
                                    width: segment.frame.width,
                                    height: GlobalConst.LABEL_H)
        lblUsingCodeNote.textColor = UIColor.black
        lblUsingCodeNote.textAlignment = .center
        lblUsingCodeNote.text = "Bạn đã sử dụng 5 mã khuyến mãi"
        lblUsingCodeNote.font = GlobalConst.BASE_FONT
    }
    
    private func updateUsingCodeNoteLabel() {
        CommonProcess.updateViewPos(
            view: lblUsingCodeNote,
            x: 0, y: GlobalConst.MARGIN,
            w: segment.frame.width,
            h: GlobalConst.LABEL_H)
    }
    
    // MARK: Using code View - Using code segment
    private func createUsingCodeSegment(w: CGFloat, h: CGFloat) {
        usingCodeSegment.frame = CGRect(x: (segment.frame.width - w ) / 2,
                                    y: lblUsingCodeNote.frame.maxY + GlobalConst.MARGIN,
                                    width: w, height: h)
        usingCodeSegment.tintColor = GlobalConst.MAIN_COLOR_GAS_24H
        usingCodeSegment.selectedSegmentIndex = 0
        usingCodeSegment.addTarget(self, action: #selector(usingCodeSegmentChanged(_:)),
                               for: .valueChanged)
    }
    
    private func createUsingCodeSegmentHD() {
        createUsingCodeSegment(
            w: REFER_BTN_REAL_WIDTH_HD,
            h: SEGMENT_PROMOTE_REAL_HEIGHT_HD)
    }
    
    private func createUsingCodeSegmentFHD() {
        createUsingCodeSegment(
            w: REFER_BTN_REAL_WIDTH_FHD,
            h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    private func createUsingCodeSegmentFHD_L() {
        createUsingCodeSegment(
            w: REFER_BTN_REAL_WIDTH_FHD_L,
            h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    private func updateUsingCodeSegment(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: usingCodeSegment,
            x: (segment.frame.width - w) / 2,
            y: lblUsingCodeNote.frame.maxY + GlobalConst.MARGIN,
            w: w, h: h)
        if _isActiveUsingCode {
            usingCodeSegment.selectedSegmentIndex = MODE_NORMAL_CODE
            self.usingCodeMode = MODE_NORMAL_CODE
            switchUsingCodeMode()
            _isActiveUsingCode = false
        }
    }
    
    private func updateUsingCodeSegmentHD() {
        updateUsingCodeSegment(w: REFER_BTN_REAL_WIDTH_HD,
                               h: SEGMENT_PROMOTE_REAL_HEIGHT_HD)
    }
    
    private func updateUsingCodeSegmentFHD() {
        updateUsingCodeSegment(w: REFER_BTN_REAL_WIDTH_FHD,
                               h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    private func updateUsingCodeSegmentFHD_L() {
        updateUsingCodeSegment(w: REFER_BTN_REAL_WIDTH_FHD_L,
                               h: SEGMENT_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Using code View - Using code textfield
    /**
     * Create code text field
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createUsingCodeTextField(w: CGFloat, h: CGFloat) {
        txtUsingCode.frame         = CGRect(x: (segment.frame.width - w) / 2,
                                            y: usingCodeSegment.frame.maxY + GlobalConst.MARGIN,
                                            width: w, height: h)
        txtUsingCode.placeholder        = DomainConst.BLANK
        txtUsingCode.backgroundColor    = UIColor.white
        txtUsingCode.textAlignment      = .center
        txtUsingCode.layer.cornerRadius = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        txtUsingCode.keyboardType       = .default
        txtUsingCode.autocapitalizationType = .allCharacters
        txtUsingCode.returnKeyType      = .done
    }
    
    /**
     * Create code text field (in HD mode)
     */
    private func createUsingCodeTextFieldHD() {
        self.createUsingCodeTextField(
            w: TEXTFIELD_PROMOTE_REAL_WIDTH_HD,
            h: TEXTFIELD_PROMOTE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create code text field (in Full HD mode)
     */
    private func createUsingCodeTextFieldFHD() {
        self.createUsingCodeTextField(
            w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD,
            h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create code text field (in Full HD Landscape mode)
     */
    private func createUsingCodeTextFieldFHD_L() {
        self.createUsingCodeTextField(
            w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD_L,
            h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    private func updateUsingCodeTextField(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: txtUsingCode,
            x: (segment.frame.width - w) / 2,
            y: usingCodeSegment.frame.maxY + GlobalConst.MARGIN,
            w: w, h: h)
    }
    
    /**
     * Update using code text field (in HD mode)
     */
    private func updateUsingCodeTextFieldHD() {
        updateUsingCodeTextField(w: TEXTFIELD_PROMOTE_REAL_WIDTH_HD,
                                 h: TEXTFIELD_PROMOTE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update using code text field (in Full HD mode)
     */
    private func updateUsingCodeTextFieldFHD() {
        updateUsingCodeTextField(w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD,
                                 h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update using code text field (in Full HD Landscape mode)
     */
    private func updateUsingCodeTextFieldFHD_L() {
        updateUsingCodeTextField(w: TEXTFIELD_PROMOTE_REAL_WIDTH_FHD_L,
                                 h: TEXTFIELD_PROMOTE_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Using code View - Using code next button
    /**
     * Create next button
     */
    private func createNextBtn() {
        btnNext.setImage(ImageManager.getImage(named: DomainConst.NEXT_BUTTON_ICON_IMG_NAME),
                         for: .normal)
        btnNext.addTarget(self, action: #selector(btnNextTapped(_:)), for: .touchUpInside)
        txtUsingCode.rightView = btnNext
        txtUsingCode.rightViewMode = .always
    }
    
    /**
     * Create next button (in HD mode)
     */
    private func createNextBtnHD() {
        createNextBtn()
        CommonProcess.updateViewPos(view: btnNext,
                                    x: CGFloat(txtUsingCode.frame.width - CONFIRM_NEXT_BUTTON_REAL_SIZE_HD * 2),
                                    y: (txtUsingCode.frame.height - CONFIRM_NEXT_BUTTON_REAL_SIZE_HD ) / 2,
                                    w: CONFIRM_NEXT_BUTTON_REAL_SIZE_HD,
                                    h: CONFIRM_NEXT_BUTTON_REAL_SIZE_HD)
    }
    
    /**
     * Create next button (in Full HD mode)
     */
    private func createNextBtnFHD() {
        createNextBtn()
        CommonProcess.updateViewPos(view: btnNext,
                                    x: CGFloat(txtUsingCode.frame.width - CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD * 2),
                                    y: (txtUsingCode.frame.height - CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD ) / 2,
                                    w: CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD,
                                    h: CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD)
    }
    
    /**
     * Create next button (in Full HD Landscape mode)
     */
    private func createNextBtnFHD_L() {
        createNextBtn()
        CommonProcess.updateViewPos(view: btnNext,
                                    x: CGFloat(txtUsingCode.frame.width - CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD_L * 2),
                                    y: (txtUsingCode.frame.height - CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD_L ) / 2,
                                    w: CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD_L,
                                    h: CONFIRM_NEXT_BUTTON_REAL_SIZE_FHD_L)
    }
    
    // MARK: Table view promotion list
    private func createPromotionList() {
        let yPos = usingCodeView.frame.maxY + GlobalConst.MARGIN/* - getTopHeight() / 2*/
        tblPromotion.frame = CGRect(
            x: (UIScreen.main.bounds.width - usingCodeView.frame.width) / 2,
            y: yPos,
            width: usingCodeView.frame.width,
            height: UIScreen.main.bounds.height - yPos)
        tblPromotion.addSubview(refreshControl)
        tblPromotion.separatorStyle = .none
        tblPromotion.dataSource = self
        tblPromotion.isHidden = true
    }
    
    private func updatePromotionList() {
        let yPos = usingCodeView.frame.maxY + GlobalConst.MARGIN/* - getTopHeight() / 2*/
        CommonProcess.updateViewPos(
            view: tblPromotion,
            x: (UIScreen.main.bounds.width - usingCodeView.frame.width) / 2,
            y: yPos,
            w: usingCodeView.frame.width,
            h: UIScreen.main.bounds.height - yPos)
        tblPromotion.reloadData()
    }
}

// MARK: Protocol - NVActivityIndicatorViewable
extension G13F00S01VC: NVActivityIndicatorViewable {
    
}


// MARK: Protocol - UITableViewDataSource
extension G13F00S01VC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._data.record.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self._data.record.count {
            return UITableViewCell()
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.row < self._data.getRecord().count {
            let data = self._data.getRecord()[indexPath.row]
            cell.textLabel?.text = data.name
            cell.textLabel?.font = GlobalConst.BASE_BOLD_FONT
            cell.textLabel?.textColor = GlobalConst.MAIN_COLOR_GAS_24H
            
            cell.detailTextLabel?.text = data.note + "\n"
                + DomainConst.CONTENT00248 + DomainConst.TEXT_SPLITER
                + " " + data.expiry_date
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            cell.detailTextLabel?.numberOfLines = 0
            
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConst.LABEL_H * 5
//        return UITableViewAutomaticDimension
    }
}
