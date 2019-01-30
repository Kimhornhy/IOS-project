//
//  ViewController.swift
//  ContactAppCoreDataDemo
//
//  Created by MAC on 1/19/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
var i :Int = 0
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = contacts[indexPath.row].name
        cell?.detailTextLabel?.text = "Age: \(contacts[indexPath.row].age) years old"
        cell?.imageView?.image = UIImage(data: contacts[indexPath.row].image!)
        return cell!
    }
    
    //edit
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let editContact = self.storyboard?.instantiateViewController(withIdentifier: "addScreen")as! AddContactViewController
            editContact.isEditContact = true
            editContact.contact = self.contacts[indexPath.row]
            self.navigationController?.pushViewController(editContact, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [edit])
    }
//delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete", handler: { (_, _, _) in
            self.context.delete(self.contacts[indexPath.row])
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            try? self.context.save()
        })
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        read()
    }
    var contacts = [Contact]()
    func read(){
        contacts = try! context.fetch(Contact.fetchRequest())
        tableView.reloadData()
    }
    func write(){
        let person = Contact(context: context)
        person.image = UIImage.pngData(UIImage(named: "1")!)()
        person.name = "Kimhorn"
        person.age = 21
        let phone1 = Phone(context: context)
        let phone2 = Phone(context: context)
        phone1.label = "Smart"
        phone1.phone = "070 919 342"
        phone2.label = "Smart1"
        phone2.phone = "085 919 123"
        person.addToPhones([phone1,phone2])
        appDelegate.saveContext()
    }

}

