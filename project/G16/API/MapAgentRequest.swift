//
//  MapAgentRequest.swift
//  project
//
//  Created by Lâm Phạm on 4/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class MapAgentRequest: BaseRequest {
    /**
     * Set data content
     */
    func setData(id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\"}",
            DomainConst.KEY_TOKEN,      BaseModel.shared.getUserToken()
        )
    }
    
    /**
     * Request transaction status
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String) {
        let request = MapAgentRequest(
            url: DomainConst.PATH_MAP_AGENT,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
