//
//  SetTimerRequest.swift
//  project
//
//  Created by SPJ on 10/3/18.
//  Copyright © 2018 admin. All rights reserved.
//
import UIKit
import harpyframework
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
class SetTimerRequest: BaseRequest{
    /**lo
     * Set data content
     * - parameter token:        Token
     * - parameter days :        String
     * - parameter hour:         String
     * - parameter latitude:     String
     * - parameter longitude:    String
     */
    func setData(days: String, hour : String, latitude : String, longitude : String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%d\"}",
            DomainConst.KEY_TOKEN, BaseModel.shared.getUserToken(),
            DomainConst.KEY_DAYS,days,
            DomainConst.KEY_HOUR,hour,
            DomainConst.KEY_LATITUDE,latitude,
            DomainConst.KEY_LONGITUDE,longitude,
            DomainConst.KEY_PLATFORM, DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request Forecast View
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter days :        String
     * - parameter hour:         String
     * - parameter latitude:     String
     * - parameter longitude:    String
     */
    public static func request(action: Selector,
                               view: BaseViewController,days: String, hour : String, latitude : String, longitude : String) {
        let request = SetTimerRequest(url: G20Const.PATH_SET_TIMER,
                                          reqMethod: DomainConst.HTTP_POST_REQUEST,
                                          view: view)
        request.setData(days: days, hour: hour, latitude: latitude, longitude: longitude)
        NotificationCenter.default.addObserver(view, selector: action, name: NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
