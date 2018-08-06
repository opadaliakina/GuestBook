//
//  Comment.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 30.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
    var title: String = ""
    var message: String = ""
    var id: Int?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        id <- map["comment_id"]
        if id == nil {
            id <- map["id"]
        }
        title <- map["title"]
        message <- map["message"]
    }
}
