//
//  UserProfile2ResModel.swift
//  project
//
//  Created by SPJ on 10/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class UserProfile2ResModel: BaseRespModel{
    /** Record */
    var record: UserProfileBean = UserProfileBean()
    
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
                if let str = json[DomainConst.KEY_RECORD] as? [String: AnyObject]{
                    self.record = UserProfileBean(jsonData: str)
                }
            } catch let error as NSError {
                print(DomainConst.JSON_ERR_FAILED_LOAD + "\(error.localizedDescription)")
            }
            
        } else {
            print(DomainConst.JSON_ERR_WRONG_FORMAT)
        }
    }
}
