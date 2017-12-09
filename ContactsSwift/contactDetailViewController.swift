//
//  contactDetailViewController.swift
//  ContactsSwift
//
//  Created by Murari Varma on 07/12/17.
//  Copyright © 2017 Murari Varma. All rights reserved.
//

import UIKit
import CoreData

class contactDetailViewController: UIViewController {
    
    
    var contact: NSManagedObject? = nil
    var indexPath: IndexPath? = nil
    var isDeleted = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = contact?.value(forKey:"name") as? String
        phoneNumberLabel.text = contact?.value(forKey:"phoneNumber") as? String
        // Do any additional setup after loading the view.
    }

    @IBAction func deleteContact(_ sender: UIButton) {
        isDeleted = true
        performSegue(withIdentifier: "unwindDeleteContactSegue", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editContactSegue" {
            guard let viewController = segue.destination as? AddOrEditContactViewController else {return}
            viewController.titleText = "Edit Contact"
            viewController.contact = contact
            viewController.indexPathForContact = self.indexPath!
        }
        
    }

}
