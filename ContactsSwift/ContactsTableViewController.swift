//
//  ContactsTableViewController.swift
//  ContactsSwift
//
//  Created by Murari Varma on 07/12/17.
//  Copyright © 2017 Murari Varma. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    var contacts: [Contact] = []
    /*
     [
     ["name": "murari varma", "phoneNumber": "12345-12345"]
     ]
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = contacts[indexPath.row].name
        cell.detailTextLabel?.text = contacts[indexPath.row].phoneNumber
        return cell
    }
    
    // Mark: - UnWind Segue
    
    @IBAction func unwindToContactList(segue: UIStoryboardSegue) {
        
        if let viewController = segue.source as? AddOrEditContactViewController {
            
            if (!viewController.phoneNumberTextField.text!.isEmpty &&
                !viewController.phoneNumberTextField.text!.isEmpty){
                let contact = Contact(name: viewController.nameTextField.text!,
                                      phoneNumber: viewController.phoneNumberTextField.text!)
                
                if let indexPath = viewController.indexPathForContact {
                    contacts[indexPath.row] = contact
                } else {
                    contacts.append(contact)
                }
                tableView.reloadData()
            }
        } else if let viewcontroller = segue.source as? contactDetailViewController {
            if viewcontroller.isDeleted {
                guard let indexPath: IndexPath = viewcontroller.indexPath else {return}
                print("Inde: \(indexPath.row)")
                contacts.remove(at: indexPath.row)
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
