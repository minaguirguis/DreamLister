//
//  MainVC
//  DreamLister
//
//  Created by Mina Guirguis on 10/27/17.
//  Copyright © 2017 Mina Guirguis. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }
    
    // functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //making sure there are objects and that there is at least one
        if let objs = controller.fetchedObjects , objs.count > 0 {
         
            let item = objs[indexPath.row]//setting item equal to the specific item in our list
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)//perform a segue and telling it that the identifier is the "ItemDetailsVC" and we are sending an the item
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //making sure it is the segue we are looking for
        if segue.identifier == "ItemDetailsVC" {
            
            //creating a variable called "destination" and setting it equal to "ItemDetailsVC"
            if let destination = segue.destination as? ItemDetailsVC {
                
                //then creating and item and casting it as "Item" (which is sender)
                if let item = sender as? Item {
                    
                    //we are saying that our destinationvc and the itemToEdit is what to assign it to
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //we created a fetch request variable and told it what kind of item we will be fetching, and then we are telling it what to go fetch
        let dateSort = NSSortDescriptor (key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]//passing in the sort descriptor that we just created
        
        let controller = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
       
        controller.delegate = self
        
        self.controller = controller //setting outside controller to inside controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print ("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert: //inserting cell
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        case.delete: //deleting cell
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case.update: //selecting cell
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as IndexPath as NSIndexPath)
            }
            
        case.move: //if the user is moving it we are deleting in current place then move
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
        }
    }//function to retrieve information from database
    
    // generate test data
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "Tesla Model S"
        item.price = 80000
        item.details = "VROOM, VROOM!!"
        let item2 = Item(context: context)
        item2.title = "MacBook Pro"
        item2.price = 1800
        item2.details = "I can't wait until September event!"
        let item3 = Item(context: context)
        item3.title = "iMac"
        item3.price = 2000
        item3.details = "Can't wait to get this for my home office!"
        
        ad.saveContext()
    }
}
