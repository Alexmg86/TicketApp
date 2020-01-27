//
//  MyTicketsViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 23.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit
import RealmSwift

class MyTicketsViewController: UITableViewController {
    
    var myTickets: Results<MyTickets>!

    override func viewDidLoad() {
        super.viewDidLoad()
        myTickets = realm.objects(MyTickets.self).sorted(byKeyPath: "id", ascending: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMytickets), name: NSNotification.Name(rawValue: "reloadMytickets"), object: nil)
        self.tableView.tableFooterView = UIView()
    }
    @objc private func reloadMytickets(notification: NSNotification){
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTickets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTicketsCell", for: indexPath) as! CellMyTicketViewCell
        let myTicketById = myTickets[indexPath.row]
        cell.groupName?.text = myTicketById.ticket_id?.group_id?.name
        cell.myTicketName?.text = myTicketById.ticket_id?.name
        cell.countTrips?.text = String(myTicketById.trips.count)
        
        let modifiedDate = Calendar.current.date(byAdding: .day, value: myTicketById.ticket_id!.days, to: myTicketById.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let underDate = dateFormatter.string(from: modifiedDate!)
        cell.underDate?.text = "Действителен до \(underDate)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let myTicketForDelete = myTickets[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { (action, sourceView, completionHandler) in
            if myTicketForDelete.trips.count == 0 {
                StoragManager.deleteItem(objs: myTicketForDelete)
                tableView.reloadData()
            } else {
                self.errorAlert()
            }
            completionHandler(false)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Нельзя удалить билет с поездками. Сначала удалите поездки.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let ticket = segue.source as? TicketViewController else { return }
        ticket.addNewTicket()
        tableView.reloadData()
    }

}
