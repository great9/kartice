 //
//  ViewController.swift
//  Kartice
//
//  Created by Darko Dujmovic on 04/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes
import FontAwesome_swift

class ViewController: UIViewController,UITextFieldDelegate, passData{
    
    var barcodeParserObj=barcodeParser()
    var typeOfBarcode: String?
    var savingEnabled:Bool = false{
        didSet{
            if savingEnabled{
                storeButtonOutlet.backgroundColor = customColors.scheme1Color2
            } else {
                storeButtonOutlet.backgroundColor = customColors.scheme1Color2faded
            }
        }
    }
   
    
    func textFieldDidChange(sender: Any){
        if let notification = sender as? NSNotification,
        let textFieldChanged = notification.object as? UITextField, textFieldChanged == self.naziv{
            print("The textfield value changed to \(naziv.text)")
        }
    }
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var typeOfBarcodeLabel: UILabel!
    @IBOutlet weak var barCode: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var storeButtonOutlet: UIButton!
    @IBOutlet weak var naziv: UITextField!
   
    @IBAction func dismissView(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func storeBarcode2(_ sender: Any) {
        if savingEnabled{
            storeCardToCoreData()
            generateAndPresentBarcode()
        }
        else{
            if !((naziv.text?.isEmpty)!){
                self.photoButton.shake2()
                }
            else if !(cardNumber.text?.isEmpty)!{
                self.naziv.shake()
            }
            else {
                self.photoButton.shake2()
                self.naziv.shake()
            }
        }
    }
    
    func generateAndPresentBarcode() {
  
        var barcode = UIImage()
        barcode = barcodeParserObj.generateBarcode(from: cardNumber.text!, typeOfBarcode: typeOfBarcode!)!
        barCode.image = barcode
        if !(self.naziv.text?.isEmpty)!{
        savingEnabled = true
        }
     
        
    }
    
    func editPhotoButton(){
        self.photoButton.setTitle("Skeniraj", for: .normal)
    }
    
    func addObserverToTextField(){
        naziv.addTarget(self, action: #selector(self.textFieldDidChange(textField:)) , for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        
        if (!(naziv.text?.isEmpty)! && (!(typeOfBarcodeLabel.text?.isEmpty)!)){
            savingEnabled = true
        }
        else {
            savingEnabled = false
     
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naziv.becomeFirstResponder()
        addObserverToTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        storeButtonOutlet.backgroundColor = customColors.scheme1Color2faded
        editPhotoButton()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destVC = segue.destination as! readerViewController
            destVC.delegate = self
    }
    
    func barcodeScanned(code: String, type: String){
        typeOfBarcode = type
        cardNumber.text = code
        typeOfBarcodeLabel.text = typeOfBarcode
        generateAndPresentBarcode()
    }

    
    func storeCardToCoreData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
        let card = NSManagedObject(entity: entity!, insertInto: context) as! Card
        
        card.id = String(Date.timeIntervalSinceReferenceDate)
        card.kod = cardNumber.text
        card.logo = "" //temporary not in use
        card.naziv = naziv.text
        card.type = typeOfBarcode
       
        do{
            try context.save()
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
        catch{
            fatalError("Error while trying to save to core data")
        }
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}

