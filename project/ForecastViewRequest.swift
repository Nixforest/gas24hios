//
//  ForecastViewRequest.swift
//  project
//
//  Created by SPJ on 9/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

public class ForecastViewRequest: BaseRequest{
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
        let request = ForecastViewRequest(url: G20Const.PATH_FORECAST_VIEW,
                                                 reqMethod: DomainConst.HTTP_POST_REQUEST,
                                                 view: view)
        request.setData()
        NotificationCenter.default.addObserver(view, selector: action, name: NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
