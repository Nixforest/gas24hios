//
//  DeleteTimerRequest.swift
//  project
//
//  Created by SPJ on 10/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
class DeleteTimerRequest: BaseRequest{
    /**
     * Set data content
     * - parameter token:        Token
     * - parameter token:        id
     */
    func setData(id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%d\"}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID, id,
            DomainConst.KEY_PLATFORM, DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request Forecast View
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter token:        id
     */
    public static func request(action: Selector,
                               view: BaseViewController,id: String) {
        let request = DeleteTimerRequest(url: G20Const.PATH_DELETE_ORDER,
                                            reqMethod: DomainConst.HTTP_POST_REQUEST,
                                            view: view)
        request.setData(id: id)
        NotificationCenter.default.addObserver(view, selector: action, name: NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
