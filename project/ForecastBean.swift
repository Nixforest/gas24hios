//
//  ForecastBean.swift
//  project
//
//  Created by SPJ on 9/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
public class ForecastBean: ConfigBean {
    /** Can Notify */
    public var can_notify:                  Int = 0
    /** Gas Percent */
    public var gas_percent:                 Int = 0
    /** Date Forecast */
    public var date_forecast:               String = DomainConst.BLANK
    /** Last Order */
    public var last_order:                  String = DomainConst.BLANK
    /** Last Order */
    public var rushHour:                    String = DomainConst.BLANK
    /** Last Order */
    public var rushHourText:                String = DomainConst.BLANK
    /** Last Order */
    public var bankDiscount:                String = DomainConst.BLANK
    /** Forecast Days*/
    public var days_forecast:               Int = 0
    /** Enable Bank*/
    public var enable_bank:                 Int = 0
    /** Enable Rush Hour*/
    public var enable_rush_hour:            Int = 0
    /** Enable Order*/
    public var can_order:                   Int = 0
    /** Enable Order*/
    public var max_days:                    Int = 0
    /** Enable Order*/
    public var min_hour:                    Int = 0
    /** Enable Order*/
    public var max_hour:                    Int = 0
    
    /** schedule*/
    public var schedule:               TimerBean = TimerBean()

    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        self.id                         = getString(json: jsonData, key: DomainConst.KEY_ID)
        self.can_notify                 = getInt(json: jsonData, key: DomainConst.KEY_CAN_NOTIFY)
        self.gas_percent                = getInt(json: jsonData, key: DomainConst.KEY_GAS_PERCENT)
        self.date_forecast              = getString(json: jsonData, key: DomainConst.KEY_DATE_FORECAST)
        self.last_order                 = getString(json: jsonData, key: DomainConst.KEY_LAST_ORDER)
        self.days_forecast              = getInt(json: jsonData, key: DomainConst.KEY_DATES_FORECAST)
        self.rushHour                   = getString(json: jsonData, key: "rush_hour")
        self.bankDiscount               = getString(json: jsonData, key: "bank_discount")
        self.rushHourText               = getString(json: jsonData, key: "rush_hour_text")
        self.enable_bank                = getInt(json: jsonData, key: "enable_bank")
        self.enable_rush_hour           = getInt(json: jsonData, key: "enable_rush_hour")
        self.can_order                  = getInt(json: jsonData, key: "can_order")
        self.max_days                   = getInt(json: jsonData, key: "max_days")
        self.min_hour                   = getInt(json: jsonData, key: "min_hour")
        self.max_hour                   = getInt(json: jsonData, key: "max_hour")
        
        // Record
        if let str = jsonData[DomainConst.KEY_SCHEDULE] as? [String: AnyObject]{
            self.schedule = TimerBean(jsonData: str)
        }
    }
    
    override init() {
        super.init()
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
