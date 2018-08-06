//
//  User.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 30.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var id: Int?
    var name: String?
    var email: String?
    var password: String?
    var token: String?
    var isAdmin: Bool = false
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        token <- map["api_token"]
        isAdmin <- map["is_admin"]
    }
}
