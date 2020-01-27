//
//  Payments.swift
//  Ticket
//
//  Created by Алексей Морозов on 26.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

class Payments: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var date = Date()
    @objc dynamic var value = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, date: Date, value: Int) {
        self.init()
        self.id = id
        self.date = date
        self.value = value
    }
    
}
