//
//  Category.swift
//  Todoey
//
//  Created by Josip on 9/21/19.
//  Copyright © 2019 Josip. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //List is coming from Real which is similar to an Array
    
}

