//
//  G04F01S05VC.swift
//  project
//
//  Created by SPJ on 1/26/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
//class G04F01S05VC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
class G04F01S05VC: ChildViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
    /** Scroll view */
    @IBOutlet weak var _scrollView: UIScrollView!
    /** Material table view */
    @IBOutlet weak var _tblViewMaterial: UITableView!
    /** Information table view */
    @IBOutlet weak var _tblViewInfo: UITableView!
    /** List of material data */
    private var _listMaterial:  [OrderDetailBean]    = [OrderDetailBean]()
    /** List of information data */
    private var _listInfo:      [ConfigurationModel] = [ConfigurationModel]()
    /** Label phone */
    private var _lblPhone: UILabel          = UILabel()
    /** Label Address */
    private var _lblAddress: UILabel        = UILabel()
    /** Textfield phone */
    private var _txtPhone: UITextField      = UITextField()
    /** Textfield address */
    private var _txtAddress: UITextField    = UITextField()
    /** Current text field */
    private var _currentTextField: UITextField? = nil
    /** Button confirm */
    private var _btnConfirm: UIButton       = UIButton()
    /** Button cancel */
    private var _btnCancel: UIButton        = UIButton()
    /** Current transaction data */
    private var _transactionCompleteBean    = TransactionCompleteBean()
    
    // MARK: Methods
    /**
     * Get total money from the other value
     * - returns: Total money
     */
    func getTotalMoney() -> String {
        let fmt         = NumberFormatter()
        fmt.numberStyle = .decimal
        let promotion   = fmt.number(from: DomainConst.PROMOTION_DEFAULT)?.doubleValue
        let discount    = fmt.number(from: DomainConst.DISCOUNT_DEFAULT)?.doubleValue
        let gas         = fmt.number(from: MapViewController._gasSelected.material_price)?.doubleValue
        let total       = (gas! - (promotion! + discount!))
        return String(fmt.string(from: total as NSNumber) ?? DomainConst.BLANK)
    }
    
    /**
     * Update total money form the other value
     * - returns: Total money
     */
    func updateTotalMoney() -> String {
        let fmt         = NumberFormatter()
        fmt.numberStyle = .decimal
        let promotion   = fmt.number(from: self._transactionCompleteBean.promotion_amount)?.doubleValue
        let discount    = fmt.number(from: self._transactionCompleteBean.discount_amount)?.doubleValue
        var gas = 0.0
        for detail in self._transactionCompleteBean.order_detail {
            gas = gas + (fmt.number(from: detail.material_price)?.doubleValue)! * (detail.qty as NSString).doubleValue
        }
        let total       = (gas - (promotion! + discount!))
        return String(fmt.string(from: total as NSNumber) ?? DomainConst.BLANK)
    }
    
    /**
     * Setup list material data
     */
    func setupListMaterial() {
        self._listMaterial.removeAll()
        if !MapViewController._gasSelected.material_id.isEmpty {
            let detailGas = OrderDetailBean(data: MapViewController._gasSelected)
            detailGas.qty = "1"
            self._listMaterial.append(detailGas)
        }
        //if !MapViewController._promoteSelected.material_id.isEmpty {
            let detailPromote = OrderDetailBean(data: MapViewController._promoteSelected)
            detailPromote.qty = "1"
            self._listMaterial.append(detailPromote)
        //}
    }
    
    /**
     * Update data of list materials
     */
    func updateListMaterial() {
        self._listMaterial.removeAll()
        self._listMaterial.append(contentsOf: self._transactionCompleteBean.order_detail)
        if self._listMaterial.count == 1 {
//            self._listMaterial[1].material_id.isEmpty {
//            self._listMaterial[1].material_name = DomainConst.CONTENT00244
            let detailPromote = OrderDetailBean(data: MapViewController._promoteSelected)
            detailPromote.qty = DomainConst.NUMBER_ONE_VALUE
            detailPromote.material_name = DomainConst.CONTENT00244
            self._listMaterial.append(detailPromote)
        }
    }
    
    /**
     * Setup list information data
     */
    func setupListInfo() {
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_PROMOTION_ID,
                                            name: DomainConst.CONTENT00219,
                                            iconPath: DomainConst.DEFAULT_MATERIAL_IMG_NAME,
                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                            //value: DomainConst.PROMOTION_DEFAULT + DomainConst.VIETNAMDONG))
                                            value: "-" + DomainConst.PROMOTION_DEFAULT))
                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_DISCOUNT_ID,
                                            name: DomainConst.CONTENT00239,
                                            iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                            //value: DomainConst.DISCOUNT_DEFAULT + DomainConst.VIETNAMDONG))
                                            value: "-" + DomainConst.DISCOUNT_DEFAULT))
                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_TOTAL_MONEY_ID,
                                            name: DomainConst.CONTENT00218,
                                            iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                            //value: getTotalMoney() + DomainConst.VIETNAMDONG))
                                            value: getTotalMoney()))
                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_NAME_ID,
                                            name: DomainConst.CONTENT00240,
                                            iconPath: DomainConst.AGENT_ICON_IMG_NAME,
                                            value: MapViewController._nearestAgent.info_agent.agent_name))
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_PHONE_ID,
                                            name: DomainConst.CONTENT00241,
                                            iconPath: DomainConst.PHONE_ICON_IMG_NAME,
                                            value: MapViewController._nearestAgent.info_agent.agent_phone))
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_SUPPORT_ID,
                                            name: DomainConst.CONTENT00242,
                                            iconPath: DomainConst.SUPPORT_ICON_IMG_NAME,
                                            value: MapViewController._nearestAgent.info_agent.agent_phone_support))
    }
    
    /**
     * Update data of list information
     */
    func updateListInfo() {
        self._listInfo.removeAll()
        //++ BUG0042-SPJ (NguyenPT 20170223) Hide Promotion and discount with "0" value
//        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_PROMOTION_ID,
//                                            name: DomainConst.CONTENT00219,
//                                            iconPath: DomainConst.DEFAULT_MATERIAL_IMG_NAME,
//                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
//                                            //value: self._transactionCompleteBean.promotion_amount + DomainConst.VIETNAMDONG))
//                                            value: self._transactionCompleteBean.promotion_amount))
//                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
//        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_DISCOUNT_ID,
//                                            name: DomainConst.CONTENT00239,
//                                            iconPath: DomainConst.MONEY_ICON_IMG_NAME,
//                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
//                                            //value: self._transactionCompleteBean.discount_amount + DomainConst.VIETNAMDONG))
//                                            value: self._transactionCompleteBean.discount_amount))
//                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        if self._transactionCompleteBean.promotion_amount != DomainConst.NUMBER_ZERO_VALUE {
            _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_PROMOTION_ID,
                                                name: DomainConst.CONTENT00219,
                                                iconPath: DomainConst.DEFAULT_MATERIAL_IMG_NAME,
                                                value: "-" + self._transactionCompleteBean.promotion_amount))
        }
        if self._transactionCompleteBean.discount_amount != DomainConst.NUMBER_ZERO_VALUE {
            _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_DISCOUNT_ID,
                                                name: DomainConst.CONTENT00239,
                                                iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                                value: "-" + self._transactionCompleteBean.discount_amount))
        }
        //-- BUG0042-SPJ (NguyenPT 20170223) Hide Promotion and discount with "0" value
        
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_TOTAL_MONEY_ID,
                                            name: DomainConst.CONTENT00218,
                                            iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                            //value: self._transactionCompleteBean.grand_total + DomainConst.VIETNAMDONG))
                                            value: self._transactionCompleteBean.grand_total))
                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_NAME_ID,
                                            name: DomainConst.CONTENT00240,
                                            iconPath: DomainConst.AGENT_ICON_IMG_NAME,
                                            value: self._transactionCompleteBean.agent_name))
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_PHONE_ID,
                                            name: DomainConst.CONTENT00241,
                                            iconPath: DomainConst.PHONE_ICON_IMG_NAME,
                                            value: MapViewController._nearestAgent.info_agent.agent_phone))
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_SUPPORT_ID,
                                            name: DomainConst.CONTENT00242,
                                            iconPath: DomainConst.SUPPORT_ICON_IMG_NAME,
                                            value: MapViewController._nearestAgent.info_agent.agent_phone_support))
        updateLayout()
    }
    
    func updateLayout() {
        var offset = self._tblViewMaterial.frame.maxY
        
        // Information table view
        self._tblViewInfo.frame = CGRect(x: 0,
                                         y: offset,
                                         width: GlobalConst.SCREEN_WIDTH,
                                         height: CGFloat(_listInfo.count) * GlobalConst.CONFIGURATION_ITEM_HEIGHT)
        offset = offset + self._tblViewInfo.frame.height + GlobalConst.MARGIN
        // Label phone
        self._lblPhone.frame = CGRect(x: 0, y: offset,
                                      width: GlobalConst.SCREEN_WIDTH,
                                      height: GlobalConst.LABEL_H)
        offset = offset + self._lblPhone.frame.height
        // Textfield Phone
        self._txtPhone.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                      y: offset,
                                      width: GlobalConst.BUTTON_W,
                                      height: GlobalConst.BUTTON_H)
        offset = offset + self._txtPhone.frame.height
        // Label Address
        self._lblAddress.frame = CGRect(x: 0, y: offset,
                                        width: GlobalConst.SCREEN_WIDTH,
                                        height: GlobalConst.LABEL_H)
        offset = offset + self._lblAddress.frame.height
        // Textfield Address
        self._txtAddress.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                        y: offset,
                                        width: GlobalConst.BUTTON_W,
                                        height: GlobalConst.BUTTON_H)
        offset = offset + self._txtAddress.frame.height + GlobalConst.MARGIN
        // Confirm button
        self._btnConfirm.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                        y: offset,
                                        width: GlobalConst.BUTTON_W / 2,
                                        height: GlobalConst.BUTTON_H)
        // Button Cancel
        self._btnCancel.frame = CGRect(x: GlobalConst.SCREEN_WIDTH / 2,
                                       y: offset,
                                       width: GlobalConst.BUTTON_W / 2,
                                       height: GlobalConst.BUTTON_H)
        offset = offset + self._btnCancel.frame.height + GlobalConst.MARGIN
        self._scrollView.contentSize = CGSize(width: GlobalConst.SCREEN_WIDTH,
                                              height: offset + getTopHeight())
    }

    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00217, isNotifyEnable: true)
        createNavigationBar(title: DomainConst.CONTENT00217)
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        setupListMaterial()
        setupListInfo()
        var offset: CGFloat = -getTopHeight()
        // Material table view
        self._tblViewMaterial.translatesAutoresizingMaskIntoConstraints = true
        self._tblViewMaterial.frame = CGRect(x: 0,
                                             y: offset,
                                             width: GlobalConst.SCREEN_WIDTH,
                                             height: GlobalConst.CELL_HEIGHT_SHOW * CGFloat(self._listMaterial.count) * 2/3)
        offset = offset + self._tblViewMaterial.frame.height
        
        // Information table view
        self._tblViewInfo.translatesAutoresizingMaskIntoConstraints = true
        self._tblViewInfo.frame = CGRect(x: 0,
                                         y: offset,
                                         width: GlobalConst.SCREEN_WIDTH,
                                         height: CGFloat(_listInfo.count) * GlobalConst.CONFIGURATION_ITEM_HEIGHT)
        offset = offset + self._tblViewInfo.frame.height + GlobalConst.MARGIN
        
        // Label phone
        self._lblPhone.frame = CGRect(x: 0, y: offset,
                                      width: GlobalConst.SCREEN_WIDTH,
                                      height: GlobalConst.LABEL_H)
        self._lblPhone.text = DomainConst.CONTENT00170
        self._lblPhone.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        self._lblPhone.textAlignment = .center
        offset = offset + self._lblPhone.frame.height
        
        // Textfield Phone
        self._txtPhone.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                      y: offset,
                                      width: GlobalConst.BUTTON_W,
                                      height: GlobalConst.BUTTON_H)
        self._txtPhone.font = UIFont.boldSystemFont(ofSize: GlobalConst.LARGE_FONT_SIZE)
        self._txtPhone.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        self._txtPhone.text = "0123456789"
        self._txtPhone.textAlignment = .center
        self._txtPhone.layer.borderWidth = 1
        self._txtPhone.layer.borderColor = GlobalConst.MAIN_COLOR.cgColor
        self._txtPhone.textColor = GlobalConst.MAIN_COLOR
        self._txtPhone.returnKeyType = .done
        self._txtPhone.keyboardType = .numberPad
        //self._txtPhone.isUserInteractionEnabled = false
        offset = offset + self._txtPhone.frame.height
        
        // Label Address
        self._lblAddress.frame = CGRect(x: 0, y: offset,
                                      width: GlobalConst.SCREEN_WIDTH,
                                      height: GlobalConst.LABEL_H)
        self._lblAddress.text = DomainConst.CONTENT00243
        self._lblAddress.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        self._lblAddress.textAlignment = .center
        offset = offset + self._lblAddress.frame.height
        
        // Textfield Address
        self._txtAddress.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                      y: offset,
                                      width: GlobalConst.BUTTON_W,
                                      height: GlobalConst.BUTTON_H)
        self._txtAddress.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self._txtAddress.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        self._txtAddress.text = MapViewController._currentAddress
        self._txtAddress.textAlignment = .center
        self._txtAddress.layer.borderWidth = 1
        self._txtAddress.layer.borderColor = GlobalConst.MAIN_COLOR.cgColor
        self._txtAddress.returnKeyType = .done
        //self._txtAddress.isUserInteractionEnabled = false
        offset = offset + self._txtAddress.frame.height + GlobalConst.MARGIN
        
        // Button Confirm
        //++ BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
//        self._btnConfirm.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
//                                        y: offset,
//                                        width: GlobalConst.BUTTON_W / 2,
//                                        height: GlobalConst.BUTTON_H)
//        self._btnConfirm.backgroundColor = GlobalConst.BUTTON_COLOR_RED
//        self._btnConfirm.setTitle(DomainConst.CONTENT00217.uppercased(), for: UIControlState())
//        self._btnConfirm.setTitleColor(UIColor.white, for: UIControlState())
//        self._btnConfirm.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        self._btnConfirm.addTarget(self, action: #selector(btnConfirmTapped), for: .touchUpInside)
//        self._btnConfirm.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
//        self._btnConfirm.setImage(ImageManager.getImage(named: DomainConst.CONFIRM_IMG_NAME), for: UIControlState())
//        self._btnConfirm.imageView?.contentMode = .scaleAspectFit
        setupButton(button: self._btnConfirm,
                    x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                    y: offset, title: DomainConst.CONTENT00217,
                    icon: DomainConst.CONFIRM_IMG_NAME,
                    color: GlobalConst.BUTTON_COLOR_RED,
                    action: #selector(btnConfirmTapped(_:)))
        //-- BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
        
        // Button Cancel
        //++ BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
//        self._btnCancel.frame = CGRect(x: GlobalConst.SCREEN_WIDTH / 2,
//                                        y: offset,
//                                        width: GlobalConst.BUTTON_W / 2,
//                                        height: GlobalConst.BUTTON_H)
//        self._btnCancel.backgroundColor = GlobalConst.BUTTON_COLOR_YELLOW
//        self._btnCancel.setTitle(DomainConst.CONTENT00220.uppercased(), for: UIControlState())
//        self._btnCancel.setTitleColor(UIColor.white, for: UIControlState())
//        self._btnCancel.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        self._btnCancel.addTarget(self, action: #selector(btnCancelTapped(_:)), for: .touchUpInside)
//        self._btnCancel.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
//        self._btnCancel.setImage(ImageManager.getImage(named: DomainConst.CANCEL_IMG_NAME), for: UIControlState())
//        self._btnCancel.imageView?.contentMode = .scaleAspectFit
        setupButton(button: self._btnCancel,
                    x: GlobalConst.SCREEN_WIDTH / 2,
                    y: offset, title: DomainConst.CONTENT00220,
                    icon: DomainConst.CANCEL_IMG_NAME,
                    color: GlobalConst.BUTTON_COLOR_YELLOW,
                    action: #selector(btnCancelTapped(_:)))
        //-- BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
        offset = offset + self._btnCancel.frame.height + GlobalConst.MARGIN

        
        // Add to view
        self._scrollView.addSubview(self._lblPhone)
        self._scrollView.addSubview(self._txtPhone)
        self._scrollView.addSubview(self._lblAddress)
        self._scrollView.addSubview(self._txtAddress)
        self._scrollView.addSubview(self._btnConfirm)
        self._scrollView.addSubview(self._btnCancel)
        
        self._scrollView.translatesAutoresizingMaskIntoConstraints = true
        self._scrollView.frame = CGRect(x: 0, y: getTopHeight(),
                                        width: GlobalConst.SCREEN_WIDTH,
                                        height: GlobalConst.SCREEN_HEIGHT)
        self._scrollView.contentSize = CGSize(width: GlobalConst.SCREEN_WIDTH,
                                              height: offset + getTopHeight())
        self._txtPhone.delegate = self
        self._txtAddress.delegate = self
    }
    
    //++ BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
    /**
     * Setup button for this view
     * - parameter button:  Button to setup
     * - parameter x:       X position of button
     * - parameter y:       Y position of button
     * - parameter title:   Title of button
     * - parameter icon:    Icon of button
     * - parameter color:   Color of button
     * - parameter action:  Action of button
     */
    private func setupButton(button: UIButton, x: CGFloat, y: CGFloat, title: String,
                             icon: String, color: UIColor, action: Selector) {
        button.frame = CGRect(x: x,
                              y: y,
                              width: GlobalConst.BUTTON_W / 2,
                              height: GlobalConst.BUTTON_H)
        button.setTitle(title.uppercased(), for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor          = color
        button.titleLabel?.font         = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        button.layer.cornerRadius       = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        button.imageView?.contentMode   = .scaleAspectFit
        button.setImage(ImageManager.getImage(named: icon), for: UIControlState())
        button.addTarget(self, action: action, for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: GlobalConst.MARGIN,
                                              left: GlobalConst.MARGIN,
                                              bottom: GlobalConst.MARGIN,
                                              right: GlobalConst.MARGIN)
    }
    //-- BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
    
    /**
     * Handler when transaction complete request is finish
     */
    func finishRequestTransactionCompleteHandler(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        _transactionCompleteBean = (notification.object as! TransactionCompleteBean)
//        updateListMaterial()
//        updateListInfo()
//        self._tblViewMaterial.reloadData()
//        self._tblViewInfo.reloadData()
        let data = (notification.object as! String)
        let model = OrderTransactionCompleteRespModel(jsonString: data)
        if model.isSuccess() {
            _transactionCompleteBean = model.getRecord()
            updateListMaterial()
            updateListInfo()
            self._tblViewMaterial.reloadData()
            self._tblViewInfo.reloadData()
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    }
    
    /**
     * Set data notification
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = UserProfileRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setUserInfo(userInfo: model.record)
            setData()
        }
//        setData()
    }
    
    /**
     * Set data for	phone and request transaction complete
     */
    func setData() {
        _txtPhone.text = BaseModel.shared.user_info?.getPhone()
        requestTransactionComplete()
    }
    
    /**
     * Request transaction complete
     */
    func requestTransactionComplete() {
        var orderDetail = DomainConst.BLANK
        for item in self._listMaterial {
            if !item.material_id.isEmpty {
                orderDetail = orderDetail + item.createJsonData()
            }            
        }
        orderDetail = String(orderDetail.characters.dropLast())
        OrderTransactionCompleteRequest.requestOrderTransactionComplete(
            action:      #selector(finishRequestTransactionCompleteHandler(_:)),
            view:        self,
            key:         BaseModel.shared.getTransactionData().name,
            id:          BaseModel.shared.getTransactionData().id,
            devicePhone: DomainConst.BLANK,
            firstName:   (BaseModel.shared.user_info?.getName())!,
            phone:       (BaseModel.shared.user_info?.getPhone())!,
            email:       (BaseModel.shared.user_info?.getEmail())!,
            provinceId:  (BaseModel.shared.user_info?.getProvinceId())!,
            districtId:  (BaseModel.shared.user_info?.getDistrictId())!,
            wardId:      (BaseModel.shared.user_info?.getWardId())!,
            streetId:    (BaseModel.shared.user_info?.getStreetId())!,
            houseNum:    (BaseModel.shared.user_info?.getHouseNumber())!,
            note:        DomainConst.BLANK,
            address:     MapViewController._currentAddress,
            orderDetail: orderDetail,
            lat:         String(MapViewController._currentPos.latitude),
            long:        String(MapViewController._currentPos.longitude),
            agentId:     MapViewController._nearestAgent.info_agent.agent_id,
            transactionType: DomainConst.TRANSACTION_TYPE_NORMAL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Handle when tap cancel button
     */
    func btnCancelTapped(_ sender: AnyObject) {
        self.showAlert(message: DomainConst.CONTENT00256,
                       okHandler: {
                        (alert: UIAlertAction!) in
                        OrderTransactionCancelRequest.requestOrderTransactionCancel(
                            //++ BUG0045-SPJ (NguyenPT 20170301) Bug when tap on Confirm button
                            //action: #selector(self.finishRequestTransactionConfirmHandler(_:)),
                            action: #selector(self.finishRequestTransactionCancelHandler(_:)),
                            //-- BUG0045-SPJ (NguyenPT 20170301) Bug when tap on Confirm button
                            view: self)
        },
                       cancelHandler: {
                        (alert: UIAlertAction!) in
        })
    }
    
    //++ BUG0045-SPJ (NguyenPT 20170301) Bug when tap on Confirm button
    /**
     * Override method
     */
    override func backButtonTapped(_ sender: AnyObject) {
        // Handle cancel order
        self.btnCancelTapped(sender)
    }
    
    /**
     * Handle when finish request transaction confirm/cancel
     */
    func finishRequestTransactionCancelHandler(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
            showAlert(message: model.message, okHandler: {
                alert in
                super.backButtonTapped(self)
            })
        } else {
            showAlert(message: model.message)
        }
//        // Call super method
//        super.backButtonTapped(self)
    }
    //-- BUG0045-SPJ (NguyenPT 20170301) Bug when tap on Confirm button
    
    /**
     * Handle when tap confirm button
     */
    func btnConfirmTapped(_ sender: AnyObject) {
        OrderTransactionConfirmRequest.requestOrderTransactionConfirm(
            action: #selector(finishRequestTransactionConfirmHandler(_:)), view: self,
            address: self._txtAddress.text!,
            phone: self._txtPhone.text!)
    }
    
    /**
     * Handle when finish request transaction confirm/cancel
     */
    func finishRequestTransactionConfirmHandler(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderTransactionConfirmRespModel(jsonString: data)
        if !model.isSuccess() {
            showAlert(message: model.message)
            return
        }
        BaseModel.shared.setTransactionData(transaction: TransactionBean.init())
        //++ BUG0045-SPJ (NguyenPT 20170301) Bug when tap on Confirm button
//        // Back to previous view
//        self.backButtonTapped(self)
        // Call super method
        super.backButtonTapped(self)
        //-- BUG0045-SPJ (NguyenPT 20170301) Bug when tap on Confirm button
        //++ BUG0040-SPJ (NguyenPT 20170222) Move to order detail
//        G04F00S02VC._id = (notification.object as! OrderTransactionConfirmRespModel).getRecord()
        G04F00S02VC._id = model.getRecord()
        self.pushToView(name: G04Const.G04_F00_S02_VIEW_CTRL)
        //-- BUG0040-SPJ (NguyenPT 20170222) Move to order detail
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
     * Set height of row in table view
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == _tblViewMaterial {
            return GlobalConst.CELL_HEIGHT_SHOW * 2/3
        } else if tableView == _tblViewInfo {
            
        }
        return UITableViewAutomaticDimension
    }
    
    /**
     * Set number of row in table view
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == _tblViewMaterial {
            return self._listMaterial.count
        } else if tableView == _tblViewInfo {
            return _listInfo.count
        }
        return 0
    }
    
    /**
     * Set content of row in table view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retCell = UITableViewCell()
        if tableView == _tblViewMaterial {
            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.MATERIAL_TABLE_VIEW_CELL,
                                                     for: indexPath) as! MaterialTableViewCell
            cell.setData(data: self._listMaterial[indexPath.row])
            retCell = cell
        } else if tableView == _tblViewInfo {
            ConfigurationTableViewCell.PARENT_WIDTH = GlobalConst.SCREEN_WIDTH
            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL,
                                                     for: indexPath) as! ConfigurationTableViewCell
                
            cell.setData(data: _listInfo[indexPath.row])
            if _listInfo[indexPath.row].id == DomainConst.AGENT_TOTAL_MONEY_ID {
                cell.highlightValue()
            }
            
            retCell = cell
        }
        return retCell
    }
    
    /**
     * Handle when select row in table view
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == _tblViewMaterial {
            if self._listMaterial[indexPath.row].isGas() {
                G04F01S02VC.setData(data: MapViewController._nearestAgent.info_gas)
                self.pushToView(name: G04Const.G04_F01_S02_VIEW_CTRL)
            } else {
                G04F01S03VC.setData(data: MapViewController._nearestAgent.info_promotion)
                self.pushToView(name: G04Const.G04_F01_S03_VIEW_CTRL)
            }
        } else if tableView == _tblViewInfo {
            if _listInfo[indexPath.row].id == DomainConst.AGENT_PHONE_ID ||
                _listInfo[indexPath.row].id == DomainConst.AGENT_SUPPORT_ID {
                self.makeACall(phone: _listInfo[indexPath.row].getValue().normalizatePhoneString())
//                if let url = NSURL(string: "tel://\(_listInfo[indexPath.row].getValue().normalizatePhoneString())"), UIApplication.shared.canOpenURL(url as URL) {
//                    UIApplication.shared.openURL(url as URL)
//                }
            }
        }
    }
    
    /**
     * View did appear
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupListMaterial()
        // Load data from server
        if BaseModel.shared.user_info == nil {
            // User information does not exist
            //++ BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
            //RequestAPI.requestUserProfile(action: #selector(setData(_:)), view: self)
            UserProfileRequest.requestUserProfile(action: #selector(setData(_:)), view: self)
            //-- BUG0046-SPJ (NguyenPT 20170302) Use action for Request server completion
        } else {
            setData()
        }
        //self._tblViewMaterial.reloadData()
    }
    
    
    /**
     * Hide keyboard
     * - parameter sender: Gesture
     */
    func hideKeyboard(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
        isKeyboardShow = false
    }
    
    /**
     * Handle when focus edittext
     * - parameter textField: Textfield will be focusing
     */
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if isKeyboardShow == false {
//            isKeyboardShow = true
//        }
        isKeyboardShow = true
        // Making A toolbar
        if textField == self._txtPhone {
            addDoneButtonOnKeyboard()
        }
        return true
    }
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        isKeyboardShow = false
        return true
    }
    /**
     * Add a done button when numpad keyboard show
     */
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(hideKeyboard(_:)))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self._txtPhone.inputAccessoryView = doneToolbar
        self.keyboardTopY -= doneToolbar.frame.height
    }
    
    /**
     * Handle when focus edittext
     * - parameter textField: Textfield will be focusing
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self._currentTextField = textField
    }
    
    /**
     * Handle move textfield when keyboard overloading
     */
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        if self._currentTextField != nil {
            let bottomOffset = CGPoint(x: 0.0,
                                       y: _scrollView.contentSize.height - _scrollView.bounds.size.height)
            _scrollView.setContentOffset(bottomOffset, animated: true)
            var delta = (self._currentTextField?.frame.maxY)! + getTopHeight() - self.keyboardTopY
//            if self._currentTextField == self._txtPhone {
//                delta += 50
//            }
            if self._transactionCompleteBean.discount_amount == DomainConst.NUMBER_ZERO_VALUE {
                delta += GlobalConst.CONFIGURATION_ITEM_HEIGHT
            }
            if delta > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: self.view.frame.origin.x, y: -delta, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    /**
     * Handle when lost focus edittext
     * - parameter textField: Textfield will be focusing
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        //textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
        return true
    }
}
