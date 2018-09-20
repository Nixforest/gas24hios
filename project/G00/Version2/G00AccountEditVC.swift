//
//  G00AccountEditVC.swift
//  project
//
//  Created by SPJ on 10/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G00AccountEditVC: BaseChildViewController {
    // MARK: Properties
    /** Information table view */
    var tblInfo:            UITableView             = UITableView()
    /** Data */
    var _data:              [ConfigurationModel]    = [ConfigurationModel]()
    /** Address data (Province id, District id, Ward id, Street id) */
    var _addressData:       (String, String, String, String)        = ("", "", "", "")
    /** Flag user has change data */
    var _isChanged:         Bool                    = false
    
    // MARK: Static values
    // MARK: Constant
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00442)
        updateAddress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndex = tblInfo.indexPathForSelectedRow, selectedIndex.section == 0 {
            let model = _data[selectedIndex.row]
            switch model.id {
            case DomainConst.ACCOUNT_INFO_STREET_ID:
                if !BaseModel.shared.sharedString.isEmpty {
                    _addressData.3 = BaseModel.shared.sharedString
                    model.updateData(id: model.id,
                                     name: model.name,
                                     iconPath: model.getIconPath(),
                                     value: BaseModel.shared.getStreetNameById(id: _addressData.3))
                    tblInfo.reloadData()
                }
                break
            case DomainConst.ACCOUNT_INFO_CITY_ID:
                if _addressData.0 != BaseModel.shared.sharedString && !BaseModel.shared.sharedString.isEmpty {
                    // Update id
                    _addressData.0 = BaseModel.shared.sharedString
                    // Update value
                    model.updateData(id: model.id,
                                     name: model.name,
                                     iconPath: model.getIconPath(),
                                     value: BaseModel.shared.getProvinceNameById(id: _addressData.0))
                    // Update province for view
                    updateProvinceForView()
                }
                break
            case DomainConst.ACCOUNT_INFO_DISTRICT_ID:
                if _addressData.1 != BaseModel.shared.sharedString && !BaseModel.shared.sharedString.isEmpty {
                    // Update id
                    _addressData.1 = BaseModel.shared.sharedString
                    // Update value
                    model.updateData(id: model.id,
                                     name: model.name,
                                     iconPath: model.getIconPath(),
                                     value: BaseModel.shared.getDistrictNameById(
                                        id: _addressData.1,
                                        provinceId: _addressData.0))
                    // Update district for view
                    updateDistrictForView()
                }
                break
            case DomainConst.ACCOUNT_INFO_WARD_ID:
                if _addressData.2 != BaseModel.shared.sharedString && !BaseModel.shared.sharedString.isEmpty {
                    // Update id
                    _addressData.2 = BaseModel.shared.sharedString
                    // Update value
                    model.updateData(id: model.id,
                                     name: model.name,
                                     iconPath: model.getIconPath(),
                                     value: BaseModel.shared.getWardNameById(
                                        id: _addressData.2,
                                        districtId: _addressData.1))
                    // Update ward for view
                    updateWardForView()
                }
                break
            default:
                break
            }
            BaseModel.shared.sharedString = DomainConst.BLANK
        }
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
        // Create information table view
        createInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(tblInfo)
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
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                break
            default:
                break
            }
            
            break
        default:
            break
        }
    }
    
    // MARK: Event handler
    /**
     * Handle when finish request list provinces from server
     */
    internal func finishRequestListProvinces(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = ProvincesListRespModel(jsonString: data)
        if model.isSuccess() {
            // Save data
            BaseModel.shared.setListProvinces(data: model.getRecord())
            // Update province info for view
            updateProvinceForView()
        }
    }
    
    /**
     * Handle when finish request list districts from server
     */
    internal func finishRequestListDistricts(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = DistrictsListRespModel(jsonString: data)
        if model.isSuccess() {
            // Save data
            BaseModel.shared.setListDistricts(provinceId: _addressData.0, data: model.getRecord())
            // Update district for view
            updateDistrictForView()
        }
    }
    
    /**
     * Handle when finish request list wards from server
     */
    internal func finishRequestListWards(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = WardsListRespModel(jsonString: data)
        if model.isSuccess() {
            // Save data
            BaseModel.shared.setListWards(districtId: _addressData.1,
                                          data: model.getRecord())
            // Update ward for view
            updateWardForView()
        }
    }
    internal func finishRequestChangeProfile(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            self.backButtonTapped(self)
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Logic
    private func updateAddress() {
        // Check provinces list is empty
        if BaseModel.shared.checkProvincesListEmpty() {
            // Request from server
            requestProvinces()
        } else {
            // Update province info for view
            updateProvinceForView()
        }
    }
    
    /**
     * Update province info for view
     */
    private func updateProvinceForView() {
        let provinceId = _addressData.0
        // Check if current province id is empty
        if !provinceId.isEmpty {
            // Show selected province
            updateDataForTblView(model: ConfigurationModel(
                id: DomainConst.ACCOUNT_INFO_CITY_ID,
                name: DomainConst.CONTENT00298,
                iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
                value: BaseModel.shared.getProvinceNameById(id: provinceId)))
            tblInfo.reloadData()
            // Check districts list is empty
            if BaseModel.shared.checkDistrictListEmpty(provinceId: provinceId) {
                // Request from server
                requestDistricts(provinceId: provinceId)
            } else {
                // Update district for view
                updateDistrictForView()
            }
        }
    }
    
    /**
     * Update district info for view
     */
    private func updateDistrictForView() {
        // Get name of district
        var districtName = BaseModel.shared.getDistrictNameById(
            id: _addressData.1,
            provinceId: _addressData.0)
        // Check district name is empty
        if districtName.isEmpty {
            // Get current list
            let list = BaseModel.shared.getListDistricts(provinceId: _addressData.0)
            // Check list is not empty
            if !list.isEmpty {
                // Get new value of district id is first element of list
                _addressData.1 = list[0].id
                // Get new name of district
                districtName = BaseModel.shared.getDistrictNameById(
                    id: _addressData.1,
                    provinceId: _addressData.0)
            }
        }
        let districtId = _addressData.1
        
        // Check if current district id is empty
        if !districtId.isEmpty {
            // Show selected district
            updateDataForTblView(model: ConfigurationModel(
                id: DomainConst.ACCOUNT_INFO_DISTRICT_ID,
                name: DomainConst.CONTENT00299,
                iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
                value: districtName))
            tblInfo.reloadData()
            // Check if wards list is empty
            if BaseModel.shared.checkWardListEmpty(districtId: districtId) {
                // Request from server
                requestWards(provinceId: _addressData.0,
                             districtId: districtId)
            } else {
                // Update ward for view
                updateWardForView()
            }
        }
    }
    
    /**
     * Update ward info for view
     */
    private func updateWardForView() {
        // Get name of ward
        var wardName = BaseModel.shared.getWardNameById(
            id: _addressData.2,
            districtId: _addressData.1)
        // Check Ward name is empty
        if wardName.isEmpty {
            // Get current list
            let list = BaseModel.shared.getListWards(districtId: _addressData.1)
            // Check list is not empty
            if !list.isEmpty {
                // Get new value of ward id is first element of list
                _addressData.2 = list[0].id
                // Get new name of ward
                wardName = BaseModel.shared.getWardNameById(
                    id: _addressData.2,
                    districtId: _addressData.1)
            }
        }
        
        // Show selected ward
        updateDataForTblView(model: ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_WARD_ID,
            name: DomainConst.CONTENT00300,
            iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
            value: wardName))
        tblInfo.reloadData()
    }
    
    /**
     * Request data
     */
    internal func requestData() {
    }
    
    /**
     * Request provinces
     */
    private func requestProvinces() {
        ProvincesListRequest.request(
            action: #selector(finishRequestListProvinces(_:)),
            view: self)
    }
    
    /**
     * Request districts
     * - parameter provinceId: Id of province
     */
    private func requestDistricts(provinceId: String) {
        DistrictsListRequest.request(
            action: #selector(finishRequestListDistricts(_:)),
            view: self,
            provinceId: provinceId)
    }
    
    /**
     * Request list wards
     * - parameter provinceId: Id of province
     * - parameter districtId: Id of district
     */
    private func requestWards(provinceId: String, districtId: String) {
        WardsListRequest.request(
            action: #selector(finishRequestListWards(_:)),
            view: self,
            provinceId: provinceId,
            districtId: districtId)
    }
    
    /**
     * Update data
     */
    private func updateDataForTblView(model: ConfigurationModel) {
        for item in _data {
            if item.id == model.id {
                item.updateData(id: model.id,
                                name: model.name,
                                iconPath: model.getIconPath(),
                                value: model.getValue())
                break
            }
        }
    }
    
    /**
     * Change value in table view
     */
    internal func changeValueTableView(model: ConfigurationModel) {
        var txtValue:   UITextField?
        // Create alert
        let alert = UIAlertController(title: DomainConst.CONTENT00141,
                                      message: model.name,
                                      preferredStyle: .alert)
        // Add textfield
        alert.addTextField(configurationHandler: {
            textField -> Void in
            txtValue = textField
            txtValue?.text = model.getValue()
            txtValue?.textAlignment = .center
            txtValue?.clearButtonMode = .whileEditing
            txtValue?.returnKeyType = .done
            txtValue?.keyboardType = .default
            if model.id == DomainConst.ACCOUNT_INFO_EMAIL_ID {
                txtValue?.keyboardType = .emailAddress
            }
        })
        // Add cancel action
        let cancel = UIAlertAction(title: DomainConst.CONTENT00202, style: .cancel, handler: nil)
        // Add ok action
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .default) { action -> Void in
            if let value = txtValue?.text , !value.isEmpty {
                self.updateDataForTblView(model: ConfigurationModel(
                    id: model.id,
                    name: model.name,
                    iconPath: model.getIconPath(),
                    value: value))
                self.tblInfo.reloadData()
            } else {
                self.showAlert(message: DomainConst.CONTENT00025, okTitle: DomainConst.CONTENT00251,
                               okHandler: {_ in
                                self.changeValueTableView(model: model)
                },
                               cancelHandler: {_ in
                                
                })
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    /**
     * Check if value of model is updated
     * - returns: True if value is not equal user infor value, False otherwise
     */
    internal func isValueUpdated(model: ConfigurationModel) -> Bool {
        switch model.id {
        case DomainConst.ACCOUNT_INFO_NAME_ID:
            return (model.getValue() != BaseModel.shared.getUserInfo().getName())
        case DomainConst.ACCOUNT_INFO_EMAIL_ID:
            return (model.getValue() != BaseModel.shared.getUserInfo().getEmail())
        case DomainConst.ACCOUNT_INFO_HOUSE_NUMBER_ID:
            return (model.getValue() != BaseModel.shared.getUserInfo().getHouseNumber())
        case DomainConst.ACCOUNT_INFO_STREET_ID:
            return (model.getValue() != BaseModel.shared.getStreetNameById(
                id: BaseModel.shared.getUserInfo().getStreetId()))
        case DomainConst.ACCOUNT_INFO_CITY_ID:
            return (model.getValue() != BaseModel.shared.getUserInfoProvinceName())
        case DomainConst.ACCOUNT_INFO_DISTRICT_ID:
            return (model.getValue() != BaseModel.shared.getUserInfoDistrictName())
        case DomainConst.ACCOUNT_INFO_WARD_ID:
            return (model.getValue() != BaseModel.shared.getUserInfoWardName())
        default:
            break
        }
        return false
    }
    
    internal func openAddressSelectVC(title: String, data: [ConfigBean], selectedValue: String) {
        let view = G00AddressSelectVC(nibName: G00AddressSelectVC.theClassName,
                                      bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: data, selectedValue: selectedValue)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Check if user has changed data
     * - returns: True if suer has changed any data, False otherwise
     */
    internal func isUserChangedData() -> Bool {
        var retVal = false
        for item in _data {
            switch item.id {
            case DomainConst.ACCOUNT_INFO_NAME_ID:
                retVal = (item.getValue() != BaseModel.shared.getUserInfo().getName())
                break
            case DomainConst.ACCOUNT_INFO_EMAIL_ID:
                retVal = (item.getValue() != BaseModel.shared.getUserInfo().getEmail())
                break
            case DomainConst.ACCOUNT_INFO_HOUSE_NUMBER_ID:
                retVal = (item.getValue() != BaseModel.shared.getUserInfo().getHouseNumber())
                break
            case DomainConst.ACCOUNT_INFO_STREET_ID:
                retVal = (item.getValue() != BaseModel.shared.getStreetNameById(
                    id: BaseModel.shared.getUserInfo().getStreetId()))
                break
            case DomainConst.ACCOUNT_INFO_CITY_ID:
                retVal = (item.getValue() != BaseModel.shared.getUserInfoProvinceName())
                break
            case DomainConst.ACCOUNT_INFO_DISTRICT_ID:
                retVal = (item.getValue() != BaseModel.shared.getUserInfoDistrictName())
                break
            case DomainConst.ACCOUNT_INFO_WARD_ID:
                retVal = (item.getValue() != BaseModel.shared.getUserInfoWardName())
                break
            default:
                break
            }
            if retVal {
                return true
            }
        }
        return retVal
    }
    
    internal func getChangedData() -> (String, String, String, String, String, String, String) {
        var retVal = ("", "", "", "", "", "", "")
        for item in _data {
            switch item.id {
            case DomainConst.ACCOUNT_INFO_NAME_ID:
                retVal.0 = item.getValue()
                break
            case DomainConst.ACCOUNT_INFO_EMAIL_ID:
                retVal.1 = item.getValue()
                break
            case DomainConst.ACCOUNT_INFO_HOUSE_NUMBER_ID:
                retVal.2 = item.getValue()
                break
            case DomainConst.ACCOUNT_INFO_STREET_ID:
                retVal.3 = _addressData.3
                break
            case DomainConst.ACCOUNT_INFO_CITY_ID:
                retVal.4 = _addressData.0
                break
            case DomainConst.ACCOUNT_INFO_DISTRICT_ID:
                retVal.5 = _addressData.1
                break
            case DomainConst.ACCOUNT_INFO_WARD_ID:
                retVal.6 = _addressData.2
                break
            default:
                break
            }
        }
        return retVal
    }
    
    // MARK: Layout
    // MARK: Information table view
    private func createInfoTableView() {
        tblInfo.frame = CGRect(x: 0, y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
        tblInfo.dataSource = self
        tblInfo.delegate = self
//        tblInfo.separatorStyle = .none
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_NAME_ID,
            name: DomainConst.CONTENT00079,
            iconPath: DomainConst.NAME_ICON_IMG_NAME,
            value: BaseModel.shared.getUserInfo().getName()))
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_EMAIL_ID,
            name: DomainConst.CONTENT00443,
            iconPath: DomainConst.PHONE_ICON_NEW_IMG_NAME,
            value: BaseModel.shared.getUserInfo().getEmail()))
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_HOUSE_NUMBER_ID,
            name: DomainConst.CONTENT00057,
            iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
            value: BaseModel.shared.getUserInfo().getHouseNumber()))
        _addressData.0 = BaseModel.shared.getUserInfo().getProvinceId()
        _addressData.1 = BaseModel.shared.getUserInfo().getDistrictId()
        _addressData.2 = BaseModel.shared.getUserInfo().getWardId()
        _addressData.3 = BaseModel.shared.getUserInfo().getStreetId()
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_STREET_ID,
            name: DomainConst.CONTENT00058,
            iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
            value: BaseModel.shared.getStreetNameById(id: _addressData.3)))
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_CITY_ID,
            name: DomainConst.CONTENT00298,
            iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
            value: BaseModel.shared.getProvinceNameById(id: _addressData.0)))
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_DISTRICT_ID,
            name: DomainConst.CONTENT00299,
            iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
            value: BaseModel.shared.getDistrictNameById(id: _addressData.1,
                                                        provinceId: _addressData.0)))
        _data.append(ConfigurationModel(
            id: DomainConst.ACCOUNT_INFO_WARD_ID,
            name: DomainConst.CONTENT00300,
            iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
            value: BaseModel.shared.getWardNameById(id: _addressData.2,
                                                    districtId: _addressData.1)))
        tblInfo.reloadData()
    }
    
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G00AccountEditVC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return _data.count
        }
        return 2
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            if indexPath.row < self._data.count {
                let data = self._data[indexPath.row]
                cell.textLabel?.text = data.name
                cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                cell.detailTextLabel?.text = data.getValue()
                cell.detailTextLabel?.font = GlobalConst.BASE_BOLD_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.numberOfLines = 0
                if self.isValueUpdated(model: data) {
                    cell.detailTextLabel?.textColor = UIColor.red
                } else {
                    cell.detailTextLabel?.textColor = UIColor.black
                }
            }
            return cell
        case 1:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = DomainConst.CONTENT00086
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor.white
                cell.contentView.backgroundColor = GlobalConst.MAIN_COLOR_GAS_24H
            case 1:
                cell.textLabel?.text = DomainConst.CONTENT00202
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor.white
                cell.contentView.backgroundColor = GlobalConst.CANCEL_BKG_COLOR
            default:
                break
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

// MARK: Protocol - UITableViewDelegate
extension G00AccountEditVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if self.isUserChangedData() {
                    let changedData = self.getChangedData()
                    ChangeProfileRequest.request(
                        action: #selector(finishRequestChangeProfile(_:)),
                        view: self,
                        name: changedData.0,
                        province: changedData.4,
                        district: changedData.5,
                        ward: changedData.6,
                        street: changedData.3,
                        houseNumber: changedData.2,
                        email: changedData.1,
                        agent: DomainConst.BLANK)
                } else {
                    self.backButtonTapped(self)
                }
                break
            case 1:
                if self.isUserChangedData() {
                    showAlert(message: DomainConst.CONTENT00530,
                              okHandler: {
                                alert in
                                self.backButtonTapped(self)
                    },
                              cancelHandler: {
                                alert in
                                
                    })
                } else {
                    self.backButtonTapped(self)
                }
                break
            default:
                break
            }
        } else {
            // Section 0
            switch _data[indexPath.row].id {
            case DomainConst.ACCOUNT_INFO_NAME_ID,
                 DomainConst.ACCOUNT_INFO_EMAIL_ID,
                 DomainConst.ACCOUNT_INFO_HOUSE_NUMBER_ID:
                self.changeValueTableView(model: _data[indexPath.row])
                break
            case DomainConst.ACCOUNT_INFO_STREET_ID:
                openAddressSelectVC(
                    title: DomainConst.CONTENT00141 + " \(_data[indexPath.row].name)",
                    data: BaseModel.shared.getListStreets(),
                    selectedValue: _addressData.3)
                break
            case DomainConst.ACCOUNT_INFO_CITY_ID:
                openAddressSelectVC(
                    title: DomainConst.CONTENT00141 + " \(_data[indexPath.row].name)",
                    data: BaseModel.shared.getListProvinces(),
                    selectedValue: _addressData.0)
                break
            case DomainConst.ACCOUNT_INFO_DISTRICT_ID:
                if !_addressData.0.isEmpty {
                    openAddressSelectVC(
                        title: DomainConst.CONTENT00141 + " \(_data[indexPath.row].name)",
                        data: BaseModel.shared.getListDistricts(provinceId: _addressData.0),
                        selectedValue: _addressData.1)
                }
                
                break
            case DomainConst.ACCOUNT_INFO_WARD_ID:
                if !_addressData.1.isEmpty {
                    openAddressSelectVC(
                        title: DomainConst.CONTENT00141 + " \(_data[indexPath.row].name)",
                        data: BaseModel.shared.getListWards(districtId: _addressData.1),
                        selectedValue: _addressData.2)
                }
                break
            default:
                break
            }
        }
    }
}
