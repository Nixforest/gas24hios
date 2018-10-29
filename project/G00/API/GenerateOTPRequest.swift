//
//  GenerateOTPRequest.swift
//  project
//  P0079_GenerateOTP_API
//  Created by SPJ on 10/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class GenerateOTPRequest: BaseRequest {
    /**
     * Set data content
     * - parameter phone:    Phone number
     */
    func setData(phone: String) {
        //++ BUG0198-SPJ (NguyenPT 20180530) Get device information
        var identifierForVendor = DomainConst.BLANK
        if let identify = UIDevice.current.identifierForVendor {
            identifierForVendor = identify.description
        }
        //-- BUG0198-SPJ (NguyenPT 20180530) Get device information
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_PHONE,      phone,
            //++ BUG0199-SPJ (NguyenPT 20180530) Add device token
            DomainConst.KEY_APNS_DEVICE_TOKEN, BaseModel.shared.checkDeviceTokenExist() ? BaseModel.shared.getDeviceToken() : "A7CA1E1F8434EE8D5E62264B22D29D64B7A3AC04E03899E6926503643FD07EC6",
            //-- BUG0199-SPJ (NguyenPT 20180530) Add device token
            //++ BUG0198-SPJ (NguyenPT 20180530) Get device information
            DomainConst.KEY_DEVICE_NAME, UIDevice.current.model,
            DomainConst.KEY_DEVICE_IMEI, identifierForVendor,
            DomainConst.KEY_DEVICE_OS_VERSION, "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
            //-- BUG0198-SPJ (NguyenPT 20180530) Get device information
            DomainConst.KEY_PLATFORM,   DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request generate OTP
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter phone:       Phone number
     */
    public static func request(action: Selector, view: BaseViewController,
                               phone: String) {
        let request = GenerateOTPRequest(
            url: G00Const.PATH_CUSTOMER_GENERATE_OTP,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(phone: phone)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
