//
//  Trips.swift
//  Ticket
//
//  Created by Алексей Морозов on 23.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

class Trips: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var type = Int()
    @objc dynamic var date = Date()
    @objc dynamic var ticket_id: MyTickets?
    @objc dynamic var transport_id: Transports?
    @objc dynamic var price = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, type: Int, date: Date, ticket_id: MyTickets!, transport_id: Transports!, price: Int) {
        self.init()
        self.id = id
        self.type = type
        self.date = date
        self.ticket_id = ticket_id
        self.transport_id = transport_id
        self.price = price
    }
    
}
