//
//  OrderConfig.swift
//  project
//
//  Created by SPJ on 1/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class OrderConfigRequest: BaseRequest {
    /** Current agent id */
    var agent_id:           String      = DomainConst.NUMBER_ZERO_VALUE
    //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//    override func completetionHandler(request: NSMutableURLRequest) -> URLSessionTask {
//        let task = self.session.dataTask(with: request as URLRequest, completionHandler: {
//            (
//            data, response, error) in
//            // Check error
//            guard error == nil else {
//                self.showAlert(message: DomainConst.CONTENT00196)
//                return
//            }
//            guard let data = data else {
//                self.showAlert(message: DomainConst.CONTENT00196)
//                return
//            }
//            // Convert to string
//            let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//            print(dataString ?? "")
//            // Convert to object
//            let model: OrderConfigRespModel = OrderConfigRespModel(jsonString: dataString as! String)
//            if model.status == DomainConst.RESPONSE_STATUS_SUCCESS {
//                // Hide overlay
//                LoadingView.shared.hideOverlayView()
//                BaseModel.shared.saveOrderConfig(config: model.getRecord())
//                // Update data to MapViewController view (cross-thread)
//                DispatchQueue.main.async {
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: self.theClassName), object: model)
//                }
//            } else {
//                self.showAlert(message: model.message)
//                return
//            }
//        })
//        return task
//    }
    
    //override func execute() {
    override func execute(isShowLoadingView: Bool = true) {
        if isShowLoadingView {
            LoadingView.shared.showOverlay(view: self.view.view, className: self.theClassName)
        }
        var reqUrl = DomainConst.SERVER_URL + self.url
        reqUrl = "\(reqUrl)?\(DomainConst.KEY_FLAG_GAS_24H)=\(BaseModel.shared.getAppType())&\(DomainConst.KEY_AGENT_ID)=\(agent_id)"
//        let serverUrl: URL = URL(string: DomainConst.SERVER_URL + self.url)!
        let serverUrl: URL = URL(string: reqUrl)!
        let request = NSMutableURLRequest(url: serverUrl)
        request.httpMethod = self.reqMethod
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        // Make data string
        request.httpBody = self.data.data(using: String.Encoding.utf8)
        let task = completetionHandler(request: request)
        task.resume()
    }
    
//    /**
//     * Initializer
//     * - parameter url: URL
//     * - parameter reqMethod: Request method
//     * - parameter view: Root view
//     */
//    override init(url: String, reqMethod: String, view: BaseViewController) {
//        super.init(url: url, reqMethod: reqMethod, view: view)
//    }
    //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    
    /**
     * Set data content
     * - parameter page:    Page index
     */
    func setData() {
        self.data = "q=" + String.init(
//            format: "{\"%@\":%@}",
//            DomainConst.KEY_FLAG_GAS_24H, BaseModel.shared.getAppType()
            format: "{}"
        )
    }
    
    /**
     * Request order list function
     * - parameter page:    Page index
     */
    public static func requestOrderConfig(action: Selector, view: BaseViewController,
                                          agentId: String = DomainConst.NUMBER_ZERO_VALUE) {
//        // Show overlay
//        LoadingView.shared.showOverlay(view: view.view)
        let request = OrderConfigRequest(url: G04Const.PATH_ORDER_CONFIG,
                                       reqMethod: DomainConst.HTTP_POST_REQUEST,
                                       view: view)
        request.setData()
        request.agent_id = agentId
        NotificationCenter.default.addObserver(view, selector: action, name: NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
