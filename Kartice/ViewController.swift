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

    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var typeOfBarcodeLabel: UILabel!
    var typeOfBarcode: String?
    @IBOutlet weak var barCode: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var storeButtonOutlet: UIButton!
    
  
   
    @IBOutlet weak var naziv: UITextField!
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func storeBarcode2(_ sender: Any) {
        execute2()
    }


    func checkIfStoreEligible(){
        if cardNumber == nil {
            self.storeButtonOutlet.isEnabled = false
        }
    
    }
    
    func execute2() {
        
        print("button pressed")
        var barcode = UIImage()
        barcode = generateBarcode(from: cardNumber.text!)!
        barCode.image = barcode
        storeCardToCoreData()
        view.endEditing(true)
    }
    
    func editPhotoButton(){
  
        let stringForButtonTitle = ("Skeniraj")
        self.photoButton.setTitle(stringForButtonTitle, for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editPhotoButton()
        naziv.becomeFirstResponder()
        checkIfStoreEligible()
        addKeyboardObservers()
       
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

