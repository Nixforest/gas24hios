//
//  ReferInvitedModel.swift
//  project
//
//  Created by SPJ on 11/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class ReferInvitedModel: ConfigBean {
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init()
        self.id = getString(json: jsonData, key: DomainConst.KEY_STATUS)
        self.name = getString(json: jsonData, key: DomainConst.KEY_NAME)
    }
    
    /**
     * Default constructor
     */
    override public init() {
        super.init()
    }
}
