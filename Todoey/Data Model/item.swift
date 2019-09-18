//
//  item.swift
//  Todoey
//
//  Created by Josip on 9/18/19.
//  Copyright © 2019 Josip. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {  //Since Swift 4, Codable can be used instead of Encodable & Decodable
    var title: String = ""
    var done: Bool = false
    
}
