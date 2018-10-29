//
//  GetReferInfoRequest.swift
//  project
//
//  Created by SPJ on 8/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class GetReferInfoRequest: BaseRequest {
    /**
     * Set data content
     */
    func setData() {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,      BaseModel.shared.getUserToken(),
            DomainConst.KEY_PLATFORM,   DomainConst.PLATFORM_IOS
        )
    }
    
    public static func request(action: Selector,
                               view: BaseViewController) {
        let req = GetReferInfoRequest(url: G04Const.PATH_REFERRAL_INFO,
                                      reqMethod: DomainConst.HTTP_POST_REQUEST,
                                      view: view)
        req.setData()
        NotificationCenter.default.addObserver(
            view, selector: action,
            name: NSNotification.Name(rawValue: req.theClassName),
            object: nil)
        req.execute()
    }
}
