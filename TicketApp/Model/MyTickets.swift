//
//  MyTickets.swift
//  Ticket
//
//  Created by Алексей Морозов on 23.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

class MyTickets: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var ticket_id: Tickets?
    @objc dynamic var date = Date()
    @objc dynamic var active = Bool()
    let trips = LinkingObjects(fromType: Trips.self, property: "ticket_id")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, ticket_id: Tickets!, date: Date, active: Bool) {
        self.init()
        self.id = id
        self.ticket_id = ticket_id
        self.date = date
        self.active = active
    }
    
}
