//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mina Guirguis on 11/24/17.
//  Copyright © 2017 Mina Guirguis. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var PriceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores = [Store]()
    var itemToEdit: Item?
    //made it optional by putting "?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Frys Electronics"
        let store4 = Store(context: context)
        store4.name = "Target"
        let store5 = Store(context: context)
        store5.name = "Amazon"
        let store6 = Store(context: context)
        store6.name = "K Mart"

        ad.saveContext()
        
        getStores()
        
        if itemToEdit != nil {
            
            loadItemData()
        }//if we have an item to edit we will load that item's data
        
        

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row] //we are selecting the store from the row and returning the name
        return store.name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)//set store array to result we get back
            self.storePicker.reloadAllComponents()//reloading all componenents inside of store picker
        }catch {
            //handle the error
        }
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        
        if itemToEdit == nil {
            
            item = Item(context: context)
        } else {
            
            item = itemToEdit
        }
        
        
        
        //then we started assigning those variables
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = PriceField.text{
           
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)] //assigning the store we selected
        //we are assigning the "tostore" relationshhip to that certain item
        //"in component" is not row, it is the column. Since we only have one column its zero
       
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)//to take us back to the Main screen after adding/editing an item
    }
    
    func loadItemData() {
        
        if let item = itemToEdit { //did this so we dont have to write "itemToEdit" each time
            
            titleField.text = item.title
            PriceField.text = "\(item.price)"
            detailsField.text = item.details
            
            //what this loop does is that it loops through to see what the correct store is and assigns it to a different variable
            if let store = item.toStore {//check to see if there is a store (item might not have one)
                
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        
                        break
                    }
                    index += 1
                    
                }while (index < stores.count)
            }
            
        }
        
    }
    
    
}
