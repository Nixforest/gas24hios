//
//  G04F00S01VC.swift
//  project
//
//  Created by SPJ on 12/28/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
//class G04F00S01VC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
class G04F00S01VC: ParentViewController, UITableViewDataSource, UITableViewDelegate {
//-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
    // MARK: Properties
    /** Icon image view */
    @IBOutlet weak var iconImg:     UIImageView!
    /** Table view */
    @IBOutlet weak var tableView:   UITableView!
    /** Data */
    private static var _data:       OrderListRespModel = OrderListRespModel()
    /** Current page */
    private var _page = 0
    
    // MARK: Methods
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self, selector: #selector(configItemTap(_:)), name:NSNotification.Name(rawValue: G04Const.NOTIFY_NAME_G04_ORDER_LIST_CONFIG_ITEM), object: nil)
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
        
        // Get height of status bar + navigation bar
        var offset = self.getTopHeight()
        if BaseModel.shared.getDebugShowTopIconFlag() {
            iconImg.image = ImageManager.getImage(named: DomainConst.ORDER_ICON_IMG_NAME)
            iconImg.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.LOGIN_LOGO_W / 2) / 2,
                                   y: offset,
                                   width: GlobalConst.LOGIN_LOGO_W / 2,
                                   height: GlobalConst.LOGIN_LOGO_H / 2)
            iconImg.translatesAutoresizingMaskIntoConstraints = true
            offset = offset + iconImg.frame.height
        } else {
            iconImg.isHidden = true
        }
        // Order list view
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.frame = CGRect(x: 0, y: offset,
                                 width: GlobalConst.SCREEN_WIDTH,
                                 height: GlobalConst.SCREEN_HEIGHT - offset)
        tableView.separatorStyle = .singleLine
        let frameworkBundle = Bundle(identifier: DomainConst.HARPY_FRAMEWORK_BUNDLE_NAME)
        tableView.register(UINib(nibName: DomainConst.TABLE_VIEW_CELL_ORDER_TYPE, bundle: frameworkBundle), forCellReuseIdentifier: DomainConst.TABLE_VIEW_CELL_ORDER_TYPE)
        tableView.dataSource = self
        tableView.delegate = self
        
        // NavBar setup
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00231, isNotifyEnable: BaseModel.shared.checkIsLogin())
        createNavigationBar(title: DomainConst.CONTENT00231)
        //-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        
        //++ BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
//        // Notify set data
//        NotificationCenter.default.addObserver(self, selector: #selector(setData(_:)), name:NSNotification.Name(rawValue: G04Const.NOTIFY_NAME_G04_ORDER_LIST_SET_DATA), object: nil)
        //-- BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
        
        OrderListRequest.requestOrderList(action: #selector(setData(_:)), view: self, page: String(self._page))
        self.view.makeComponentsColor()
    }
    
    /**
     * Set data for controls
     */
    override func setData(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        let data = (notification.object as! OrderListRespModel)
//        G04F00S01VC._data.total_page = data.total_page
//        G04F00S01VC._data.total_record = data.total_record
//        G04F00S01VC._data.append(contentOf: data.getRecord())
//        tableView.reloadData()
        let data = (notification.object as! String)
        let model = OrderListRespModel(jsonString: data)
        if model.isSuccess() {
            G04F00S01VC._data.total_page = model.total_page
            G04F00S01VC._data.total_record = model.total_record
            G04F00S01VC._data.append(contentOf: model.getRecord())
            tableView.reloadData()
        } else {
            showAlert(message: model.message)
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    }
    
    // MARK: - UITableViewDataSource
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return G04F00S01VC._data.getRecord().count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: DomainConst.TABLE_VIEW_CELL_ORDER_TYPE) as! TableCellOrderType
        //let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if G04F00S01VC._data.getRecord().count > indexPath.row {
            cell.setData(data: G04F00S01VC._data.getRecord()[indexPath.row])
        }
        return cell
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableCellOrderType.CELL_HEIGHT
    }
    
    /**
     * Tells the delegate that the specified row is now selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        G04F00S02VC._id = G04F00S01VC._data.getRecord()[indexPath.row].id
//        self.pushToView(name: G04Const.G04_F00_S02_VIEW_CTRL)
//        self.showToast(message: "Open order detail: \(G04F00S02VC._id)")
        let view = G12F00S02VC(nibName: G12F00S02VC.theClassName,
                               bundle: nil)
        view.setId(id: G04F00S01VC._data.getRecord()[indexPath.row].id)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    /**
     * Tells the delegate the table view is about to draw a cell for a particular row.
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Total page does not 1
        if G04F00S01VC._data.total_page != 1 {
            let lastElement = G04F00S01VC._data.getRecord().count - 1
            // Current is the last element
            if indexPath.row == lastElement {
                self._page += 1
                // Page less than total page
                if self._page <= G04F00S01VC._data.total_page {
                    OrderListRequest.requestOrderList(action: #selector(setData(_:)), view: self, page: String(self._page))
                }
            }
        }
    }
    
    /**
     * View did appear
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    /**
     * Clear data of view.
     * Reset currentPage value
     * Reset uphold list value
     */
    override func clearData() {
        G04F00S01VC._data = OrderListRespModel()
    }
}
