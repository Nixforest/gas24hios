//
//  OrderViewRespModel.swift
//  project
//
//  Created by SPJ on 12/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

class OrderViewRespModel: BaseRespModel {
    /** Record */
    var record: OrderBean = OrderBean()
    
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
                //++ BUG0156-SPJ (NguyenPT 20170925) Re-design Gas24h
//                let order = json[DomainConst.KEY_RECORD] as? [String: AnyObject]
//                
//                self.record = OrderBean(jsonData: order!)
                if let order = json[DomainConst.KEY_RECORD] as? [String: AnyObject] {
                    self.record = OrderBean(jsonData: order)
                }
                //-- BUG0156-SPJ (NguyenPT 20170925) Re-design Gas24h
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
    public func getRecord() -> OrderBean {
        return self.record
    }
}
