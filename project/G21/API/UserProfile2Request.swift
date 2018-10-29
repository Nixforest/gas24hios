//
//  UserProfileRequest.swift
//  project
//
//  Created by SPJ on 10/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class UserProfile2Request: BaseRequest{
    /**lo
     * Set data content
     * - parameter token:        Token
     * - parameter code_account :        String
     */
    public func setData(code_account: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%d\"}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            "code_account",code_account,
            DomainConst.KEY_PLATFORM, DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request Forecast View
     * - parameter action:              Action execute when finish this task
     * - parameter view:                Current view
     * - parameter code_account :       String
     */
    public static func request(action: Selector,
                               view: BaseViewController,code_account: String) {
        let request = UserProfile2Request(url: G21Const.PATH_USER_PROFILE,
                                      reqMethod: DomainConst.HTTP_POST_REQUEST,
                                      view: view)
        request.setData(code_account: code_account)
        NotificationCenter.default.addObserver(view, selector: action, name: NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
