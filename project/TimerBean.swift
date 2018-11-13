//
//  TimerBean.swift
//  project
//
//  Created by SPJ on 10/3/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
public class TimerBean: ConfigBean {
    /** DAys */
    public var days:               String = DomainConst.BLANK
    /** Hour */
    public var hour:               String = DomainConst.BLANK
    /** Date */
    public var date:               String = DomainConst.BLANK
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        self.id                   = getString(json: jsonData, key: DomainConst.KEY_ID)
        self.days                 = String(getInt(json: jsonData, key: DomainConst.KEY_DAYS))
        self.hour                 = String(getInt(json: jsonData, key: DomainConst.KEY_HOUR))
        self.date                 = getString(json: jsonData, key: DomainConst.KEY_DATE)
        
        
    }
    
    override init() {
        super.init()
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
