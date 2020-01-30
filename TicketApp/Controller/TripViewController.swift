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
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceCollectionView: UICollectionView!
    @IBOutlet weak var ticketsLabel: UILabel!
    @IBOutlet weak var myTicketCollectionView: UICollectionView!
    
    var trips: Results<Trips>!
    var transports: Results<Transports>!
    var payments: Results<Payments>!
    var myTickets: Results<MyTickets>!
    var selectedTransport: Int = 0
    var selectedMyTicket: Int = 0
    var selectedBalance: Int = 0
    
    let balanceArray = [38, 45, 59]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.transportCollectionView.delegate = self
        self.transportCollectionView.dataSource = self
        self.balanceCollectionView.delegate = self
        self.balanceCollectionView.dataSource = self
        self.myTicketCollectionView.delegate = self
        self.myTicketCollectionView.dataSource = self

        trips = realm.objects(Trips.self).sorted(byKeyPath: "date", ascending: false)
        transports = realm.objects(Transports.self)
        payments = realm.objects(Payments.self)
        myTickets = realm.objects(MyTickets.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tripReloadMytickets), name: NSNotification.Name(rawValue: "tripReloadMytickets"), object: nil)
        
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
        
        let ticketName = ((tripById.ticket_id) != nil) ? (tripById.ticket_id?.ticket_id?.group_id?.name)! + " на " + (tripById.ticket_id?.ticket_id?.name)! : "Кошелёк"
        cell.nameLabel?.text = ticketName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        cell.dateLabel?.text = dateFormatter.string(from: tripById.date)
        
        cell.transportLabel?.text = tripById.transport_id?.name
        cell.priceLabel?.text = tripById.price > 0 ? "-" + String(tripById.price) + "₽" : ""
        
        cell.iconView.image = UIImage(named: transports[tripById.transport_id!.id-1].iconName)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.transportCollectionView {
            return transports.count
        } else if collectionView == self.balanceCollectionView {
            return 3
        } else {
            return myTickets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.transportCollectionView {
            let cell = transportCollectionView.dequeueReusableCell(withReuseIdentifier: "transportColCell", for: indexPath) as! TransportIconViewCell
            cell.transportImage.image = UIImage(named: transports[indexPath.row].iconName)
            cell.transportName.text = transports[indexPath.row].name
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            return cell
        } else if collectionView == self.balanceCollectionView {
            let cell = balanceCollectionView.dequeueReusableCell(withReuseIdentifier: "balancePayCell", for: indexPath) as! BalancePayCell
            cell.valueLabel.text = String(balanceArray[indexPath.row]) + " ₽"
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            return cell
        } else {
            let cell = myTicketCollectionView.dequeueReusableCell(withReuseIdentifier: "myTicketPayCell", for: indexPath) as! MyTicketPayCell
            cell.valueLabel.text = String(myTickets[indexPath.row].ticket_id!.value)
            cell.nameLabel.text = myTickets[indexPath.row].ticket_id!.name
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.transportCollectionView {
            if let cell = transportCollectionView.cellForItem(at: indexPath) as? TransportIconViewCell {
                cell.contentView.backgroundColor = UIColor(red: 94/255, green: 186/255, blue: 125/255, alpha: 0.2)
            }
            if selectedTransport != indexPath.row + 1 {
                selectedTransport = indexPath.row + 1
            }
        } else if collectionView == self.balanceCollectionView {
            if let cell = balanceCollectionView.cellForItem(at: indexPath) as? BalancePayCell {
                cell.contentView.backgroundColor = UIColor(red: 94/255, green: 186/255, blue: 125/255, alpha: 0.2)
            }
            if selectedBalance != indexPath.row + 1 {
                selectedBalance = indexPath.row + 1
            }
            self.resetMyTickets()
        } else {
            if let cell = myTicketCollectionView.cellForItem(at: indexPath) as? MyTicketPayCell {
                cell.contentView.backgroundColor = UIColor(red: 94/255, green: 186/255, blue: 125/255, alpha: 0.2)
            }
            if selectedMyTicket != indexPath.row + 1 {
                selectedMyTicket = indexPath.row + 1
            }
            self.resetBalance()
        }
        self.addTrip()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.transportCollectionView {
            if let cell = transportCollectionView.cellForItem(at: indexPath) as? TransportIconViewCell {
                cell.contentView.backgroundColor = nil
            }
        } else if collectionView == self.balanceCollectionView {
            if let cell = balanceCollectionView.cellForItem(at: indexPath) as? BalancePayCell {
                cell.contentView.backgroundColor = nil
            }
        } else {
            if let cell = myTicketCollectionView.cellForItem(at: indexPath) as? MyTicketPayCell {
                cell.contentView.backgroundColor = nil
            }
        }
    }
    
    func reset() {
        self.resetTransport()
        self.resetBalance()
        self.resetMyTickets()
    }
    
    func resetTransport() {
        let selectedTransport = transportCollectionView.indexPathsForSelectedItems
        for indexPath in selectedTransport! {
            transportCollectionView.deselectItem(at: indexPath, animated: true)
            if let cell = transportCollectionView.cellForItem(at: indexPath) as? TransportIconViewCell {
                cell.contentView.backgroundColor = nil
            }
        }
        self.selectedTransport = 0
    }
    
    func resetBalance() {
        let selectedBalance = balanceCollectionView.indexPathsForSelectedItems
        for indexPath in selectedBalance! {
            balanceCollectionView.deselectItem(at: indexPath, animated: true)
            if let cell = balanceCollectionView.cellForItem(at: indexPath) as? BalancePayCell {
                cell.contentView.backgroundColor = nil
            }
        }
        self.selectedBalance = 0
    }
    
    func resetMyTickets() {
        let selectedMyTickets = myTicketCollectionView.indexPathsForSelectedItems
        for indexPath in selectedMyTickets! {
            myTicketCollectionView.deselectItem(at: indexPath, animated: true)
            if let cell = myTicketCollectionView.cellForItem(at: indexPath) as? MyTicketPayCell {
                cell.contentView.backgroundColor = nil
            }
        }
        self.selectedMyTicket = 0
    }
    
    func addTrip() {
        if selectedTransport != 0 && (selectedMyTicket != 0 || selectedBalance != 0) {
            let nextId = StoragManager.incrementID(model: Trips.self)
            var price = 0
            var type = 0
            var ticket: MyTickets? = nil
            if selectedMyTicket != 0 {
                type = 1
                ticket = StoragManager.findById(id: myTickets[selectedMyTicket-1].id, model: MyTickets.self) as? MyTickets
            } else {
                price = balanceArray[selectedBalance-1]
            }
            let transport_id = StoragManager.findById(id: selectedTransport, model: Transports.self) as? Transports
            let newTrip = Trips(id: nextId, type: type, date: Date(), ticket_id: ticket, transport_id: transport_id!, price: price)
            StoragManager.addItem(objs: newTrip)
            tableView.reloadData()
            if selectedMyTicket != 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMytickets"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadBalance"), object: nil)
            }
            self.reset()
        }
    }
    
    @objc private func tripReloadMytickets() {
        self.myTicketCollectionView.reloadData()
    }

}

//extension TripViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: 60)
//    }
//}
