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
    var savingEnabled:Bool = false

    func textFieldDidChange(sender: Any){
        if let notification = sender as? NSNotification,
        let textFieldChanged = notification.object as? UITextField, textFieldChanged == self.naziv{
            print("something")
        }
    }
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var typeOfBarcodeLabel: UILabel!
    var typeOfBarcode: String?
    @IBOutlet weak var barCode: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var storeButtonOutlet: UIButton!
    @IBOutlet weak var naziv: UITextField!
   
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func storeBarcode2(_ sender: Any) {
        print("Saving enabled is set to \(savingEnabled)")
        //if cardNumber.text != "" && naziv.text != ""{
        if savingEnabled{
            storeCardToCoreData()
            execute2()
        }
        else{
     
        //animateButton(button: storeButtonOutlet)
            //animate textfield or scan button
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
            
            print("animate the button")
        }
    }
    

    
    func execute2() {
        print("button pressed")
        var barcode = UIImage()
        barcode = generateBarcode(from: cardNumber.text!)!
        barCode.image = barcode
        if !(self.naziv.text?.isEmpty)!{
        savingEnabled = true
        }
        else{
            print("Animate something here")
           
        }
        
    }
    
    func editPhotoButton(){
  
        let stringForButtonTitle = ("Skeniraj")
        self.photoButton.setTitle(stringForButtonTitle, for: .normal)
    }
    
    func addObserverToTextField(){
        naziv.addTarget(self, action: #selector(self.textFieldDidChange(textField:)) , for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        
        if (!(naziv.text?.isEmpty)! && (!(typeOfBarcodeLabel.text?.isEmpty)!)){
            savingEnabled = true
            print("Case number 1")
        }
        else {
            //animate the scan button or textfield
            savingEnabled = false
            print("Case number 2")
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editPhotoButton()
        naziv.becomeFirstResponder()
        addObserverToTextField()
        //addKeyboardObservers()
               
        if ((naziv.text?.isEmpty)! || (cardNumber.text?.isEmpty)!){
            print("The fields might be empty")
        }
        self.storeButtonOutlet.alpha = 1
   
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destVC = segue.destination as! readerViewController
            destVC.delegate = self
    
    }
    
    func barcodeScanned(code: String, type: String){
        typeOfBarcode = type
        cardNumber.text = code
        typeOfBarcodeLabel.text = typeOfBarcode
        execute2()
    }

    
    
    func generateBarcode(from string: String) -> UIImage? {
        
        if typeOfBarcode == "org.gs1.EAN-13"{
            let image: UIImage = barcodeParserObj.returnEAN13(string: string)
            return image
        }
            
        else if typeOfBarcode == "org.iso.Code39"{
            let image: UIImage = barcodeParserObj.returnCode39(string: string)
            return image
            
        }
        
        else if typeOfBarcode == "org.gs1.EAN-8"{
            let image: UIImage = barcodeParserObj.returnEAN8(string: string)
            return image
        
        }
        
        else if typeOfBarcode == "org.iso.Code128" {
        let data = string.data(using: String.Encoding.ascii)
        //OB_CODE128A
        //CICode128BarcodeGenerator
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        }
        return nil
    }
    
    func storeCardToCoreData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
        let card = NSManagedObject(entity: entity!, insertInto: context) as! Card
        
        card.id = String(Date.timeIntervalSinceReferenceDate)
        card.kod = cardNumber.text
        card.logo = ""
        card.naziv = naziv.text
        card.type = typeOfBarcode
       
        do{
            try context.save()
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
        catch{
            fatalError("Error")
        
        }
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
     
/* let path = String(describing:getDocumentsDirectory())
 let url = URL(fileURLWithPath: path).appendingPathComponent(objectToShowInCell.imagePath!)
 cell.goalImage.image = UIImage(contentsOfFile: url.path)*/

}

