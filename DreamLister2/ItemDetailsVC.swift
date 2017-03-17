//
//  ItemDetailsVC.swift
//  DreamLister2
//
//  Created by Ping Li on 2016-12-19.
//  Copyright © 2016 Ping Li. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var itemTypeBtn: UIButton!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        storePicker.delegate = self
        storePicker.dataSource = self
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
        //Prepare default options into dropdowns in the first run
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            let type = ItemType(context: context)
            type.type = "Car"
            let type2 = ItemType(context: context)
            type2.type = "Electronic"
            let type3 = ItemType(context: context)
            type3.type = "Computer related"
            let type4 = ItemType(context: context)
            type4.type = "Watch"
            let type5 = ItemType(context: context)
            type5.type = "Clothes"
            
            ad.saveContext()
            
            let store = Store(context: context)
            store.name = "Best Buy"
            let store2 = Store(context: context)
            store2.name = "Tesla Dealership"
            let store3 = Store(context: context)
            store3.name = "Target"
            let store4 = Store(context: context)
            store4.name = "Amazon"
            let store5 = Store(context: context)
            store5.name = "Frys Electronics"
            let store6 = Store(context: context)
            store6.name = "K Mart"
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        ad.saveContext()
        getStores() //load dropdown options
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == itemTypePicker{
            let itemType = itemTypes[row]
            return itemType.type
        }else if pickerView == storePicker{
            let store = stores[row]
            return store.name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == itemTypePicker{
            return itemTypes.count
        }else if pickerView == storePicker{
            return stores.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == itemTypePicker{
            itemTypePicker.isHidden = true
            itemTypeBtn.setTitle(itemTypes[row].type, for: UIControlState.normal)
        }
    }

    //Request all stores from CoreData
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
//            self.storePicker.reloadAllComponents()
        }catch{
            //handle error
        }
    }
    
    //Request all item type from CoreData
    func getItemTypes(){
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do{
            self.itemTypes = try context.fetch(fetchRequest)
        }catch{
            //handle error
        }
    }
    
    //Save user inputs to CoreData
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = thumbImg.image

        if itemToEdit == nil{
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text{
            item.title = title
        }
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text{
            item.details = details
        }
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
//        let itemType = ItemType(context: context)
//        itemType.type = itemTypeBtn.currentTitle
//        item.toItemType = itemType 
        item.toItemType = itemTypes[itemTypePicker.selectedRow(inComponent: 0)]

        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Request item data from CoreData and insert them to the fields
    func loadItemData(){
        if let item = itemToEdit{
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            if let itemType = item.toItemType{
                var index = 0
                repeat{
                    let it = itemTypes[index]
                    if it.type == itemType.type{
                        pickerView(itemTypePicker, didSelectRow: index, inComponent: 0)
//                        itemTypePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while (index < itemTypes.count)
            }
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while (index < stores.count)
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil{
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Set image to thumbnail and return to the application
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            thumbImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func itemTypeBtnPressed(_ sender: UIButton) {
        itemTypePicker.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
