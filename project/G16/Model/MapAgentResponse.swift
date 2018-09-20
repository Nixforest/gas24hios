//
//  MapAgentResponse.swift
//  project
//
//  Created by Lâm Phạm on 4/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class MapAgentResponse: BaseRespModel {
    
    var listAgent: [AgentInfoBean] = []
    var isAllowSearch: Bool = false
    override init() {
        super.init()
    }
    
    /**
     * Initializer
     */
    override init(jsonString: String) {
        // Call super initializer
        super.init(jsonString: jsonString)
        
        // Start parse
        if let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: AnyObject]
                
//                if self.status != DomainConst.RESPONSE_STATUS_SUCCESS {
//                    return
//                }
                
                // Record
                if let order = json[DomainConst.KEY_RECORD] as? [String: AnyObject] {
                    if let allow = order[DomainConst.KEY_ALLOW_SEARCH] as? Int {
                        if allow == 1 {
                            self.isAllowSearch = true
                        }
                    }
                    if let list = order[DomainConst.KEY_AGENT] as? [[String: AnyObject]] {
                        for item in list {
                            let agent = AgentInfoBean(jsonData: item)
                            self.listAgent.append(agent)
                        }
                    }
                }
//                self.record = OrderConfigBean(jsonData: order!)
            } catch let error as NSError {
                print(DomainConst.JSON_ERR_FAILED_LOAD + "\(error.localizedDescription)")
            }
            
        } else {
            print(DomainConst.JSON_ERR_WRONG_FORMAT)
        }
    }
    
    /**
     * Get record value.
     * - returns: Record value
     */
    public func getRecord() -> [AgentInfoBean] {
        return self.listAgent
    }
    
}
