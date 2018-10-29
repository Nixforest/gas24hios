//
//  PromotionListRespModel.swift
//  project
//
//  Created by SPJ on 2/8/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class PromotionListRespModel: BaseRespModel {
    /** Total record */
    var total_record: Int = 0
    /** Total page */
    var total_page: Int = 0
    /** Record */
    var record: [PromotionBean] = [PromotionBean]()
    
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
                // Total record
                self.total_record = getIntFromString(json: json, key: DomainConst.KEY_TOTAL_RECORD)
                // Total page
                self.total_page = getInt(json: json, key: DomainConst.KEY_TOTAL_PAGE)
                
                // Record
                let recordList = json[DomainConst.KEY_RECORD] as? [[String: AnyObject]]
                for uphold in recordList! {
                    self.record.append(PromotionBean(jsonData: uphold))
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
    public func getRecord() -> [PromotionBean] {
        return self.record
    }
    
    /**
     * Append list of record
     * - parameter contentOf: List of record
     */
    public func append(contentOf: [PromotionBean]) {
        self.record.append(contentsOf: contentOf)
    }
    
    /**
     * Remove all data
     */
    public func clearData() {
        self.record.removeAll()
        self.total_page     = 0
        self.total_record   = 0
    }
}
