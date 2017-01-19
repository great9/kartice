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

class mainController: UITableViewController, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
   
    
    @IBOutlet weak var cardSearchBar: UISearchBar!
    
    var cardObjects = [Card]()
    var filteredCardObjects: [Card] = []
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var searchActivated = false
    
    override func viewWillAppear(_ animated: Bool) {
        let canLoadData = countCoreDataObjects()
        if canLoadData == true {
            loadCoreData()
        }
        else {
            cardSearchBar.isHidden = true
            print("The core data is empty and no fetch is going to be done")
        }
        cardSearchBar.text = ""
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        setHeader()
        self.cardSearchBar.returnKeyType = .done
        
        
    }
    
    func removeKeyboardOnTap(){
        if self.cardSearchBar.isFirstResponder {
            //add gesture recognizer
            //cardSearchBar.resignFirstResponder()
           // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignFirstResponder))
           // view.addGestureRecognizer(tap)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        cardSearchBar.resignFirstResponder()
    }

    
    func setHeader(){
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.title = "Kartice"
       /* self.navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont(name: "Avenir", size: 22)!,
              NSForegroundColorAttributeName: UIColor.black])*/
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Dobrodošli"
        let attrs = [NSFontAttributeName:UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "defaultCard")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Unesite svoj prvi kod klikom na + sa desne strane"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string:str, attributes:attrs)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActivated{
            return filteredCardObjects.count
        }else {
            return cardObjects.count}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        
        cell.cellBckVw.layer.cornerRadius = 6
        var objToShow : Card?
        
        if searchActivated{
        objToShow = filteredCardObjects[indexPath.row]
        }
        else{
        objToShow = cardObjects[indexPath.row]
        }
        
        
        cell.vendorLabel.text = objToShow?.naziv!
        let rownum = indexPath.row
        if rownum % 3 != 0 {
        let evenOdd = rownum % 2
        
        if evenOdd == 0 {
        cell.cellBckVw.backgroundColor = customColors.scheme1Color2
        } else {
          cell.cellBckVw.backgroundColor = customColors.scheme1Color1
        }}
        else {
        cell.cellBckVw.backgroundColor = customColors.scheme1Color4
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    

    func loadCoreData(){
        cardObjects.removeAll()
        
        do{
            let fetchRequest : NSFetchRequest<Card> = Card.fetchRequest()
    
            
            let result = try managedObjectContext.fetch(fetchRequest)
            for result in result {
                cardObjects.append(result)
               print("Core data fetch \(result.kod!)" )
            }
            animateTable()
            
            if !result.isEmpty {
            cardSearchBar.isHidden = false
            self.view.reloadInputViews()
            }
            else {
            cardSearchBar.isHidden = true
            cardSearchBar.resignFirstResponder()
            self.view.reloadInputViews()
            }
            
            
        }
        catch {
            fatalError("Error while trying to get core data")
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
                fatalError("Error 1 while trying to delete from the core data")
            }
            
            do{
                try context.save()}
            catch{
                fatalError("Error 2 while trying to delete from the core data")
                
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
            if !searchActivated{
                DestViewController.receivedData = cardObjects[indexPath.row]}
            else {DestViewController.receivedData = filteredCardObjects[indexPath.row]}
        }
    }
    
    //search bar delegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActivated = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActivated = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("jhfjht")
        removeKeyboardOnTap()
        filteredCardObjects = cardObjects.filter({ (Card) -> Bool in
            let preTmp = Card.naziv
            let tmp = NSString(string: preTmp!)
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(filteredCardObjects.count == 0){
            searchActivated = false
            self.tableView.reloadData()
        } else {
            searchActivated = true
        }
        self.tableView.reloadData()
    }
    
    func handleViewTap(recognizer: UIGestureRecognizer) {
        cardSearchBar.resignFirstResponder()
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
            fatalError("Error while trying to count card objects")
        }
        
    }
        
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 0.97, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    func touchToScan(){
        let readerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "readerVC") as! readerViewController
        readerVC.present(readerVC, animated: true, completion: nil)
    }
 
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    
}
