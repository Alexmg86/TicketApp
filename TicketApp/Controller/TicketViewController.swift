//
//  TicketViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 21.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit
import RealmSwift

class TicketViewController: UITableViewController {
    
    var groups: Results<Groups>!
    
    var ticket_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groups = realm.objects(Groups.self).filter("id > 1")
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.isEmpty ? 0 : groups.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.isEmpty ? 0 : groups[section].tickets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketsCell", for: indexPath) as! CellTicketViewCell
        cell.nameLabel.text = groups[indexPath.section].tickets[indexPath.row].name
        cell.priceLabel.text = String(groups[indexPath.section].tickets[indexPath.row].price) + " ₽"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ticket_id = groups[indexPath.section].tickets[indexPath.row].id
        self.performSegue(withIdentifier: "logoutSegue",sender: self)
    }

    func addNewTicket() {
        let nextId = StoragManager.incrementID(model: MyTickets.self)
        let ticket = StoragManager.findById(id: ticket_id!, model: Tickets.self) as? Tickets
        let newItem = MyTickets(id: nextId, ticket_id: ticket, date: Date(), active: true)
        StoragManager.addItem(objs: newItem)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
