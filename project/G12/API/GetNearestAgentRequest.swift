//
//  GetNearestAgentRequest.swift
//  project
//  P0092_GetNearestAgent_API
//  Created by Pham Trung Nguyen on 2/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class GetNearestAgentRequest: BaseRequest {
    /**
     * Set data content
     * - parameter lat:         Latitude
     * - parameter long:        Longitude
     */
    func setData(lat: String, long: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":%@,\"%@\":%@,\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,          BaseModel.shared.getUserToken(),
            DomainConst.KEY_LATITUDE,       lat,
            DomainConst.KEY_LONGITUDE,      long,
            DomainConst.KEY_FLAG_GAS_24H,   BaseModel.shared.getAppType(),
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request transaction status
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter lat:         Latitude
     * - parameter long:        Longitude
     */
    public static func request(action: Selector, view: BaseViewController,
                               lat: String,
                               long: String) {
        let request = GetNearestAgentRequest(url: G12Const.PATH_ORDER_GET_NEAREST_AGENT,
                                    reqMethod: DomainConst.HTTP_POST_REQUEST,
                                    view: view)
        request.setData(lat: lat, long: long)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
