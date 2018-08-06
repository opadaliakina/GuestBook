//
//  Answer.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 30.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation
import ObjectMapper

class Answer: Mappable {
    var title: String = ""
    var message: String = ""
    
    required init?(map: Map) {
        
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        message <- map["message"]
    }
}
