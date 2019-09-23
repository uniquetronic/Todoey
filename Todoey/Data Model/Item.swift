//
//  Item.swift
//  Todoey
//
//  Created by Josip on 9/21/19.
//  Copyright © 2019 Josip. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
