//
//  G04F00S02VC.swift
//  project
//
//  Created by SPJ on 12/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
//class G04F00S02VC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
class G04F00S02VC: ChildViewController, UITableViewDataSource, UITableViewDelegate {
//-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
    // MARK: Properties
    /** Id */
    public static var _id: String           = DomainConst.BLANK
    /** Parent view */
    var _scrollView: UIScrollView           = UIScrollView()
    /** Employee information view */
    private var _employeeView: UIView       = UIView()
    /** Employee */
    var lblEmployee: UILabel                = UILabel()
    /** Icon image view */
    var iconImg: UIImageView                = UIImageView()
    /** Name */
    var lblName: UILabel                    = UILabel()
    /** Label phone */
    private var _lblPhone: UILabel          = UILabel()
    /** Button phone */
    private var _btnPhone: UIButton         = UIButton()
    /** Employee table view */
    @IBOutlet weak var _tblEmployee:        UITableView!
    /** Material table view */
    @IBOutlet weak var _tblMaterial:        UITableView!
    /** Information table view */
    @IBOutlet weak var _tblInfo: UITableView!
    /** List of information data */
    private var _listEmployee:  [ConfigurationModel] = [ConfigurationModel]()
    /** List of material data */
    private var _listMaterial:  [OrderDetailBean]    = [OrderDetailBean]()
    /** List of information data */
    private var _listInfo:      [ConfigurationModel] = [ConfigurationModel]()
    
    // MARK: Methods
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self, selector: #selector(configItemTap(_:)), name:NSNotification.Name(rawValue: G04Const.NOTIFY_NAME_G04_ORDER_VIEW_CONFIG_ITEM), object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * Setup list employee data
     */
    func setupListEmployee(data: OrderBean = OrderBean()) {
        _listEmployee.removeAll()
        _listEmployee.append(ConfigurationModel(id: DomainConst.EMPLOYEE_INFO_CODE_ID,
                                            name: data.employee_name,
                                            iconPath: DomainConst.EMPLOYEE_ICON_IMG_NAME,
                                            value: DomainConst.BLANK))
        _listEmployee.append(ConfigurationModel(id: DomainConst.EMPLOYEE_INFO_PHONE_ID,
                                                name: data.employee_phone,
                                                iconPath: DomainConst.PHONE_ICON_IMG_NAME,
                                                value: DomainConst.BLANK))
        // Update layout
        updateLayout(data: data)
    }
    
    /**
     * Update layout
     * - parameter data: Data object
     */
    func updateLayout(data: OrderBean) {
        var offset: CGFloat = 0.0
        // Check value of Employee's name does exist
        if data.employee_name.isEmpty {
            // Hide employee information view
            self._employeeView.isHidden = true
            offset = GlobalConst.MARGIN_CELL_X
        } else {
            // Show employee information view
            self._employeeView.isHidden = false
            offset = self._tblEmployee.frame.maxY
        }
        // Update below parts
        updateLayout(y: offset)
    }
    
    /**
     * Update layout
     * - parameter y: Offset bottom of Employee information view
     */
    func updateLayout(y: CGFloat = 0.0) {
        var offset = y
        // Material table view
        //let materialHeight = GlobalConst.CELL_HEIGHT_SHOW * 2 / 3
        let materialHeight = GlobalConst.CONFIGURATION_ITEM_HEIGHT
        self._tblMaterial.frame = CGRect(x: 0,
                                         y: offset,
                                         width: GlobalConst.SCREEN_WIDTH,
                                         height: materialHeight * CGFloat(self._listMaterial.count))
        offset = offset + self._tblMaterial.frame.height
        
        // Information table view
        self._tblInfo.frame = CGRect(x: 0,
                                     y: offset,
                                     width: GlobalConst.SCREEN_WIDTH,
                                     height: CGFloat(_listInfo.count) * GlobalConst.CONFIGURATION_ITEM_HEIGHT)
        offset = offset + self._tblInfo.frame.height + GlobalConst.MARGIN
        
        // Label phone
        self._lblPhone.frame = CGRect(x: 0, y: offset,
                                      width: GlobalConst.SCREEN_WIDTH,
                                      height: GlobalConst.LABEL_H)
        offset = offset + self._lblPhone.frame.height
        
        // Button Phone
        self._btnPhone.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                      y: offset,
                                      width: GlobalConst.BUTTON_W,
                                      height: GlobalConst.BUTTON_H)
        offset = offset + self._btnPhone.frame.height
        
        // Scroll view
        self._scrollView.contentSize = CGSize(
            width: GlobalConst.SCREEN_WIDTH,
            height: offset)
    }
    
    /**
     * Setup list material data
     */
    func setupListMaterial(data: OrderBean = OrderBean()) {
        for item in data.order_detail {
            if !item.material_id.isEmpty {
                self._listMaterial.append(item)
            }
        }
        //self._listMaterial.append(contentsOf: data.order_detail)
        updateLayout(data: data)
    }
    
    /**
     * Setup list information data
     */
    func setupListInfo(data: OrderBean = OrderBean()) {
        self._listInfo.removeAll()
        if data.promotion_amount != DomainConst.NUMBER_ZERO_VALUE {
            _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_PROMOTION_ID,
                                                name: DomainConst.CONTENT00219,
                                                iconPath: DomainConst.DEFAULT_MATERIAL_IMG_NAME,
                                                //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                                //value: data.promotion_amount + DomainConst.VIETNAMDONG))
                                                value: "-" + data.promotion_amount))
                                                //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        }
        if data.discount_amount != DomainConst.NUMBER_ZERO_VALUE {
            _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_DISCOUNT_ID,
                                                name: DomainConst.CONTENT00239,
                                                iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                                //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                                //value: data.discount_amount + DomainConst.VIETNAMDONG))
                                                value: "-" + data.discount_amount))
                                                //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        }
        
        if data.amount_bu_vo != DomainConst.NUMBER_ZERO_VALUE {
            _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_BUVO_ID,
                                                name: DomainConst.CONTENT00246,
                                                iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                                //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                                //value: data.amount_bu_vo + DomainConst.VIETNAMDONG))
                                                value: "+" + data.amount_bu_vo))
                                                //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        }
        _listInfo.append(ConfigurationModel(id: DomainConst.AGENT_TOTAL_MONEY_ID,
                                            name: DomainConst.CONTENT00218,
                                            iconPath: DomainConst.MONEY_ICON_IMG_NAME,
                                            //++ BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
                                            //value: data.grand_total + DomainConst.VIETNAMDONG))
                                            value: data.grand_total))
                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
        updateLayout(data: data)
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
                                            //value: DomainConst.VIETNAMDONG))
                                            value: DomainConst.BLANK))
                                            //-- BUG0037-SPJ (NguyenPT 20170222) Remove Currency symbol
    }
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        // Menu item tap
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        
        // Get height of status bar + navigation bar
        // Setup default data
        setupListEmployee()
        setupListMaterial()
        setupListInfo()
        // Offset
        var offset: CGFloat = GlobalConst.MARGIN_CELL_X
        _scrollView.translatesAutoresizingMaskIntoConstraints = true
        _scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: GlobalConst.SCREEN_WIDTH,
            height: GlobalConst.SCREEN_HEIGHT)
        _employeeView.frame = CGRect(x: 0, y: 0,
                                     width: GlobalConst.SCREEN_WIDTH,
                                     height: GlobalConst.LABEL_H + GlobalConst.CONFIGURATION_ITEM_HEIGHT * 2)
        _scrollView.addSubview(_employeeView)
        
        // Label Employee
        lblEmployee.translatesAutoresizingMaskIntoConstraints = true
        lblEmployee.frame = CGRect(x: 0,
                               y: offset,
                               width: GlobalConst.SCREEN_WIDTH,
                               height: GlobalConst.LABEL_H)
        lblEmployee.text          = DomainConst.CONTENT00233
        lblEmployee.textAlignment = .center
        lblEmployee.textColor     = GlobalConst.TEXT_COLOR
        lblEmployee.font          = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        self._employeeView.addSubview(lblEmployee)
        offset = offset + lblEmployee.frame.height
        
        // Icon image
        let size = GlobalConst.LOGIN_LOGO_H / 2
        iconImg.image = ImageManager.getImage(named: DomainConst.ORDER_ICON_IMG_NAME)
        iconImg.frame = CGRect(x: GlobalConst.MARGIN,
                               y: offset,
                               width: size,
                               height: size)
        iconImg.contentMode = .scaleAspectFit
        iconImg.translatesAutoresizingMaskIntoConstraints = true
        iconImg.layer.masksToBounds = true
        iconImg.layer.cornerRadius = size / 2
        self._employeeView.addSubview(iconImg)
        
        // Employee table view
        self._tblEmployee.translatesAutoresizingMaskIntoConstraints = true
        self._tblEmployee.frame = CGRect(x: self.iconImg.frame.maxY,
                                         y: offset,
                                         width: GlobalConst.SCREEN_WIDTH - self.iconImg.frame.maxY,
                                         height: CGFloat(_listEmployee.count) * GlobalConst.CONFIGURATION_ITEM_HEIGHT)
        offset = offset + self._tblEmployee.frame.height
        self._employeeView.addSubview(self._tblEmployee)
        
        // Material table view
        //let materialHeight = GlobalConst.CELL_HEIGHT_SHOW * 2 / 3
        let materialHeight = GlobalConst.CONFIGURATION_ITEM_HEIGHT
        self._tblMaterial.translatesAutoresizingMaskIntoConstraints = true
        self._tblMaterial.frame = CGRect(x: 0,
                                             y: offset,
                                             width: GlobalConst.SCREEN_WIDTH,
                                             height: materialHeight * CGFloat(self._listMaterial.count))
        offset = offset + self._tblMaterial.frame.height
        self._scrollView.addSubview(self._tblMaterial)
        
        // Information table view
        self._tblInfo.translatesAutoresizingMaskIntoConstraints = true
        self._tblInfo.frame = CGRect(x: 0,
                                         y: offset,
                                         width: GlobalConst.SCREEN_WIDTH,
                                         height: CGFloat(_listInfo.count) * GlobalConst.CONFIGURATION_ITEM_HEIGHT)
        offset = offset + self._tblInfo.frame.height + GlobalConst.MARGIN
        self._scrollView.addSubview(self._tblInfo)
        
        // Label phone
        self._lblPhone.frame = CGRect(x: 0, y: offset,
                                      width: GlobalConst.SCREEN_WIDTH,
                                      height: GlobalConst.LABEL_H)
        self._lblPhone.text = DomainConst.CONTENT00241
        self._lblPhone.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        self._lblPhone.textAlignment = .center
        offset = offset + self._lblPhone.frame.height
        self._scrollView.addSubview(self._lblPhone)
        
        // Button Phone
        self._btnPhone.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                      y: offset,
                                      width: GlobalConst.BUTTON_W,
                                      height: GlobalConst.BUTTON_H)
        self._btnPhone.backgroundColor = UIColor.white
        self._btnPhone.setTitle("0123456789", for: UIControlState())
        self._btnPhone.setTitleColor(GlobalConst.MAIN_COLOR, for: UIControlState())
        self._btnPhone.titleLabel?.font = UIFont.boldSystemFont(ofSize: GlobalConst.LARGE_FONT_SIZE)
        self._btnPhone.addTarget(self, action: #selector(makeCall), for: .touchUpInside)
        self._btnPhone.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        self._btnPhone.layer.borderWidth = 1
        self._btnPhone.layer.borderColor = GlobalConst.MAIN_COLOR.cgColor
        offset = offset + self._btnPhone.frame.height
        self._scrollView.addSubview(self._btnPhone)
        
        self._scrollView.contentSize = CGSize(
            width: GlobalConst.SCREEN_WIDTH,
            height: offset)
        self.view.addSubview(_scrollView)
        
        // NavBar setup
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00232, isNotifyEnable: BaseModel.shared.checkIsLogin())
        createNavigationBar(title: DomainConst.CONTENT00232)
        //-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        
        OrderViewRequest.requestOrderView(action: #selector(setData(_:)), view: self, id: G04F00S02VC._id)
        self.view.makeComponentsColor()
    }
    
    /**
     * Make a call
     */
    func makeCall(_ sender: AnyObject) {
        let phone = self._btnPhone.titleLabel?.text?.normalizatePhoneString()
        self.makeACall(phone: phone!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setData(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        let model: OrderViewRespModel = (notification.object as! OrderViewRespModel)
        let data = (notification.object as! String)
        let model = OrderViewRespModel(jsonString: data)
        if !model.isSuccess() {
            showAlert(message: model.message)
            return
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
        lblName.text = model.getRecord().employee_name
        if !model.getRecord().employee_image.isEmpty {
            self.iconImg.getImgFromUrl(link: model.getRecord().employee_image, contentMode: self.iconImg.contentMode)
        }
        self._btnPhone.setTitle(model.getRecord().agent_phone.normalizatePhoneString(), for: UIControlState())
        setupListEmployee(data: model.getRecord())
        setupListMaterial(data: model.getRecord())
        setupListInfo(data: model.getRecord())
        self._tblEmployee.reloadData()
        self._tblMaterial.reloadData()
        self._tblInfo.reloadData()
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
//        if tableView == _tblMaterial {
//            return GlobalConst.CELL_HEIGHT_SHOW * 2/3
//        }
        return UITableViewAutomaticDimension
    }
    
    /**
     * Set number of row in table view
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == _tblMaterial {
            return self._listMaterial.count
        } else if tableView == _tblInfo {
            return _listInfo.count
        } else if tableView == _tblEmployee {
            return _listEmployee.count
        }
        return 0
    }
    
    
    /**
     * Set content of row in table view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retCell = UITableViewCell()
        if tableView == _tblMaterial {
//            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.MATERIAL_TABLE_VIEW_CELL,
//                                                     for: indexPath) as! MaterialTableViewCell
//            cell.setData(data: self._listMaterial[indexPath.row])
//            retCell = cell
            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL,
                                                     for: indexPath) as! ConfigurationTableViewCell
            cell.setData(material: self._listMaterial[indexPath.row])
            retCell = cell
        } else if tableView == _tblInfo {
            ConfigurationTableViewCell.PARENT_WIDTH = GlobalConst.SCREEN_WIDTH
            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL,
                                                     for: indexPath) as! ConfigurationTableViewCell
            
            cell.setData(data: _listInfo[indexPath.row])
            if _listInfo[indexPath.row].id == DomainConst.AGENT_TOTAL_MONEY_ID {
                cell.highlightValue()
            }
            
            retCell = cell
        } else if tableView == _tblEmployee {
            ConfigurationTableViewCell.PARENT_WIDTH = GlobalConst.SCREEN_WIDTH - self.iconImg.frame.width
            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL,
                                                     for: indexPath) as! ConfigurationTableViewCell
            cell.setData(data: _listEmployee[indexPath.row])
            if _listEmployee[indexPath.row].id == DomainConst.EMPLOYEE_INFO_CODE_ID {
                cell.highlightValue()
            }
            
            retCell = cell
        }
        return retCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == _tblMaterial {
            // Do nothing
        } else if tableView == _tblInfo {
            // Do nothing
        } else if tableView == _tblEmployee {
            let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL,
                                                     for: indexPath) as! ConfigurationTableViewCell
            cell.setData(data: _listEmployee[indexPath.row])
            if _listEmployee[indexPath.row].id == DomainConst.EMPLOYEE_INFO_PHONE_ID {
                let phone = _listEmployee[indexPath.row].name.normalizatePhoneString()
                self.makeACall(phone: phone)
            }
        }
    }

}
