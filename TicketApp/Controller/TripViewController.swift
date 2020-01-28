//
//  TripViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 21.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit
import RealmSwift

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transportCollectionView: UICollectionView!
    
    var trips: Results<Trips>!
    var transports: Results<Transports>!
    var selectedTransport: Int = 0
    var selectedTicket: Int = 0
    var selectedBalance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.transportCollectionView.delegate = self
        self.transportCollectionView.dataSource = self
        trips = realm.objects(Trips.self).sorted(byKeyPath: "date", ascending: false)
        transports = realm.objects(Transports.self)
        self.notificationLabel.isHidden = trips.isEmpty ? false : true
        self.tableView.tableFooterView = UIView()
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
        
        cell.iconView.image = UIImage(named: transports[tripById.transport_id!.id].iconName)
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = transportCollectionView.dequeueReusableCell(withReuseIdentifier: "transportColCell", for: indexPath) as! TransportIconViewCell

        cell.transportImage.image = UIImage(named: transports[indexPath.row].iconName)
        cell.transportName.text = transports[indexPath.row].name
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = transportCollectionView.cellForItem(at: indexPath) as? TransportIconViewCell {
            cell.contentView.backgroundColor = UIColor(red: 94/255, green: 186/255, blue: 125/255, alpha: 0.2)
        }
        if selectedTransport != indexPath.row + 1 {
            selectedTransport = indexPath.row + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = transportCollectionView.cellForItem(at: indexPath) as? TransportIconViewCell {
            cell.contentView.backgroundColor = nil
        }
    }

}
