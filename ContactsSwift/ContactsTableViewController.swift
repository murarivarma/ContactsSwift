//
//  ContactsTableViewController.swift
//  ContactsSwift
//
//  Created by Murari Varma on 07/12/17.
//  Copyright © 2017 Murari Varma. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class ContactsTableViewController: UITableViewController {
    
    var contacts: [NSManagedObject] = []
    /*
     [
     ["name": "murari varma", "phoneNumber": "12345-12345"]
     ]
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Data Source
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveData(name: String, phoneNumber: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext) else {return}
        let contact = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        
        do {
            try managedObjectContext.save()
            self.contacts.append(contact)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func updateData(indexPath: IndexPath, name: String, phoneNumber: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let contact = contacts[indexPath.row]
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        
        do {
            try managedObjectContext.save()
            self.contacts.remove(at: indexPath.row)
            self.contacts.insert(contact, at: indexPath.row)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteData(contact: NSManagedObject, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(contact)
        do {
            try managedObjectContext.save()
            self.contacts.remove(at: indexPath.row)
        }
        catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        cell.textLabel?.text = (contacts[indexPath.row].value(forKey: "name") as! String)
        cell.detailTextLabel?.text = (contacts[indexPath.row].value(forKey: "phoneNumber") as! String)
        return cell
    }
    
    // Mark: - UnWind Segue
    
    @IBAction func unwindToContactList(segue: UIStoryboardSegue) {
        
        if let viewController = segue.source as? AddOrEditContactViewController {
            
            if (!viewController.nameTextField.text!.isEmpty &&
                !viewController.phoneNumberTextField.text!.isEmpty){
                
                let name = viewController.nameTextField.text!
                let phone = viewController.phoneNumberTextField.text!
                
                
                if let indexPath = viewController.indexPathForContact {
                    // update data
                    updateData(indexPath: indexPath, name: name, phoneNumber: phone)
                } else {
                    // save data
                    saveData(name: name, phoneNumber: phone)
                }
                tableView.reloadData()
            }
        } else if let viewcontroller = segue.source as? contactDetailViewController {
            if viewcontroller.isDeleted {
                guard let indexPath: IndexPath = viewcontroller.indexPath else {return}
                let contact = contacts[indexPath.row]
                deleteData(contact: contact, at: indexPath)
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue" {
            guard let viewController = segue.destination as? contactDetailViewController else { return }
            guard let selectedCellIndex = tableView.indexPathForSelectedRow else {return}
            viewController.contact = contacts[selectedCellIndex.row]
            viewController.indexPath = selectedCellIndex
        }
    }
    
}
