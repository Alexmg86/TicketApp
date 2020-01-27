//
//  TripViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 21.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit
import RealmSwift

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var trips: Results<Trips>!
    
    let itemsArray = ["", "bus", "trollerbus", "tram", "train", "railway"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        trips = realm.objects(Trips.self).sorted(byKeyPath: "date", ascending: false)
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.isEmpty ? 0 : trips.count > 5 ? 5 : trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripViewCell
        let tripById = trips[indexPath.row]
        
        let ticketName = ((tripById.ticket_id) != nil) ? (tripById.ticket_id?.ticket_id?.group_id?.name)! + " на " + (tripById.ticket_id?.ticket_id?.name)! : ""
        cell.nameLabel?.text = ticketName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        cell.dateLabel?.text = dateFormatter.string(from: tripById.date)
        
        cell.transportLabel?.text = tripById.transport_id?.name
        cell.priceLabel?.text = tripById.price > 0 ? String(tripById.price) + " ₽" : ""
        
        cell.iconView.image = UIImage(named: itemsArray[tripById.transport_id!.id])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let myTripForDelete = trips[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { (action, sourceView, completionHandler) in
            StoragManager.deleteItem(objs: myTripForDelete)
            tableView.reloadData()
            completionHandler(false)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMytickets"), object: nil)
        return swipeAction
    }
    
    @IBAction func addTrip(_ sender: UIButton) {
        let number = Int.random(in: 1 ..< 6)
        
        let nextId = StoragManager.incrementID(model: Trips.self)
        let ticket_id = StoragManager.findById(id: 1, model: MyTickets.self) as? MyTickets
        let transport_id = StoragManager.findById(id: number, model: Transports.self) as? Transports
        let newTrip = Trips(id: nextId, type: 1, date: Date(), ticket_id: ticket_id!, transport_id: transport_id!, price: 0)
        StoragManager.addItem(objs: newTrip)
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMytickets"), object: nil)
    }

}
