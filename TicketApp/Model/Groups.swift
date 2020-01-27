//
//  Groups.swift
//  Ticket
//
//  Created by Алексей Морозов on 22.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

class Groups: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    let tickets = LinkingObjects(fromType: Tickets.self, property: "group_id")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    let itemsArray = [
        ["id": 1, "name": "Билет «Кошелек»"],
        ["id": 2, "name": "Билет «Единый»"],
        ["id": 3, "name": "Билет «Единый» + «Пригород»"]
    ]
    
    func saveItems() {
        for item in itemsArray {
            let newItem = Groups(id: item["id"] as! Int, name: item["name"] as! String)
            StoragManager.addItem(objs: newItem)
        }
    }
}
