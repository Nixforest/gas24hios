//
//  GetNearestAgentRespBean.swift
//  project
//
//  Created by Pham Trung Nguyen on 2/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class GetNearestAgentRespBean: BaseRespModel {
    /** Record */
    var record:     AgentInfoBean = AgentInfoBean()

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
                
                if self.status != DomainConst.RESPONSE_STATUS_SUCCESS {
                    return
                }
                
                // Record
                if let data = json[DomainConst.KEY_RECORD] as? [String: AnyObject] {
                    self.record = AgentInfoBean(jsonData: data)
                }
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
    public func getRecord() -> AgentInfoBean {
        return self.record
    }
}
