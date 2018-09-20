//
//  ReferInfoBean.swift
//  project
//
//  Created by SPJ on 10/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class ReferInfoBean: ConfigBean {
    var is_invited:     Bool    = false
    var invite_code:    String  = DomainConst.BLANK
    var current_point:  String  = DomainConst.NUMBER_ZERO_VALUE
    var invited_list:   [ReferInvitedModel] = [ReferInvitedModel]()
    
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init()
        // Id
        if let idStr = jsonData[DomainConst.KEY_ID] as? String {
            self.id = idStr
        } else {
            if let idInt = jsonData[DomainConst.KEY_ID] as? Int {
                self.id = String(idInt)
            }
        }
        self.is_invited = jsonData[DomainConst.KEY_IS_INVITED] as? Bool ?? false
        self.invite_code = getString(json: jsonData, key: DomainConst.KEY_INVITED_CODE)
        self.current_point = getString(json: jsonData, key: DomainConst.KEY_CURRENT_POINT)
        
        // Invited list
        if let list = jsonData[DomainConst.KEY_INVITED_LIST] as? [[String: AnyObject]] {
            for item in list {
                self.invited_list.append(ReferInvitedModel(jsonData: item))
            }
        }
    }
    public override init() {
        super.init()
    }
}
