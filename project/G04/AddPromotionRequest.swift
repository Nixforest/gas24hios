//
//  AddPromotionRequest.swift
//  project
//
//  Created by SPJ on 2/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class AddPromotionRequest: BaseRequest {
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
//            let model: BaseRespModel = BaseRespModel(jsonString: dataString as! String)
//            
//            //++ BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
////            // Hide overlay
////            LoadingView.shared.hideOverlayView()
////            // Handle completion
////            DispatchQueue.main.async {
////                NotificationCenter.default.post(name: Notification.Name(rawValue: self.theClassName), object: model)
////            }
//            self.handleCompleteTask(model: model)
//            //-- BUG0046-SPJ (NguyenPT 20170303) Use action for Request server completion
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
     * - parameter code:    Promotion code
     */
    func setData(code: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_CODE, code,
            DomainConst.KEY_PLATFORM,               DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request promotion list function
     * - parameter action:  Handler compeletion
     * - parameter view:    Current view
     * - parameter code:    Promotion code
     */
    public static func requestAddPromotion(action: Selector, view: BaseViewController, code: String) {
//        // Show overlay
//        LoadingView.shared.showOverlay(view: view.view)
        let request = AddPromotionRequest(url: G04Const.PATH_CUSTOMER_PROMOTION_ADD,
                                           reqMethod: DomainConst.HTTP_POST_REQUEST,
                                           view: view)
        request.setData(code: code)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
