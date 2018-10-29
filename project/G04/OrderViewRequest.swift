//
//  OrderViewRequest.swift
//  project
//
//  Created by SPJ on 12/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

class OrderViewRequest: BaseRequest {
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
//            let model: OrderViewRespModel = OrderViewRespModel(jsonString: dataString as! String)
//            if model.status == DomainConst.RESPONSE_STATUS_SUCCESS {
//                self.handleCompleteTask(model: model)
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
     * - parameter id:    Order id
     */
    func setData(id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_TRANSACTION_HISTORY_ID, id,
            DomainConst.KEY_PLATFORM,               DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request order view function
     * - parameter id:    Order id
     */
    public static func requestOrderView(action: Selector, view: BaseViewController,
                                        id: String) {
//        // Show overlay
//        LoadingView.shared.showOverlay(view: view.view)
        let request = OrderViewRequest(url: G04Const.PATH_ORDER_TRANSACTION_VIEW,
                                       reqMethod: DomainConst.HTTP_POST_REQUEST,
                                       view: view)
        request.setData(id: id)
        
        // Notify set data
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
