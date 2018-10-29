//
//  NewsViewRequest.swift
//  project
//
//  Created by Pham Trung Nguyen on 4/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class NewsViewRequest: BaseRequest {
    /**
     * Set data content
     */
    func setData(id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,      BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,         id,
            DomainConst.KEY_PLATFORM,   DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request transaction status
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String) {
        let request = NewsViewRequest(
            url: DomainConst.PATH_NEWS_VIEW,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
