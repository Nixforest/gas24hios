//
//  RatingRequest.swift
//  project
//  P0081_RatingEmployee_API
//  Created by SPJ on 10/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class RatingRequest: BaseRequest {
    /**
     * Set data content
     * - parameter id:          Id of order
     * - parameter rating:      Rating value
     * - parameter comment:     Comment of customer
     */
    func setData(id: String, rating: Int, comment: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,             id,
            DomainConst.KEY_RATING,         String(rating),
            DomainConst.KEY_RATING_COMMENT, comment,
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request transaction status
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter id:          Id of order
     * - parameter rating:      Rating value
     * - parameter comment:     Comment of customer
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String,
                               rating: Int, comment: String) {
        let request = RatingRequest(url: G12Const.PATH_ORDER_TRANSACTION_RATING,
                                               reqMethod: DomainConst.HTTP_POST_REQUEST,
                                               view: view)
        request.setData(id: id, rating: rating, comment: comment)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
