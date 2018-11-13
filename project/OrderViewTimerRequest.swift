//
//  OrderViewTimerRequest.swift
//  project
//
//  Created by SPJ on 10/3/18.
//  Copyright © 2018 admin. All rights reserved.
//
import UIKit
import harpyframework
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
class OrderViewTimerRequest: BaseRequest{
    /**
     * Set data content
     * - parameter token:        Token
     */
    func setData() {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%d\"}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_PLATFORM, DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request Forecast View
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     */
    public static func request(action: Selector,
                               view: BaseViewController) {
        let request = OrderViewTimerRequest(url: G20Const.PATH_ORDER_VIEW_TIME,
                                      reqMethod: DomainConst.HTTP_POST_REQUEST,
                                      view: view)
        request.setData()
        NotificationCenter.default.addObserver(view, selector: action, name: NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
