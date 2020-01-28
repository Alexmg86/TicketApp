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
    @objc dynamic var iconName: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String, iconName: String) {
        self.init()
        self.id = id
        self.name = name
        self.iconName = iconName
    }
    
    let itemsArray = [
        ["id": 1, "name": "Автобус", "iconName": "bus"],
        ["id": 2, "name": "Троллейбус", "iconName": "trollerbus"],
        ["id": 3, "name": "Трамвай", "iconName": "tram"],
        ["id": 4, "name": "Метро", "iconName": "train"],
        ["id": 5, "name": "МЦД", "iconName": "railway"]
    ]
    
    func saveItems() {
        for item in itemsArray {
            let newItem = Transports(id: item["id"] as! Int, name: item["name"] as! String, iconName: item["iconName"] as! String)
            StoragManager.addItem(objs: newItem)
        }
    }
    
}
