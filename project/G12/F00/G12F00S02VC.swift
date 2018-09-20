//
//  G12F00S02VC.swift
//  project
//
//  Created by SPJ on 9/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G12F00S02VC: BaseChildViewController {
    // MARK: Properties
    /** Information table view */
    var tblInfo:            UITableView             = UITableView()
    /** List of information data */
    var listInfo:           [ConfigurationModel]    = [ConfigurationModel]()
    /** Current page */
    var page:               Int                     = 0
    /** Id */
    var id:                 String                  = DomainConst.BLANK
    /** Employee view */
    var employeeView:       UIView                  = UIView()
    /** Flag check if employee view is collapsed */
    var isEmployeeViewCollapsed:    Bool            = true
    /** Employee label */
    var lblEmployeeTitle:           UILabel         = UILabel()
    /** Avatar image */
    var imgAvatar:                  UIImageView     = UIImageView()
    /** Label Employee name */
    var lblEmployeeName:            UILabel         = UILabel()
    /** Label Employee code */
    var lblEmployeeCode:            UILabel         = UILabel()
    /** Label agent */
    var lblAgent:                   UILabel         = UILabel()
    /** Rating label */
    var lblRating:                  UILabel         = UILabel()
    /** Rating separator label */
    var lblRatingSeparator:         UILabel         = UILabel()
    /** Rating bar */
    var ratingBar:                  RatingBar       = RatingBar()
    /** Note textfield */
    var txtNote:                    UITextView      = UITextView()
    /** Button Submit */
    var btnSubmit:                  UIButton        = UIButton()
    
    // MARK: Static values
    // MARK: Constant
    var EMPLOYEE_VIEW_REAL_WIDTH_HD     = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var EMPLOYEE_VIEW_REAL_WIDTH_FHD    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var EMPLOYEE_VIEW_REAL_WIDTH_FHD_L  = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    
    var EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_HD = GlobalConst.LABEL_H * 11
    var EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_FHD = GlobalConst.LABEL_H * 11
    var EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_FHD_L = GlobalConst.LABEL_H * 11
    
    var EMPLOYEE_INFO_REAL_HEIGHT_HD    = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_HD
    var EMPLOYEE_INFO_REAL_HEIGHT_FHD   = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD
    var EMPLOYEE_INFO_REAL_HEIGHT_FHD_L = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD_L
    // Submit button
    var SUBMIT_BUTTON_REAL_WIDTH_HD     = GlobalConst.SUBMIT_BUTTON_WIDTH * BaseViewController.W_RATE_HD
    var SUBMIT_BUTTON_REAL_HEIGHT_HD    = GlobalConst.SUBMIT_BUTTON_HEIGHT * BaseViewController.H_RATE_HD
    var SUBMIT_BUTTON_REAL_WIDTH_FHD    = GlobalConst.SUBMIT_BUTTON_WIDTH * BaseViewController.W_RATE_FHD
    var SUBMIT_BUTTON_REAL_HEIGHT_FHD   = GlobalConst.SUBMIT_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD
    var SUBMIT_BUTTON_REAL_WIDTH_FHD_L  = GlobalConst.SUBMIT_BUTTON_WIDTH * BaseViewController.W_RATE_FHD_L
    var SUBMIT_BUTTON_REAL_HEIGHT_FHD_L = GlobalConst.SUBMIT_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00506)
        requestData()
        self.isEmployeeViewCollapsed = true
        showHideEmployeeView(isShow: !self.isEmployeeViewCollapsed)
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
        // Employee view
        EMPLOYEE_VIEW_REAL_WIDTH_HD     = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
        EMPLOYEE_VIEW_REAL_WIDTH_FHD    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
        EMPLOYEE_VIEW_REAL_WIDTH_FHD_L  = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
        
        EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_HD = GlobalConst.LABEL_H * 11
        EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_FHD = GlobalConst.LABEL_H * 11
        EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_FHD_L = GlobalConst.LABEL_H * 11
        
        EMPLOYEE_INFO_REAL_HEIGHT_HD    = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_HD
        EMPLOYEE_INFO_REAL_HEIGHT_FHD   = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD
        EMPLOYEE_INFO_REAL_HEIGHT_FHD_L = GlobalConst.DELIVERY_MAP_TOP_VIEW_HEIGHT * BaseViewController.H_RATE_FHD_L
        // Submit button
        SUBMIT_BUTTON_REAL_WIDTH_HD     = GlobalConst.SUBMIT_BUTTON_WIDTH * BaseViewController.W_RATE_HD
        SUBMIT_BUTTON_REAL_HEIGHT_HD    = GlobalConst.SUBMIT_BUTTON_HEIGHT * BaseViewController.H_RATE_HD
        SUBMIT_BUTTON_REAL_WIDTH_FHD    = GlobalConst.SUBMIT_BUTTON_WIDTH * BaseViewController.W_RATE_FHD
        SUBMIT_BUTTON_REAL_HEIGHT_FHD   = GlobalConst.SUBMIT_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD
        SUBMIT_BUTTON_REAL_WIDTH_FHD_L  = GlobalConst.SUBMIT_BUTTON_WIDTH * BaseViewController.W_RATE_FHD_L
        SUBMIT_BUTTON_REAL_HEIGHT_FHD_L = GlobalConst.SUBMIT_BUTTON_HEIGHT * BaseViewController.H_RATE_FHD_L
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        // Create information table view
        createInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            createEmployeeViewHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                createEmployeeViewFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                createEmployeeViewFHD_L()
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(tblInfo)
        self.view.addSubview(employeeView)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        // Update information table view
        updateInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            updateEmployeeViewHD(isShow: !self.isEmployeeViewCollapsed)
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updateEmployeeViewFHD(isShow: !self.isEmployeeViewCollapsed)
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updateEmployeeViewFHD_L(isShow: !self.isEmployeeViewCollapsed)
                break
            default:
                break
            }
            
            break
        default:
            break
        }
    }
    
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderViewRespModel(jsonString: data)
        if model.isSuccess() {
            self.listInfo.removeAll()
            // Add material list
            for item in model.getRecord().order_detail {
                if !item.material_id.isEmpty {
                    self.listInfo.append(ConfigurationModel(orderDetail: item))
                }
            }
            // Add information
            if model.getRecord().discount_amount != DomainConst.NUMBER_ZERO_VALUE {
                self.listInfo.append(ConfigurationModel(
                    id: DomainConst.ORDER_INFO_DISCOUNT,
                    name: DomainConst.CONTENT00239,
                    iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                    value: DomainConst.SPLITER_TYPE1 + model.getRecord().discount_amount))
            }
            //++ BUG0161-SPJ (NguyenPT 20171120) Add promotion amount in Order detail view
            // Add information
            if model.getRecord().promotion_amount != DomainConst.NUMBER_ZERO_VALUE {
                self.listInfo.append(ConfigurationModel(
                    id: DomainConst.ORDER_INFO_PROMOTION,
                    name: DomainConst.CONTENT00247,
                    iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                    value: DomainConst.SPLITER_TYPE1 + model.getRecord().promotion_amount))
            }
            //-- BUG0161-SPJ (NguyenPT 20171120) Add promotion amount in Order detail view
            //++ BUG0192-SPJ (NguyenPT 20180402) Add gas remain
            // Gas remain
            let gasRemain = model.getRecord().gas_remain_amount
            if !gasRemain.isEmpty {
                self.listInfo.append(ConfigurationModel(
                    id: DomainConst.ORDER_INFO_GAS_DU_ID,
                    name: DomainConst.CONTENT00261,
                    iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                    value: DomainConst.SPLITER_TYPE1 + gasRemain))
            }
            //-- BUG0192-SPJ (NguyenPT 20180402) Add gas remain
            self.listInfo.append(ConfigurationModel(
                id: DomainConst.ORDER_INFO_TOTAL_MONEY_ID,
                name: DomainConst.CONTENT00218,
                iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                value: model.getRecord().grand_total))
            
            tblInfo.reloadData()
            updateEmployeeViewData(data: model.getRecord())
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Event handler
    /**
     * Handle when finish rating request
     */
    internal func finishRating(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            self.btnSubmit.isHidden = true
        }
        showAlert(message: model.message)
    }
    
    /**
     * Handle when tap on employee view
     * - parameter gestureRecognizer: UITapGestureRecognizer object
     */
    internal func handleTappedEmployeeView(_ gestureRecognizer: UITapGestureRecognizer) {
        self.isEmployeeViewCollapsed = !self.isEmployeeViewCollapsed
        showHideEmployeeView(isShow: !self.isEmployeeViewCollapsed)
    }
    
    /**
     * Handle when tap on submit button
     */
    func btnSubmitTapped(_ sender: AnyObject) {
        let ratingValue = self.ratingBar.getRatingValue()
        var comment = self.txtNote.text
        if comment == DomainConst.CONTENT00457 {
            comment = DomainConst.BLANK
        }
        RatingRequest.request(action: #selector(finishRating(_:)),
                              view: self,
                              id: self.id,
                              rating: ratingValue,
                              comment: comment!)
    }
    
    // MARK: Utilities
    /**
     * Update employee view data
     * - parameter data: Order object
     */
    private func updateEmployeeViewData(data: OrderBean) {
        // Show hide employee view base on order status
        self.employeeView.isHidden = (data.status_number != DomainConst.ORDER_STATUS_COMPLETE)
        // Set data for: image
        if !data.employee_image.isEmpty {
            self.imgAvatar.getImgFromUrl(link: data.employee_image,
                                         contentMode: self.imgAvatar.contentMode)
        }
        // Name
        self.lblEmployeeName.text   = data.employee_name
        // Code
        self.lblEmployeeCode.text   = data.employee_code
        // Agent info
        self.lblAgent.text          = data.agent_name
        // Get rating value
        if let value = Int.init(data.rating) {
            self.ratingBar.setRatingValue(value: value)
            if value != 0 { // Rating success already
                ratingBar.isUserInteractionEnabled = false
                txtNote.isEditable = false
                btnSubmit.isHidden = true
                self.txtNote.text = data.rating_comment
            } else {
                ratingBar.isUserInteractionEnabled = true
                txtNote.isEditable = true
                btnSubmit.isHidden = false
            }
        } else {    // Get value failed
            self.ratingBar.setRatingValue(value: 0)
            ratingBar.isUserInteractionEnabled = true
            txtNote.isEditable = true
            btnSubmit.isHidden = false
        }
    }
    
    /**
     * Set id value
     * - parameter id: Id value to set
     */
    public func setId(id: String) {
        self.id = id
    }
    
    private func requestData(action: Selector = #selector(setData(_:))) {
        OrderViewRequest.requestOrderView(
            action: action,
            view: self, id: id)
    }
    
    // MARK: Information table view
    private func createInfoTableView() {
        tblInfo.frame = CGRect(x: 0, y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
        tblInfo.dataSource = self
    }
    
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height)
    }
    
    // MARK: Employee view
    private func createEmployeeView(w: CGFloat, infoHeight: CGFloat) {
        employeeView.frame = CGRect(
            x: (UIScreen.main.bounds.width - w) / 2,
            y: getTopHeight(),
            width: w,
            height: UIScreen.main.bounds.height - getTopHeight())
        employeeView.backgroundColor = GlobalConst.PROMOTION_BKG_COLOR
        let tappedRecog = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTappedEmployeeView(_:)))
        employeeView.addGestureRecognizer(tappedRecog)
        
        // Title
        createEmployeeTitleLabel()
        // Image avatar
        createImgAvatar(h: infoHeight)
        let leftMargin = imgAvatar.frame.maxX + GlobalConst.MARGIN
        // Employee name
        createEmployeeNameLabel(x: leftMargin,
                                w: w - infoHeight,
                                h: infoHeight / 3)
        // Employee code
        createEmployeeCodeLabel(x: leftMargin,
                                w: w - infoHeight,
                                h: infoHeight / 3)
        // Employee agent
        createAgentLabel(x: leftMargin,
                                w: w - infoHeight,
                                h: infoHeight / 3)
        // Rating label
        createRatingLabel()
        // Rating bar
        createRatingBar(h: infoHeight / 3)
        
        // Note
        createNoteTextView()
        
        employeeView.addSubview(lblEmployeeTitle)
        employeeView.addSubview(imgAvatar)
        employeeView.addSubview(lblEmployeeName)
        employeeView.addSubview(lblEmployeeCode)
        employeeView.addSubview(lblAgent)
        employeeView.addSubview(lblRatingSeparator)
        employeeView.addSubview(lblRating)
        employeeView.addSubview(ratingBar)
        employeeView.addSubview(txtNote)
    }
    
    private func createEmployeeViewHD() {
        createEmployeeView(w: EMPLOYEE_VIEW_REAL_WIDTH_HD,
                           infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_HD)
        createSubmitBtnHD()
        employeeView.addSubview(btnSubmit)
    }
    
    private func createEmployeeViewFHD() {
        createEmployeeView(w: EMPLOYEE_VIEW_REAL_WIDTH_FHD,
                           infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_FHD)
        createSubmitBtnFHD()
        employeeView.addSubview(btnSubmit)
    }
    
    private func createEmployeeViewFHD_L() {
        createEmployeeView(w: EMPLOYEE_VIEW_REAL_WIDTH_FHD_L,
                           infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_FHD_L)
        createSubmitBtnFHD_L()
        employeeView.addSubview(btnSubmit)
    }
    
    private func updateEmployeeView(y: CGFloat, w: CGFloat, infoHeight: CGFloat) {
        CommonProcess.updateViewPos(
            view: employeeView,
            x: (UIScreen.main.bounds.width - w) / 2,
            y: y,
            w: w, h: UIScreen.main.bounds.height - getTopHeight())
        // Title
        updateEmployeeTitle()
        // Image avatar
        updateImgAvatar(h: infoHeight)
        let leftMargin = imgAvatar.frame.maxX + GlobalConst.MARGIN
        // Employee name
        updateEmployeeNameLabel(x: leftMargin,
                                w: w - infoHeight,
                                h: infoHeight / 3)
        // Employee code
        updateEmployeeCodeLabel(x: leftMargin,
                                w: w - infoHeight,
                                h: infoHeight / 3)
        // Agent
        updateAgentLabel(x: leftMargin,
                                w: w - infoHeight,
                                h: infoHeight / 3)
        // Rating label
        updateRatingLabel()
        // Rating bar
        updateRatingBar(h: infoHeight / 3)
        
        // Note
        updateNoteTextView()
    }
    
    /**
     * Update employee view in HD mode
     * - parameter isShow: Flag show/hide
     */
    private func updateEmployeeViewHD(isShow: Bool = true) {
        if isShow {
            updateEmployeeView(
                y: getTopHeight(),
                w: EMPLOYEE_VIEW_REAL_WIDTH_HD,
                infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_HD)
        } else {
            updateEmployeeView(
                y: UIScreen.main.bounds.height - EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_HD,
                w: EMPLOYEE_VIEW_REAL_WIDTH_HD,
                infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_HD)
        }
        updateSubmitBtnHD()
    }
    
    /**
     * Update employee view in Full HD mode
     * - parameter isShow: Flag show/hide
     */
    private func updateEmployeeViewFHD(isShow: Bool = true) {
        if isShow {
            updateEmployeeView(
                y: getTopHeight(),
                w: EMPLOYEE_VIEW_REAL_WIDTH_FHD,
                infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_FHD)
        } else {
            updateEmployeeView(
                y: UIScreen.main.bounds.height - EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_FHD,
                w: EMPLOYEE_VIEW_REAL_WIDTH_FHD,
                infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_FHD)
        }
        updateSubmitBtnFHD()
    }
    
    /**
     * Update employee view in Full HD Landscape mode
     * - parameter isShow: Flag show/hide
     */
    private func updateEmployeeViewFHD_L(isShow: Bool = true) {
        if isShow {
            updateEmployeeView(
                y: getTopHeight(),
                w: EMPLOYEE_VIEW_REAL_WIDTH_FHD_L,
                infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_FHD_L)
        } else {
            updateEmployeeView(
                y: UIScreen.main.bounds.height - EMPLOYEE_VIEW_COLLAPSED_REAL_HEIGHT_FHD_L,
                w: EMPLOYEE_VIEW_REAL_WIDTH_FHD_L,
                infoHeight: EMPLOYEE_INFO_REAL_HEIGHT_FHD_L)
        }
        updateSubmitBtnFHD_L()
    }
    
    private func showHideEmployeeView(isShow: Bool) {
        let duration = 0.5
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            UIView.animate(withDuration: duration, animations: {
                self.updateEmployeeViewHD(isShow: isShow)
            })
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                UIView.animate(withDuration: duration, animations: {
                    self.updateEmployeeViewFHD(isShow: isShow)
                })
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                UIView.animate(withDuration: duration, animations: {
                    self.updateEmployeeViewFHD_L(isShow: isShow)
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
    
    // MARK: Employee view - Employee title
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
                                        width: employeeView.frame.width,
                                        height: GlobalConst.LABEL_H * 2)
    }
    
    private func updateEmployeeTitle() {
        CommonProcess.updateViewPos(view: lblEmployeeTitle,
                                    x: 0, y: 0,
                                    w: employeeView.frame.width,
                                    h: GlobalConst.LABEL_H * 2)
    }
    
    // MARK: Employee view - Avatar image
    private func createImgAvatar(h: CGFloat) {
        // Image avatar
        let imgSize = h - 2 * GlobalConst.MARGIN
        self.imgAvatar.frame = CGRect(x: GlobalConst.MARGIN,
                                      y: (h - imgSize) / 2 + lblEmployeeTitle.frame.maxY,
                                      width: imgSize, height: imgSize)
        self.imgAvatar.contentMode = .scaleAspectFit
        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = imgSize / 2
        self.imgAvatar.layer.borderWidth = 2
        self.imgAvatar.layer.borderColor = UIColor.orange.cgColor
        self.imgAvatar.image = ImageManager.getImage(named: DomainConst.DEFAULT_IMG_NAME)
    }
    
    private func updateImgAvatar(h: CGFloat) {
        let imgSize = h - 2 * GlobalConst.MARGIN
        CommonProcess.updateViewPos(view: imgAvatar,
                                    x: GlobalConst.MARGIN,
                                    y: (h - imgSize) / 2 + lblEmployeeTitle.frame.maxY,
                                    w: imgSize, h: imgSize)
    }
    
    // MARK: Employee view - Employee name
    private func createEmployeeNameLabel(x: CGFloat, w: CGFloat, h: CGFloat) {
        self.lblEmployeeName.frame = CGRect(
            x: x, y: lblEmployeeTitle.frame.maxY,
            width: w, height: h)
        self.lblEmployeeName.text = "Nguyễn Thanh Tùng"
        self.lblEmployeeName.font = GlobalConst.BASE_FONT
        self.lblEmployeeName.textAlignment = .left
    }
    
    private func updateEmployeeNameLabel(x: CGFloat, w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: lblEmployeeName,
            x: x, y: lblEmployeeTitle.frame.maxY,
            w: w, h: h)
    }
    
    // MARK: Employee view - Employee code
    private func createEmployeeCodeLabel(x: CGFloat, w: CGFloat, h: CGFloat) {
        self.lblEmployeeCode.frame = CGRect(
            x: x, y: lblEmployeeName.frame.maxY,
            width: w, height: h)
        self.lblEmployeeCode.text = "DKMN0948"
        self.lblEmployeeCode.font = GlobalConst.BASE_FONT
        self.lblEmployeeCode.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        self.lblEmployeeCode.textAlignment = .left
    }
    
    private func updateEmployeeCodeLabel(x: CGFloat, w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: lblEmployeeCode,
            x: x, y: lblEmployeeName.frame.maxY,
            w: w, h: h)
    }
    
    // MARK: Employee view - agent
    private func createAgentLabel(x: CGFloat, w: CGFloat, h: CGFloat) {
        self.lblAgent.frame = CGRect(
            x: x, y: lblEmployeeCode.frame.maxY,
            width: w, height: h)
        self.lblAgent.text = "Đại lý Quận 10"
        self.lblAgent.font = GlobalConst.BASE_FONT
        self.lblAgent.textAlignment = .left
    }
    
    private func updateAgentLabel(x: CGFloat, w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: lblAgent,
            x: x, y: lblEmployeeCode.frame.maxY,
            w: w, h: h)
    }
    
    // MARK: Employee view - Employee rating label
    /**
     * Create employee rating label
     */
    private func createRatingLabel() {
        lblRating.text           = DomainConst.CONTENT00507.uppercased()
        lblRating.textColor      = GlobalConst.MAIN_COLOR_GAS_24H
        lblRating.font           = GlobalConst.BASE_BOLD_FONT
        lblRating.textAlignment  = .center
        let width = DomainConst.CONTENT00507.uppercased().widthOfString(usingFont: GlobalConst.BASE_BOLD_FONT) + 2 * GlobalConst.MARGIN
        lblRating.frame          = CGRect(
            x: (employeeView.frame.width - width) / 2,
            y: imgAvatar.frame.maxY + GlobalConst.MARGIN,
            width: width,
            height: GlobalConst.LABEL_H * 2)
        lblRating.backgroundColor = GlobalConst.PROMOTION_BKG_COLOR
        
        lblRatingSeparator.text           = DomainConst.SEPARATOR_STR
        lblRatingSeparator.textColor      = GlobalConst.MAIN_COLOR_GAS_24H
        lblRatingSeparator.font           = GlobalConst.BASE_BOLD_FONT
        lblRatingSeparator.textAlignment  = .center
        lblRatingSeparator.lineBreakMode  = .byCharWrapping
        lblRatingSeparator.frame          = CGRect(
            x: GlobalConst.MARGIN, y: imgAvatar.frame.maxY + GlobalConst.MARGIN,
            width: employeeView.frame.width - GlobalConst.MARGIN * 2,
            height: GlobalConst.LABEL_H * 2)
    }
    
    private func updateRatingLabel() {
        let width = DomainConst.CONTENT00507.uppercased().widthOfString(usingFont: GlobalConst.BASE_BOLD_FONT) + 2 * GlobalConst.MARGIN
        CommonProcess.updateViewPos(view: lblRating,
                                    x: (employeeView.frame.width - width) / 2,
                                    y: imgAvatar.frame.maxY + GlobalConst.MARGIN,
                                    w: width,
                                    h: GlobalConst.LABEL_H * 2)
        CommonProcess.updateViewPos(view: lblRatingSeparator,
                                    x: GlobalConst.MARGIN,
                                    y: imgAvatar.frame.maxY + GlobalConst.MARGIN,
                                    w: employeeView.frame.width - GlobalConst.MARGIN * 2,
                                    h: GlobalConst.LABEL_H * 2)
    }
    
    // MARK: Employee view - Employee rating bar
    private func createRatingBar(h: CGFloat) {
        let ratingSize = h
        let ratingWidth = ratingSize * (CGFloat)(ratingBar.getStarNumber()) + (ratingBar.getStarSpace() * (CGFloat)(ratingBar.getStarNumber() - 1))
        ratingBar.frame = CGRect(x: (employeeView.frame.width - ratingWidth) / 2,
                                 y: lblRating.frame.maxY,
                                 width: ratingWidth,
                                 height: h)
        ratingBar.setRatingValue(value: 4)
        ratingBar.delegate = self
    }
    
    private func updateRatingBar(h: CGFloat) {
        let ratingSize = h
        let ratingWidth = ratingSize * (CGFloat)(ratingBar.getStarNumber()) + (ratingBar.getStarSpace() * (CGFloat)(ratingBar.getStarNumber() - 1))
        CommonProcess.updateViewPos(view: ratingBar,
                                    x: (employeeView.frame.width - ratingWidth) / 2,
                                    y: lblRating.frame.maxY,
                                    w: ratingWidth,
                                    h: h)
    }
    
    // MARK: Employee view - Employee note
    private func createNoteTextView() {
        txtNote.frame = CGRect(x: GlobalConst.MARGIN,
                               y: ratingBar.frame.maxY + GlobalConst.MARGIN,
                               width: employeeView.frame.width - 2 * GlobalConst.MARGIN,
                               height: GlobalConst.EDITTEXT_H * 3)
        txtNote.font = GlobalConst.BASE_FONT
        txtNote.text = DomainConst.CONTENT00457
        txtNote.delegate = self
        CommonProcess.setBorder(view: txtNote, radius: GlobalConst.BUTTON_CORNER_RADIUS)
    }
    
    private func updateNoteTextView() {
        CommonProcess.updateViewPos(
            view: txtNote,
            x: GlobalConst.MARGIN,
            y: ratingBar.frame.maxY + GlobalConst.MARGIN,
            w: employeeView.frame.width - 2 * GlobalConst.MARGIN,
            h: GlobalConst.EDITTEXT_H * 3)
    }
    
    // MARK: Submit button
    /**
     * Create Submit button
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createSubmitBtn(w: CGFloat, h: CGFloat) {
        btnSubmit.frame = CGRect(x: (employeeView.frame.width - w) / 2,
                                 y: txtNote.frame.maxY + GlobalConst.MARGIN,
                                 width: w, height: h)
        btnSubmit.setTitle(DomainConst.CONTENT00180.uppercased(), for: UIControlState())
        btnSubmit.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        btnSubmit.backgroundColor = UIColor.clear
        btnSubmit.layer.borderColor = GlobalConst.MAIN_COLOR_GAS_24H.cgColor
        btnSubmit.layer.borderWidth = 1
        btnSubmit.addTarget(self, action: #selector(btnSubmitTapped(_:)), for: .touchUpInside)
    }
    
    /**
     * Create submit button (in HD mode)
     */
    private func createSubmitBtnHD() {
        self.createSubmitBtn(
            w: SUBMIT_BUTTON_REAL_WIDTH_HD,
            h: SUBMIT_BUTTON_REAL_HEIGHT_HD)
    }
    
    /**
     * Create submit button (in Full HD mode)
     */
    private func createSubmitBtnFHD() {
        self.createSubmitBtn(
            w: SUBMIT_BUTTON_REAL_WIDTH_FHD,
            h: SUBMIT_BUTTON_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create submit button (in Full HD Landscape mode)
     */
    private func createSubmitBtnFHD_L() {
        self.createSubmitBtn(
            w: SUBMIT_BUTTON_REAL_WIDTH_FHD_L,
            h: SUBMIT_BUTTON_REAL_HEIGHT_FHD_L)
    }
    
    private func updateSubmitBtn(w: CGFloat, h: CGFloat) {
        CommonProcess.updateViewPos(
            view: btnSubmit,
            x: (employeeView.frame.width - w) / 2,
            y: txtNote.frame.maxY + GlobalConst.MARGIN,
            w: w, h: h)
    }
    
    /**
     * Update submit button (in HD mode)
     */
    private func updateSubmitBtnHD() {
        self.updateSubmitBtn(
            w: SUBMIT_BUTTON_REAL_WIDTH_HD,
            h: SUBMIT_BUTTON_REAL_HEIGHT_HD)
    }
    
    /**
     * Update submit button (in Full HD mode)
     */
    private func updateSubmitBtnFHD() {
        self.updateSubmitBtn(
            w: SUBMIT_BUTTON_REAL_WIDTH_FHD,
            h: SUBMIT_BUTTON_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update submit button (in Full HD Landscape mode)
     */
    private func updateSubmitBtnFHD_L() {
        self.updateSubmitBtn(
            w: SUBMIT_BUTTON_REAL_WIDTH_FHD_L,
            h: SUBMIT_BUTTON_REAL_HEIGHT_FHD_L)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G12F00S02VC: UITableViewDataSource {
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
        return self.listInfo.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > listInfo.count {
            return UITableViewCell()
        }
        let data = listInfo[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = data.name
        cell.textLabel?.font = GlobalConst.BASE_FONT
        //++ BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
//        cell.detailTextLabel?.text = data.getValue()
        let arrValue = data.getValue().components(separatedBy: DomainConst.LINE_FEED)
        if arrValue.count == 2 {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: data.getValue())
            let somePartStringRange = (data.getValue() as NSString).range(of: arrValue[1])
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: somePartStringRange)
            attributeString.addAttribute(
                NSForegroundColorAttributeName,
                value: GlobalConst.BUTTON_COLOR_YELLOW_NEW,
                range: (data.getValue() as NSString).range(of: arrValue[0]))
            cell.detailTextLabel?.attributedText = attributeString
        } else {
            cell.detailTextLabel?.text = data.getValue()
        }
        //-- BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
        switch data.id {
        case DomainConst.ORDER_INFO_TOTAL_MONEY_ID:
            cell.detailTextLabel?.textColor = GlobalConst.MAIN_COLOR_GAS_24H
            cell.detailTextLabel?.font = GlobalConst.BASE_BOLD_FONT
        case DomainConst.ORDER_INFO_DISCOUNT:
            cell.detailTextLabel?.textColor = GlobalConst.MAIN_COLOR_GAS_24H
            cell.detailTextLabel?.font = GlobalConst.BASE_FONT
            break
        default:
            cell.detailTextLabel?.font = GlobalConst.BASE_FONT
            //++ BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            cell.detailTextLabel?.numberOfLines = 0
            //-- BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
            break
        }
        return cell
    }
}

//extension G12F00S02VC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Do nothing
//    }
//}

// MARK: Protocol - RatingBarDelegate
extension G12F00S02VC: RatingBarDelegate {
    func rating(_ sender: AnyObject) {
        // Do nothing
    }
}

// MARK: Protocol - UITextViewDelegate
extension G12F00S02VC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == DomainConst.CONTENT00457 {
            textView.text = DomainConst.BLANK
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == DomainConst.BLANK {
            textView.text = DomainConst.CONTENT00457
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let parent = BaseViewController.getCurrentViewController() {
            self.keyboardTopY = parent.keyboardTopY
        }
        UIView.animate(withDuration: 0.3, animations: {
            textView.frame = CGRect(x: textView.frame.minX,
                                             y: 0,
                                width: textView.frame.width,
                                height: textView.frame.height)
        })
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {
            textView.frame = CGRect(x: textView.frame.minX,
                                             y: self.ratingBar.frame.maxY + GlobalConst.MARGIN,
                                width: textView.frame.width,
                                height: textView.frame.height)
        })
    }
}
