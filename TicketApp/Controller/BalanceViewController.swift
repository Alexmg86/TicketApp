//
//  BalanceViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 26.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit
import RealmSwift

class BalanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var payments: Results<Payments>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payments = realm.objects(Payments.self).sorted(byKeyPath: "id", ascending: false)
        self.getBalance()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "balanceCell", for: indexPath) as! BalanceViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let underDate = dateFormatter.string(from: payments[indexPath.row].date)
        cell.title?.text = "Пополнение \(underDate)"
        
        cell.value.text = String(payments[indexPath.row].value) + " ₽"
        return cell
    }
    
    @IBAction func addMoney(_ sender: Any) {
        let alert = UIAlertController(title: "Введите сумму пополения", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = .decimalPad
        }
        let action = UIAlertAction(title: "Добавить", style: .default) { (UIAlertAction) in
            if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                if let b = Int(alertTextField.text!) {
                    let nextId = StoragManager.incrementID(model: Payments.self)
                    let neyPayment = Payments(id: nextId, date: Date(), value: b)
                    StoragManager.addItem(objs: neyPayment)
                    self.tableView.reloadData()
                    self.getBalance()
                } else {
                    self.errorAlert()
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let paymentForDelete = payments[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { (action, sourceView, completionHandler) in
            StoragManager.deleteItem(objs: paymentForDelete)
            tableView.reloadData()
            self.getBalance()
            completionHandler(false)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Допустимы для ввода только числа.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getBalance() {
        let spent: Int = realm.objects(Trips.self).sum(ofProperty: "price")
        let payments: Int = realm.objects(Payments.self).sum(ofProperty: "value")
        balanceLabel.text = "\(payments - spent) ₽"
    }

}
