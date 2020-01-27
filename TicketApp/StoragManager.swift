//
//  StorageManager.swift
//  Ticket
//
//  Created by Алексей Морозов on 21.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StoragManager {
    
    static func saveTicket(_ ticket: Tickets) {
        try! realm.write {
            realm.add(ticket)
        }
    }
    
    static func saveTrip(_ trip: Trips) {
        try! realm.write {
            realm.add(trip)
        }
    }
    
    static func saveGroup(_ group: Groups) {
        try! realm.write {
            realm.add(group)
        }
    }
    
    static func addItem(objs: Object) {
        try? realm.write ({
            realm.add(objs)
        })
    }
    
    static func deleteItem(objs: Object) {
        try? realm.write ({
            realm.delete(objs)
        })
    }
    
    static func findById<T>(id: Int, model: T.Type) -> Object {
        return realm.objects(model as! Object.Type).filter("id == \(id)").first!
    }
    
    static func incrementID<T>(model: T.Type) -> Int {
        return (realm.objects(model as! Object.Type).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
