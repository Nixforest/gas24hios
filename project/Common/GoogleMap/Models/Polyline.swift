//
//  Polyline.swift
//  TutorialGoogleMapsAnDirection
//
//  Created by Bùi Minh Tiến on 3/26/17.
//  Copyright © 2017 TienBM. All rights reserved.
//

import Foundation
import harpyframework

struct Polyline: Mappable {
    
    var points = ""
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        points  <- map["points"]
    }
    
}
