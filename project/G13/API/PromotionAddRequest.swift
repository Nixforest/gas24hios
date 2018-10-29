//
//  PromotionAddRequest.swift
//  project
//
//  Created by SPJ on 10/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class PromotionAddRequest: BaseRequest {
    /**
     * Set data content
     * - parameter code:        Code
     */
    func setData(code: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,      BaseModel.shared.getUserToken(),
            DomainConst.KEY_CODE,       code,
            DomainConst.KEY_LATITUDE,   String(G12F01S01VC._currentPos.latitude),
            DomainConst.KEY_LONGITUDE,  String(G12F01S01VC._currentPos.longitude),
            DomainConst.KEY_PLATFORM,   DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request transaction status
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter code:        Code
     */
    public static func request(action: Selector, view: BaseViewController,
                               code: String) {
        let request = PromotionAddRequest(url: G13Const.PATH_PROMOTION_ADD,
                                       reqMethod: DomainConst.HTTP_POST_REQUEST,
                                       view: view)
        request.setData(code: code)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
