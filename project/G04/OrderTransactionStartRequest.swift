//
//  OrderTransactionStart.swift
//  project
//
//  Created by SPJ on 1/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class OrderTransactionStartRequest: BaseRequest {
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
//            let model: OrderTransactionStartRespModel = OrderTransactionStartRespModel(jsonString: dataString as! String)
//            if model.status == DomainConst.RESPONSE_STATUS_SUCCESS {
//                //++ BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
////                // Hide overlay
////                LoadingView.shared.hideOverlayView()
//                // Set data
//                BaseModel.shared.setTransactionData(transaction: model.getRecord())
////                // Handle completion
////                DispatchQueue.main.async {
////                    NotificationCenter.default.post(name: Notification.Name(rawValue: self.theClassName), object: model)
////                }
//                self.handleCompleteTask(model: model)
//                //-- BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
//            } else {
//                self.showAlert(message: model.message)
//                return
//            }
//        })
//        return task
//    }
//    
//    /**
//     * Initializer
//     * - parameter url:         URL
//     * - parameter reqMethod:   Request method
//     * - parameter view:        Current view
//     */
//    override init(url: String, reqMethod: String, view: BaseViewController) {
//        super.init(url: url, reqMethod: reqMethod, view: view)
//    }
    //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    
    /**
     * Set data content
     */
    func setData() {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_PLATFORM,               DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request order list function
     * - parameter action:  Completion handler
     * - parameter view:    Current view controller
     */
    public static func requestOrderTransactionStart(action: Selector, view: BaseViewController) {
//        // Show overlay
//        LoadingView.shared.showOverlay(view: view.view)
        let request = OrderTransactionStartRequest(url: G04Const.PATH_ORDER_TRANSACTION_START,
                                                   reqMethod: DomainConst.HTTP_POST_REQUEST,
                                                   view: view)
        request.setData()
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: false)
    }
}
