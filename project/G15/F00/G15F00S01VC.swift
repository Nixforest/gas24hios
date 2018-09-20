//
//  G15F00S01VC.swift
//  project
//
//  Created by Pham Trung Nguyen on 4/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class G15F00S01VC: BaseParentViewController {
    // MARK: Properties
    /** Data */
    var _data:              NewsListRespModel       = NewsListRespModel()
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Current page */
    var _page:              Int                     = 0
    /** Refrest control */
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Static values
    // MARK: Constant    
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.HOTLINE)
//        createInfoTableView()
//        self.view.addSubview(_tblInfo)
        requestData()
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _data.clearData()
        requestData(action: #selector(setData(_:)), isShowLoading: false)
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
        self.view.addSubview(_tblInfo)
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
        let model = NewsListRespModel(jsonString: data)
        if model.isSuccess() {
            _data.updateData(bean: model)
            _tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Logic
    /**
     * Request data
     */
    internal func requestData(action: Selector = #selector(setData(_:)),
                              isShowLoading: Bool = true) {
        NewsListRequest.request(
            action: action, view: self,
            page:   String(self._page),
            lat:    String(G12F01S01VC._currentPos.latitude),
            long:   String(G12F01S01VC._currentPos.longitude),
            isShowLoading: isShowLoading,
            isMenuList: DomainConst.NUMBER_ONE_VALUE)
    }
    
    /**
     * Reset data
     */
    private func resetData() {
        _data.clearData()
        // Reset current search value
        self._page      = 0
        // Reload table
        _tblInfo.reloadData()
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
    /**
     * Create information table view
     */
    private func createInfoTableView() {
        _tblInfo.frame = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height)
        _tblInfo.dataSource = self
        _tblInfo.delegate = self
        _tblInfo.rowHeight = UITableViewAutomaticDimension
        _tblInfo.estimatedRowHeight = 150
        _tblInfo.addSubview(refreshControl)
    }
    
    /**
     * Update information table view.
     */
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: _tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height)
        _tblInfo.reloadData()
    }
    
    // MARK: Logic
    internal func openDetail(id: String) {
        let view = G15F00S02VC(nibName: G15F00S02VC.theClassName, bundle: nil)
        view.setData(id: id)
        self.push(view, animated: true)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G15F00S01VC: UITableViewDataSource {
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
        return self._data.getRecord().count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self._data.getRecord().count {
            return UITableViewCell()
        }
        let data = self._data.getRecord()[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = data.list_title
//        cell.textLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.text = data.title
//        cell.detailTextLabel?.font = GlobalConst.BASE_FONT
//        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
//        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        let imgPath = DomainConst.EMAIL_ICON_IMG_NAME
        let imgMargin = GlobalConst.MARGIN * 2
        cell.imageView?.image = ImageManager.getImage(
            named: imgPath, margin: imgMargin)
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
}

// MARK: Protocol - UITableViewDelegate
extension G15F00S01VC: UITableViewDelegate {    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     * Tells the delegate the table view is about to draw a cell for a particular row.
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Total page does not 1
        if _data.getTotalPage() != 1 {
            let lastElement = _data.getRecord().count - 1
            // Current is the last element
            if indexPath.row == lastElement {
                self._page += 1
                // Page less than total page
                if self._page <= _data.getTotalPage() {
                    self.requestData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self._data.getRecord().count > indexPath.row {
            self.openDetail(id: self._data.getRecord()[indexPath.row].id)
        }
    }
}
