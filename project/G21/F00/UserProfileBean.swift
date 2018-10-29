//
//  UserProfileBean.swift
//  project
//
//  Created by SPJ on 10/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

public class UserProfileBean: ConfigBean {
    public var link_image:                      String = DomainConst.BLANK
    /** Last Order */
    public var code_account:                    String = DomainConst.BLANK
    /** Last Order */
    public var first_name:                      String = DomainConst.BLANK
    /** Last Order */
    public var role_id:                         String = DomainConst.BLANK
    
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        self.id                     = getString(json: jsonData, key: DomainConst.KEY_ID)
        self.link_image             = getString(json: jsonData, key: "link_image")
        self.code_account           = getString(json: jsonData, key: "code_account")
        self.first_name             = getString(json: jsonData, key: "first_name")
        self.role_id                = getString(json: jsonData, key: "role_id")
    }
    
    override init() {
        super.init()
    }
}
