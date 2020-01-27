//
//  TicketsModel.swift
//  Ticket
//
//  Created by Алексей Морозов on 23.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

class Tickets: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var group_id: Groups?
    @objc dynamic var name: String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var days: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, group_id: Groups!, name: String, price: Int, days: Int) {
        self.init()
        self.id = id
        self.group_id = group_id
        self.name = name
        self.price = price
        self.days = days
    }
    
    let itemsArray = [
        ["id": 1, "group_id": 2, "name": "60 поездок", "price": 1900, "days": 45],
        ["id": 2, "group_id": 2, "name": "1 сутки", "price": 230, "days": 1],
        ["id": 3, "group_id": 2, "name": "3 суток", "price": 438, "days": 3],
        ["id": 4, "group_id": 2, "name": "30 дней", "price": 2170, "days": 30],
        ["id": 5, "group_id": 2, "name": "90 дней", "price": 5430, "days": 90],
        ["id": 6, "group_id": 2, "name": "365 дней", "price": 19500, "days": 365],
        
        ["id": 7, "group_id": 3, "name": "1 сутки", "price": 285, "days": 1],
        ["id": 8, "group_id": 3, "name": "3 суток", "price": 545, "days": 3],
        ["id": 9, "group_id": 3, "name": "30 дней", "price": 2570, "days": 30],
        ["id": 10, "group_id": 3, "name": "90 дней", "price": 6940, "days": 90],
        ["id": 11, "group_id": 3, "name": "365 дней", "price": 24450, "days": 365]
        
    ]

    func saveItems() {
        for item in itemsArray {
            let group_id = StoragManager.findById(id: item["group_id"] as! Int, model: Groups.self) as? Groups
            let newItem = Tickets(id: item["id"] as! Int, group_id: group_id, name: item["name"] as! String, price: item["price"] as! Int, days: item["days"] as! Int)
            StoragManager.addItem(objs: newItem)
        }
    }
    
}
