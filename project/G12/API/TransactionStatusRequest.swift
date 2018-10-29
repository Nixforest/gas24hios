//
//  TransactionStatusRequest.swift
//  project
//  P0078_TransactionStatus_API
//  Created by SPJ on 9/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class TransactionStatusRequest: BaseRequest {
    private static var _count:      Int = 0
    /**
     * Set data content
     * - parameter id:    Id of transaction
     */
    func setData(id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_TRANSACTION_ID, id,
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request transaction status
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter id:    Id of transaction
     */
    public static func request(action: Selector, view: BaseViewController, id: String) {
        let request = TransactionStatusRequest(url: G12Const.PATH_ORDER_TRANSACTION_LIST,
                                       reqMethod: DomainConst.HTTP_POST_REQUEST,
                                       view: view)
        request.setData(id: id)
        request.setFlagShowError(value: false)
        print("TransactionStatusRequest: \(_count)")
        _count += 1
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: false)
    }
    
    //++ BUG0156-SPJ (NguyenPT 20170925) Re-design Gas24h
    /**
     * Request transaction status loop
     * - parameter view:        Current view
     * - parameter id:          Id of transaction
     * - parameter completionHandler:      Action execute when finish this task
     */
    public static func requestLoop(view: BaseViewController, id: String,
                                   completionHandler: ((Any?) -> Void)?, isShowLoading: Bool = false) {
        let request = TransactionStatusRequest(url: G12Const.PATH_ORDER_TRANSACTION_LIST,
                                               reqMethod: DomainConst.HTTP_POST_REQUEST,
                                               view: view)
        request.setData(id: id)
        request.completionBlock = completionHandler
        request.setFlagShowError(value: false)
        print("TransactionStatusRequest: \(_count)")
        _count += 1
        request.execute(isShowLoadingView: isShowLoading)
    }
    //-- BUG0156-SPJ (NguyenPT 20170925) Re-design Gas24h
}
