//
//  mainViewController.swift
//  Kartice
//
//  Created by Darko Dujmovic on 05/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class mainController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var cardObjects = [Card]()

    override func viewWillAppear(_ animated: Bool) {
        let canLoadData = countCoreDataObjects()
        if canLoadData == true {
            loadCoreData()
        }
        else {
            print("The core data is empty and no fetch is going to be done")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Dobrodošli"
        let attrs = [NSFontAttributeName:UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "cd")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Unesite svoj prvi kod klikom na + sa desne strane"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string:str, attributes:attrs)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        let objToShow = cardObjects[indexPath.row]
        print("Object to show is \(objToShow.naziv) \(objToShow.id)")
        cell.vendorLabel.text = objToShow.naziv!
        
        return cell
        
    }
    
    func loadCoreData(){
        cardObjects.removeAll()
        
        //let request = NSFetchRequest<Goals>(entityName:"Goals")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            let fetchRequest : NSFetchRequest<Card> = Card.fetchRequest()
            //let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
           // fetchRequest.sortDescriptors = [sortDescriptor]
            
            let result = try context.fetch(fetchRequest)
            for result in result {
                cardObjects.append(result)
               print("Core data fetch \(result.kod!)" )
            }
            tableView.reloadData()
            //self.tableView.reloadSections([0], with: UITableViewRowAnimation.fade)
        }
        catch {
            fatalError("Sthh")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            let objectToDelete = cardObjects[indexPath.row]
            let predicateForDelete = objectToDelete.id
            //stavi i za adresu slike
            let predicate = NSPredicate(format: "id == %@", predicateForDelete!)
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do{
                let fetchRequest1 : NSFetchRequest<Card> = Card.fetchRequest()
                fetchRequest1.predicate = predicate
                
                let result = try context.fetch(fetchRequest1)
                
                for object in result {
                    context.delete(object)
                }
                
                
                
            }
            catch {
                fatalError("Sthh")
            }
            
            do{
                try context.save()}
            catch{
                fatalError("Error")
                
            }
       
            loadCoreData()
        
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        changeTheTitleOfTheBackButton(textToDisplay: "")
        if let indexPath = self.tableView.indexPathForSelectedRow{
            let DestViewController = segue.destination as! displayDataController
            DestViewController.receivedData = cardObjects[indexPath.row]
        }
    }
    
    func countCoreDataObjects()-> Bool{
        //let request = NSFetchRequest<Goals>(entityName:"Goals")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            
            let fetchRequest : NSFetchRequest<Card> = Card.fetchRequest()
            let result = try context.fetch(fetchRequest)
            if result.count == 0 {
                return false
            } else {return true
                
            }
        }
        catch {
            fatalError("Sthh")
        }
        
    }
}
