//
//  G12F00S01VC.swift
//  project
//
//  Created by SPJ on 10/17/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G12F00S01VC: BaseParentViewController {
    // MARK: Properties
    /** Information table view */
    var tblInfo:            UITableView             = UITableView()
    /** Current page */
    var page:               Int                     = 0
    /** Current data */
    var _data:              OrderListRespModel      = OrderListRespModel()
    /** Refrest control */
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    // MARK: Static values
    
    // MARK: Constant
    var CELL_REAL_WIDTH_HD     = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_HD
    var CELL_REAL_WIDTH_FHD    = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD
    var CELL_REAL_WIDTH_FHD_L  = GlobalConst.HD_SCREEN_BOUND.w * BaseViewController.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Navigation
        self.createNavigationBar(title: DomainConst.CONTENT00527)
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
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderListRespModel(jsonString: data)
        if model.isSuccess() {
            _data.total_page = model.total_page
            _data.total_record = model.total_record
            _data.append(contentOf: model.getRecord())
            tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Event handler
    
    // MARK: Logic
    /**
     * Request data
     */
    internal func requestData(action: Selector = #selector(setData(_:))) {
        OrderListRequest.requestOrderList(
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
        tblInfo.reloadData()
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
    
    // MARK: Layout
    // MARK: Information table view
    private func createInfoTableView() {
        tblInfo.frame = CGRect(x: 0, y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
        tblInfo.dataSource = self
        tblInfo.delegate = self
        tblInfo.addSubview(refreshControl)
        tblInfo.register(UINib(nibName: G12F00S01Cell.theClassName, bundle: nil),
                         forCellReuseIdentifier: G12F00S01Cell.theClassName)
    }
    
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height)
        tblInfo.reloadData()
    }
}

// MARK: Protocol - UITableViewDataSource
extension G12F00S01VC: UITableViewDataSource {
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
        let data = self._data.record[indexPath.row]
        var cell = UITableViewCell()
//        if self.isPadSize() {
//            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
//                                   reuseIdentifier: "Cell")
//            cell.imageView?.setImage(imgPath: DomainConst.STATUS_FINISH_IMG_NAME)
//            cell.imageView?.contentMode = .scaleAspectFit
//            // Date label
//            let lblDate = UILabel()
//            lblDate.tag = 1
//            lblDate.frame = CGRect(x: 0,
//                                    y: 0,
//                                    width: 200,
//                                    height: GlobalConst.LABEL_H)
//            lblDate.text = "12/07/2017"
//            lblDate.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleHeight]
//            cell.contentView.addSubview(lblDate)
//        
////        cell.textLabel?.text = data.created_date
////        cell.textLabel?.font = GlobalConst.BASE_FONT
////        cell.detailTextLabel?.text = data.code_no
////        switch data.id {
////        case DomainConst.ORDER_INFO_TOTAL_MONEY_ID:
////            cell.detailTextLabel?.textColor = GlobalConst.MAIN_COLOR_GAS_24H
////            cell.detailTextLabel?.font = GlobalConst.BASE_BOLD_FONT
////        case DomainConst.ORDER_INFO_DISCOUNT:
////            cell.detailTextLabel?.textColor = GlobalConst.MAIN_COLOR_GAS_24H
////            cell.detailTextLabel?.font = GlobalConst.BASE_FONT
////            break
////        default:
////            cell.detailTextLabel?.font = GlobalConst.BASE_FONT
////            break
////        }
//        } else {
//            cell = tableView.dequeueReusableCell(
//                withIdentifier: G12F00S01Cell.theClassName,
//                for: indexPath)
//            (cell as! G12F00S01Cell).setData(bean: data)
//        }
        cell = tableView.dequeueReusableCell(
            withIdentifier: G12F00S01Cell.theClassName,
            for: indexPath)
        cell.preservesSuperviewLayoutMargins = true
        cell.contentView.preservesSuperviewLayoutMargins = true
        (cell as! G12F00S01Cell).setData(bean: data)
        
        return cell
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConst.LABEL_H * 3
    }
}

// MARK: Protocol - UITableViewDataSource
extension G12F00S01VC: UITableViewDelegate {
    /**
     * Tells the delegate that the specified row is now selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let g12f00s02 = G12F00S02VC(nibName: G12F00S02VC.theClassName,
                                    bundle: nil)
        g12f00s02.setId(id: self._data.getRecord()[indexPath.row].id)
        self.navigationController?.pushViewController(
            g12f00s02,
            animated: true)
    }
    
    /**
     * Tells the delegate the table view is about to draw a cell for a particular row.
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Total page does not 1
        if _data.total_page != 1 {
            let lastElement = _data.getRecord().count - 1
            // Current is the last element
            if indexPath.row == lastElement {
                self.page += 1
                // Page less than total page
                if self.page <= _data.total_page {
                    self.requestData()
                }
            }
        }
    }
}
