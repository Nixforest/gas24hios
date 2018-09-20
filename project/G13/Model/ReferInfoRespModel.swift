//
//  ReferInfoRespModel.swift
//  project
//
//  Created by SPJ on 10/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class ReferInfoRespModel: BaseRespModel {
    // MARK: Properties
    var record: ReferInfoBean = ReferInfoBean()
    
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
                if let order = json[DomainConst.KEY_RECORD] as? [String: AnyObject] {
                    self.record = ReferInfoBean(jsonData: order)
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
    public func getRecord() -> ReferInfoBean {
        return self.record
    }
}
