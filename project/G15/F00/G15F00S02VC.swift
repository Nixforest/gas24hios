//
//  G15F00S02VC.swift
//  project
//
//  Created by Pham Trung Nguyen on 4/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class G15F00S02VC: BaseChildViewController {
    // MARK: Properties
    /** Id */
    private var _id:        String      = DomainConst.BLANK
    /** Data */
    private var _data:      NewsPopUpRespModel = NewsPopUpRespModel()
    /** Promotion label */
    var _lblPromotion:      UILabel     = UILabel()
    /** Promotion value label */
    var _lblPromotionValue: UILabel     = UILabel()
    /** Title label */
    var _lblTitle:          UILabel     = UILabel()
    /** Date label */
    var _lblDate:           UILabel     = UILabel()
    /** Banner image */
    var _imgBanner:         UIImageView = UIImageView()
    /** Content webview */
    var _webViewContent:    UIWebView   = UIWebView()
    /** Order btn */
    var _btnOrder:          UIButton    = UIButton()
    /** Order btn */
    var _btnOrder2:         UIButton    = UIButton()
    /** Scrollview */
    var _scrollView:        UIScrollView = UIScrollView()
    
    // MARK: Constant
    var SCREEN_REAL_WIDTH_HD        = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var SCREEN_REAL_WIDTH_FHD       = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var SCREEN_REAL_WIDTH_FHD_L     = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    var PROMOTE_TEXT_REAL_WIDTH_HD  = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_HD
    var PROMOTE_TEXT_REAL_WIDTH_FHD  = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD
    var PROMOTE_TEXT_REAL_WIDTH_FHD_L  = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    var BANNER_REAL_HEIGHT_HD       = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_HD
    var BANNER_REAL_HEIGHT_FHD      = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD
    var BANNER_REAL_HEIGHT_FHD_L    = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    var BUTTON_REAL_HEIGHT_HD       = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_HD
    var BUTTON_REAL_HEIGHT_FHD      = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD
    var BUTTON_REAL_HEIGHT_FHD_L    = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00544)
        requestData()
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            createPromotionLabel(width: SCREEN_REAL_WIDTH_HD)
            createPromotionValueLabel(width: PROMOTE_TEXT_REAL_WIDTH_HD)
            createTitleLabel(width: SCREEN_REAL_WIDTH_HD)
            createDateLabel(width: SCREEN_REAL_WIDTH_HD)
            createBannerImage(height: BANNER_REAL_HEIGHT_HD)
            createOrderButton(width: SCREEN_REAL_WIDTH_HD,
                              height: BUTTON_REAL_HEIGHT_HD)
            createOrder2Button(width: SCREEN_REAL_WIDTH_HD,
                              height: BUTTON_REAL_HEIGHT_HD)
            createWebView(width: SCREEN_REAL_WIDTH_HD)
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                createPromotionLabel(width: SCREEN_REAL_WIDTH_FHD)
                createPromotionValueLabel(width: PROMOTE_TEXT_REAL_WIDTH_FHD)
                createTitleLabel(width: SCREEN_REAL_WIDTH_FHD)
                createDateLabel(width: SCREEN_REAL_WIDTH_FHD)
                createBannerImage(height: BANNER_REAL_HEIGHT_FHD)
                createOrderButton(width: SCREEN_REAL_WIDTH_FHD,
                                  height: BUTTON_REAL_HEIGHT_FHD)
                createOrder2Button(width: SCREEN_REAL_WIDTH_FHD,
                                  height: BUTTON_REAL_HEIGHT_FHD)
                createWebView(width: SCREEN_REAL_WIDTH_FHD)
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                createPromotionLabel(width: SCREEN_REAL_WIDTH_FHD_L)
                createPromotionValueLabel(width: PROMOTE_TEXT_REAL_WIDTH_FHD_L)
                createTitleLabel(width: SCREEN_REAL_WIDTH_FHD_L)
                createDateLabel(width: SCREEN_REAL_WIDTH_FHD_L)
                createBannerImage(height: BANNER_REAL_HEIGHT_FHD_L)
                createOrderButton(width: SCREEN_REAL_WIDTH_FHD_L,
                                  height: BUTTON_REAL_HEIGHT_FHD_L)
                createOrder2Button(width: SCREEN_REAL_WIDTH_FHD_L,
                                  height: BUTTON_REAL_HEIGHT_FHD_L)
                createWebView(width: SCREEN_REAL_WIDTH_FHD_L)
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        createScrollView()
        self._scrollView.addSubview(_lblPromotion)
        self._scrollView.addSubview(_lblPromotionValue)
        self._scrollView.addSubview(_lblTitle)
        self._scrollView.addSubview(_lblDate)
        self._scrollView.addSubview(_imgBanner)
        self._scrollView.addSubview(_webViewContent)
        self.view.addSubview(_scrollView)
        self.view.addSubview(_btnOrder)
        self.view.addSubview(_btnOrder2)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            updatePromotionLabel(width: SCREEN_REAL_WIDTH_HD)
            updatePromotionValueLabel(width: PROMOTE_TEXT_REAL_WIDTH_HD)
            updateTitleLabel(width: SCREEN_REAL_WIDTH_HD)
            updateDateLabel(width: SCREEN_REAL_WIDTH_HD)
            updateBannerImage(height: BANNER_REAL_HEIGHT_HD)
            updateOrderButton(width: SCREEN_REAL_WIDTH_HD,
                              height: BUTTON_REAL_HEIGHT_HD)
            updateOrder2Button(width: SCREEN_REAL_WIDTH_HD,
                              height: BUTTON_REAL_HEIGHT_HD)
            updateWebView(width: SCREEN_REAL_WIDTH_HD)
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updatePromotionLabel(width: SCREEN_REAL_WIDTH_FHD)
                updatePromotionValueLabel(width: PROMOTE_TEXT_REAL_WIDTH_FHD)
                updateTitleLabel(width: SCREEN_REAL_WIDTH_FHD)
                updateDateLabel(width: SCREEN_REAL_WIDTH_FHD)
                updateBannerImage(height: BANNER_REAL_HEIGHT_FHD)
                updateOrderButton(width: SCREEN_REAL_WIDTH_FHD,
                                  height: BUTTON_REAL_HEIGHT_FHD)
                updateOrder2Button(width: SCREEN_REAL_WIDTH_FHD,
                                  height: BUTTON_REAL_HEIGHT_FHD)
                updateWebView(width: SCREEN_REAL_WIDTH_FHD)
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updatePromotionLabel(width: SCREEN_REAL_WIDTH_FHD_L)
                updatePromotionValueLabel(width: PROMOTE_TEXT_REAL_WIDTH_FHD_L)
                updateTitleLabel(width: SCREEN_REAL_WIDTH_FHD_L)
                updateDateLabel(width: SCREEN_REAL_WIDTH_FHD_L)
                updateBannerImage(height: BANNER_REAL_HEIGHT_FHD_L)
                updateOrderButton(width: SCREEN_REAL_WIDTH_FHD_L,
                                  height: BUTTON_REAL_HEIGHT_FHD_L)
                updateWebView(width: SCREEN_REAL_WIDTH_FHD_L)
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        updateScrollView()
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = NewsPopUpRespModel(jsonString: data)
        if model.isSuccess() {
            _data = model
            let bean = model.getRecord()
            _lblPromotionValue.text = bean.code_no
            _lblTitle.text = bean.title
            _lblDate.text = "Ngày: \(bean.created_date)"
            _imgBanner.getImgFromUrl(link: bean.url_banner,
                                     contentMode: .scaleAspectFit)
            
            _webViewContent.loadHTMLString(bean.name, baseURL: nil)
            
            // Update button
            updateButton()
            updateScrollView()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Request server
    /**
     * Request data from server
     * - parameter action: Closure after finish request
     */
    private func requestData(action: Selector = #selector(setData(_:))) {
        NewsViewRequest.request(action: action,
                                view: self,
                                id: _id)
    }
    
    // MARK: Logic
    /**
     * Set data
     * - parameter id: Id of current item
     */
    public func setData(id: String) {
        self._id = id
    }
    
    /**
     * Handle when tap on order button
     */
    internal func btnOrderTapped(_ sender: AnyObject) {
        if let type = BottomMsgCellTypeEnum(rawValue: _data.getRecord().type) {
            switch type {
            case .shareCode:
                break
            case .normal, .openWeb:
//                if let url = URL(string: _data.getRecord().link_web) {
//                    UIApplication.shared.openURL(url)
//                }
                CommonProcess.openWeb(link: _data.getRecord().link_web)
                break
            case .usingCode, .openWebUsingCode:
                if let curVC = BaseViewController.getCurrentViewController() {
                    curVC.openPromotionActiveUsingCode(code: _data.getRecord().code_no)
                }
                break
            default:
                break
            }
        }
    }
    
    /**
     * Handle when tap on order button
     */
    internal func btnOrder2Tapped(_ sender: AnyObject) {
//        if let url = URL(string: _data.getRecord().link_web) {
//            UIApplication.shared.openURL(url)
//        }
        CommonProcess.openWeb(link: _data.getRecord().link_web)
    }
    
    override func openPromotionActiveUsingCode(code: String) {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
        promotionView.activeUsingCode(code: code)
        self.push(promotionView, animated: true)
    }
    
    // MARK: Layout
    // MARK: Promotion Label
    /**
     * Create promotion label
     * - parameter width: Width of label
     */
    private func createPromotionLabel(width: CGFloat) {
        _lblPromotion.frame         = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: GlobalConst.MARGIN,
            width: width,
            height: GlobalConst.LABEL_H)
        _lblPromotion.text          = DomainConst.CONTENT00250.uppercased()
        _lblPromotion.textColor     = GlobalConst.MAIN_COLOR_GAS_24H
        _lblPromotion.font          = GlobalConst.BASE_FONT
        _lblPromotion.textAlignment  = .center
    }
    
    /**
     * Update promotion label
     * - parameter width: Width of label
     */
    private func updatePromotionLabel(width: CGFloat) {
        var height = GlobalConst.LABEL_H
        if _data.getRecord().code_no.isEmpty {
            height = 0
        }
        CommonProcess.updateViewPos(
            view: _lblPromotion,
            x: (UIScreen.main.bounds.width - width) / 2,
            y: GlobalConst.MARGIN,
            w: width,
            h: height)
    }
    
    // MARK: Promotion value Label
    /**
     * Create promotion value label
     * - parameter width: Width of label
     */
    private func createPromotionValueLabel(width: CGFloat) {
        _lblPromotionValue.frame         = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: _lblPromotion.frame.maxY + GlobalConst.MARGIN,
            width: width,
            height: GlobalConst.LABEL_H * 2)
        _lblPromotionValue.text          = DomainConst.CONTENT00250.uppercased()
        _lblPromotionValue.textColor     = UIColor.white
        _lblPromotionValue.font          = GlobalConst.BASE_BOLD_FONT
        _lblPromotionValue.textAlignment  = .center
        _lblPromotionValue.backgroundColor = GlobalConst.MAIN_COLOR_GAS_24H
    }
    
    /**
     * Update promotion value label
     * - parameter width: Width of label
     */
    private func updatePromotionValueLabel(width: CGFloat) {
        var height = GlobalConst.LABEL_H * 2
        if _data.getRecord().code_no.isEmpty {
            height = 0
        }
        CommonProcess.updateViewPos(
            view: _lblPromotionValue,
            x: (UIScreen.main.bounds.width - width) / 2,
            y: _lblPromotion.frame.maxY + GlobalConst.MARGIN,
            w: width,
            h: height)
    }
    
    // MARK: Title Label
    /**
     * Create title label
     * - parameter width: Width of label
     */
    private func createTitleLabel(width: CGFloat) {
        _lblTitle.frame         = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: _lblPromotionValue.frame.maxY + GlobalConst.MARGIN,
            width: width,
            height: GlobalConst.LABEL_H * 2)
        _lblTitle.text          = DomainConst.CONTENT00062
        _lblTitle.textColor     = UIColor.black
        _lblTitle.font          = GlobalConst.BASE_BOLD_FONT
        _lblTitle.textAlignment = .left
        _lblTitle.lineBreakMode = .byWordWrapping
        _lblTitle.numberOfLines = 0
    }
    
    /**
     * Update title label
     * - parameter width: Width of label
     */
    private func updateTitleLabel(width: CGFloat) {
        CommonProcess.updateViewPos(
            view: _lblTitle,
            x: (UIScreen.main.bounds.width - width) / 2,
            y: _lblPromotionValue.frame.maxY + GlobalConst.MARGIN,
            w: width,
            h: GlobalConst.LABEL_H * 2)
    }
    
    // MARK: Date Label
    /**
     * Create date label
     * - parameter width: Width of label
     */
    private func createDateLabel(width: CGFloat) {
        _lblDate.frame         = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: _lblTitle.frame.maxY + GlobalConst.MARGIN,
            width: width,
            height: GlobalConst.LABEL_H)
        _lblDate.text          = "Ngày: \(CommonProcess.getCurrentDate(withSpliter: DomainConst.SPLITER_TYPE3))"
        _lblDate.textColor     = UIColor.black
        _lblDate.font          = GlobalConst.BASE_ITALIC_FONT
        _lblDate.textAlignment = .left
    }
    
    /**
     * Update date label
     * - parameter width: Width of label
     */
    private func updateDateLabel(width: CGFloat) {
        CommonProcess.updateViewPos(
            view: _lblDate,
            x: (UIScreen.main.bounds.width - width) / 2,
            y: _lblTitle.frame.maxY + GlobalConst.MARGIN,
            w: width,
            h: GlobalConst.LABEL_H)
    }
    
    // MARK: Banner image
    /**
     * Create banner image
     * - parameter height: Height of banner
     */
    private func createBannerImage(height: CGFloat) {
        _imgBanner.image = ImageManager.getImage(named: DomainConst.DEFAULT_IMG_NAME)
        _imgBanner.backgroundColor = UIColor.clear
        _imgBanner.isOpaque = false
        CommonProcess.updateViewPos(
            view: _imgBanner,
            x: GlobalConst.MARGIN,
            y: _lblDate.frame.maxY + GlobalConst.MARGIN,
            w: UIScreen.main.bounds.width - 2 * GlobalConst.MARGIN,
            h: height * 2)
        _imgBanner.contentMode = .scaleAspectFit
    }
    
    /**
     * Update banner image
     * - parameter height: Height of banner
     */
    private func updateBannerImage(height: CGFloat) {
        CommonProcess.updateViewPos(
            view: _imgBanner,
            x: GlobalConst.MARGIN,
            y: _lblDate.frame.maxY + GlobalConst.MARGIN,
            w: UIScreen.main.bounds.width - 2 * GlobalConst.MARGIN,
            h: height * 2)
    }
    
    // MARK: Web view
    /**
     * Create web view
     * - parameter width: Width of button
     */
    private func createWebView(width: CGFloat) {
        let yPos = _imgBanner.frame.maxY
        _webViewContent.backgroundColor = UIColor.clear
        _webViewContent.isOpaque = false
        _webViewContent.frame = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: yPos,
            width: width,
            height: UIScreen.main.bounds.height - yPos - _btnOrder.frame.height)
        _webViewContent.delegate = self
        _webViewContent.scrollView.isScrollEnabled = false
    }
    
    /**
     * Update web view
     * - parameter width: Width of button
     */
    private func updateWebView(width: CGFloat) {
        let yPos = _imgBanner.frame.maxY
        CommonProcess.updateViewPos(
            view: _webViewContent,
            x: (UIScreen.main.bounds.width - width) / 2, y: yPos,
            w: width,
            h: UIScreen.main.bounds.height - yPos - _btnOrder.frame.height)
    }
    
    // MARK: Order button
    /**
     * Create order button
     * - parameter width: Width of button
     * - parameter height: Height of button
     */
    private func createOrderButton(width: CGFloat, height: CGFloat) {
        _btnOrder.frame = CGRect(
            x: (UIScreen.main.bounds.width - width) / 2,
            y: UIScreen.main.bounds.height - height,
            width: width, height: height)
        _btnOrder.setTitle(DomainConst.CONTENT00543, for: UIControlState())
        _btnOrder.setTitleColor(GlobalConst.URL_BUTTON_COLOR, for: UIControlState())
        _btnOrder.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        _btnOrder.titleLabel?.textAlignment = .left
        _btnOrder.backgroundColor = UIColor.white
        _btnOrder.layer.borderColor = GlobalConst.BORDER_BUTTON_COLOR.cgColor
        _btnOrder.layer.borderWidth = 1
        _btnOrder.addTarget(self, action: #selector(btnOrderTapped(_:)),
                            for: .touchUpInside)
    }
    
    /**
     * Update order button
     * - parameter width: Width of button
     * - parameter height: Height of button
     */
    private func updateOrderButton(width: CGFloat, height: CGFloat) {
//        if _data.getRecord().type == BottomMsgCellTypeEnum.openWebUsingCode.rawValue {
//            CommonProcess.updateViewPos(
//                view: _btnOrder,
//                x: (UIScreen.main.bounds.width - width) / 2,
//                y: UIScreen.main.bounds.height - height,
//                w: width / 2, h: height)
//        } else {
//            CommonProcess.updateViewPos(
//                view: _btnOrder,
//                x: (UIScreen.main.bounds.width - width) / 2,
//                y: UIScreen.main.bounds.height - height,
//                w: width, h: height)
//        }
        if !self._btnOrder.isHidden && !self._btnOrder2.isHidden {
            CommonProcess.updateViewPos(
                view: _btnOrder,
                x: (UIScreen.main.bounds.width - width) / 2,
                y: UIScreen.main.bounds.height - height,
                w: width / 2, h: height)
        } else if (!self._btnOrder.isHidden && self._btnOrder2.isHidden) {
            CommonProcess.updateViewPos(
                view: _btnOrder,
                x: (UIScreen.main.bounds.width - width) / 2,
                y: UIScreen.main.bounds.height - height,
                w: width, h: height)
        }
    }
    
    /**
     * Create order2 button
     * - parameter width: Width of button
     * - parameter height: Height of button
     */
    private func createOrder2Button(width: CGFloat, height: CGFloat) { 
        _btnOrder2.frame = CGRect(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height - height,
            width: width / 2, height: height)
        _btnOrder2.setTitle(DomainConst.CONTENT00543, for: UIControlState())
        _btnOrder2.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        _btnOrder2.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        _btnOrder2.titleLabel?.textAlignment = .left
        _btnOrder2.backgroundColor = UIColor.white
        _btnOrder2.layer.borderColor = GlobalConst.BORDER_BUTTON_COLOR.cgColor
        _btnOrder2.layer.borderWidth = 1
        _btnOrder2.addTarget(self, action: #selector(btnOrder2Tapped(_:)),
                            for: .touchUpInside)
    }
    
    /**
     * Update order2 button
     * - parameter width: Width of button
     * - parameter height: Height of button
     */
    private func updateOrder2Button(width: CGFloat, height: CGFloat) {
//        CommonProcess.updateViewPos(
//            view: _btnOrder2,
//            x: UIScreen.main.bounds.width / 2,
//            y: UIScreen.main.bounds.height - height,
//            w: width / 2, h: height)
        if !self._btnOrder.isHidden && !self._btnOrder2.isHidden {
                CommonProcess.updateViewPos(
                    view: _btnOrder2,
                    x: (UIScreen.main.bounds.width - width) / 2,
                    y: UIScreen.main.bounds.height - height,
                    w: width / 2, h: height)
            } else if (self._btnOrder.isHidden && !self._btnOrder2.isHidden) {
                CommonProcess.updateViewPos(
                    view: _btnOrder2,
                    x: (UIScreen.main.bounds.width - width) / 2,
                    y: UIScreen.main.bounds.height - height,
                    w: width, h: height)
        }
    }
    
    /**
     * Handle update buttons.
     */
    private func updateButton() {
        // Button 1
        _btnOrder.setTitle(_data.getRecord().code_no_text, for: UIControlState())
        _btnOrder.setTitleColor(GlobalConst.URL_BUTTON_COLOR, for: UIControlState())
        // Button 2
        _btnOrder2.setTitle(_data.getRecord().link_web_text, for: UIControlState())
        _btnOrder2.setTitleColor(GlobalConst.URL_BUTTON_COLOR, for: UIControlState())
        if let type = BottomMsgCellTypeEnum(rawValue: _data.getRecord().type) {
            switch type {
            case .shareCode:
                self._btnOrder2.isHidden       = true
                break
            case .normal:
                self._btnOrder2.isHidden       = true
                _btnOrder.setTitle(_data.getRecord().link_web_text, for: UIControlState())
                break
            case .usingCode:
                self._btnOrder2.isHidden       = true
                _btnOrder.setTitle(_data.getRecord().code_no_text, for: UIControlState())
                break
            case .openWeb:
                self._btnOrder2.isHidden       = true
                _btnOrder.setTitle(_data.getRecord().link_web_text, for: UIControlState())
                break
            case .openWebUsingCode:
                self._btnOrder2.isHidden       = false
                break
            default:
                break
            }
        }
        self._btnOrder.isHidden = self._data.getRecord().code_no.isEmpty
        self._btnOrder2.isHidden = self._data.getRecord().link_web.isEmpty
        updateChildrenViews()
    }
    
    // MARK: Scrollview
    private func createScrollView() {
        _scrollView.frame = CGRect(
            x: 0, y: getTopHeight(),
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - _btnOrder.frame.height - getTopHeight())
        _scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: _webViewContent.frame.maxY - _lblPromotion.frame.minY + GlobalConst.MARGIN)
    }
    
    internal func updateScrollView() {
        _scrollView.frame = CGRect(
            x: 0, y: getTopHeight(),
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - _btnOrder.frame.height - getTopHeight())
        _scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: _webViewContent.frame.maxY - _lblPromotion.frame.minY + GlobalConst.MARGIN)
    }
}

// MARK: UIWebViewDelegate
extension G15F00S02VC: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        updateScrollView()
    }
}
