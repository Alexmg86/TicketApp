//
//  Transports.swift
//  Ticket
//
//  Created by Алексей Морозов on 23.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

class Transports: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    let itemsArray = [
        ["id": 1, "name": "Автобус"],
        ["id": 2, "name": "Троллейбус"],
        ["id": 3, "name": "Трамвай"],
        ["id": 4, "name": "Метро"],
        ["id": 5, "name": "МЦД"]
    ]
    
    func saveItems() {
        for item in itemsArray {
            let newItem = Transports(id: item["id"] as! Int, name: item["name"] as! String)
            StoragManager.addItem(objs: newItem)
        }
    }
    
}
