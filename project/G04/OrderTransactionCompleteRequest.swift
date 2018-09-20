//
//  OrderTransactionCompleteRequest.swift
//  project
//
//  Created by SPJ on 2/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class OrderTransactionCompleteRequest: BaseRequest {
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
//            let model: OrderTransactionCompleteRespModel = OrderTransactionCompleteRespModel(jsonString: dataString as! String)
//            if model.status == DomainConst.RESPONSE_STATUS_SUCCESS {
//                //++ BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
////                // Hide overlay
////                LoadingView.shared.hideOverlayView()
////                // Handle completion
////                DispatchQueue.main.async {
////                    NotificationCenter.default.post(name: Notification.Name(rawValue: self.theClassName), object: model.getRecord())
////                }
//                self.handleCompleteTask(model: model.getRecord())
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
    func setData(key: String, id: String, devicePhone: String,
                 firstName: String, phone: String, email: String,
                 provinceId: String, districtId: String, wardId: String,
                 streetId: String, houseNum: String, note: String,
                 address: String, orderDetail: String, lat: String,
                 long: String, agentId: String, transactionType: String,
                 isReview: Bool = false) {
        var review = 0
        if isReview {
            review = 1
        }
        if isReview {
            self.data = "q=" + String.init(
                format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":[%@],\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%d\",\"%@\":%d}",
                DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
                DomainConst.KEY_SESSION_KEY,    key,
                DomainConst.KEY_SESSION_ID,     id,
                DomainConst.KEY_DEVICE_PHONE,       devicePhone,
                DomainConst.KEY_FIRST_NAME,         firstName,
                DomainConst.KEY_PHONE,              phone,
                DomainConst.KEY_EMAIL,              email,
                DomainConst.KEY_PROVINCE_ID,        provinceId,
                DomainConst.KEY_DISTRICT_ID,        districtId,
                DomainConst.KEY_WARD_ID,            wardId,
                DomainConst.KEY_STREET_ID,          streetId,
                DomainConst.KEY_HOUSE_NUMBER,       houseNum,
                DomainConst.KEY_NOTE,               note,
                DomainConst.KEY_GOOGLE_ADDRESS,     address,
                DomainConst.KEY_ORDER_DETAIL,       orderDetail,
                DomainConst.KEY_LATITUDE,           lat,
                DomainConst.KEY_LONGITUDE,          long,
                DomainConst.KEY_AGENT_ID,           agentId,
                DomainConst.KEY_TRANSACTION_TYPE,   transactionType,
                DomainConst.KEY_REVIEW,             review,
                DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
                
            )
        } else {
            self.data = "q=" + String.init(
                format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":[%@],\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
                DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
                DomainConst.KEY_SESSION_KEY,    key,
                DomainConst.KEY_SESSION_ID,     id,
                DomainConst.KEY_DEVICE_PHONE,       devicePhone,
                DomainConst.KEY_FIRST_NAME,         firstName,
                DomainConst.KEY_PHONE,              phone,
                DomainConst.KEY_EMAIL,              email,
                DomainConst.KEY_PROVINCE_ID,        provinceId,
                DomainConst.KEY_DISTRICT_ID,        districtId,
                DomainConst.KEY_WARD_ID,            wardId,
                DomainConst.KEY_STREET_ID,          streetId,
                DomainConst.KEY_HOUSE_NUMBER,       houseNum,
                DomainConst.KEY_NOTE,               note,
                DomainConst.KEY_GOOGLE_ADDRESS,     address,
                DomainConst.KEY_ORDER_DETAIL,       orderDetail,
                DomainConst.KEY_LATITUDE,           lat,
                DomainConst.KEY_LONGITUDE,          long,
                DomainConst.KEY_AGENT_ID,           agentId,
                DomainConst.KEY_TRANSACTION_TYPE,   transactionType,
                DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
                
            )
        }
        
    }
    
    /**
     * Request order list function
     * - parameter action:  Completion handler
     * - parameter view:    Current view controller
     */
    public static func requestOrderTransactionComplete(
        action: Selector, view: BaseViewController,
        key: String, id: String, devicePhone: String,
        firstName: String, phone: String, email: String,
        provinceId: String, districtId: String, wardId: String,
        streetId: String, houseNum: String, note: String,
        address: String, orderDetail: String, lat: String,
        long: String, agentId: String, transactionType: String,
        isReview: Bool = false) {
//        // Show overlay
//        LoadingView.shared.showOverlay(view: view.view)
        let request = OrderTransactionCompleteRequest(url: G04Const.PATH_ORDER_TRANSACTION_COMPLETE,
                                                   reqMethod: DomainConst.HTTP_POST_REQUEST,
                                                   view: view)
        request.setData(key: key, id: id, devicePhone: devicePhone, firstName: firstName, phone: phone, email: email, provinceId: provinceId, districtId: districtId, wardId: wardId, streetId: streetId, houseNum: houseNum, note: note, address: address, orderDetail: orderDetail, lat: lat, long: long, agentId: agentId, transactionType: transactionType, isReview: isReview)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: true)
    }
}
