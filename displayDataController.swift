//
//  displayDataController.swift
//  Kartice
//
//  Created by Darko Dujmovic on 06/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//

import AVFoundation
import UIKit
import RSBarcodes

class displayDataController: UIViewController{
    
    
    var barcodeParserObj=barcodeParser()
    var receivedData:Card?
    var typeOfBarcode: String?
    var instanceOfmainController = mainController()
 
    let defaults = UserDefaults.standard
    
    @IBAction func dismissTheController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapRecognizerToImageView()
      
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        self.navigationController?.navigationBar.tintColor = .black
        
        var barcode = UIImage()
        let code = receivedData?.kod
        //barcode = generateBarcode(from:code)
        typeOfBarcode = receivedData?.type
        
        barcode = generateBarcode(from: code!)!
        
        codeImage.image = barcode
        codeNumber.text = code
        vendorLabel.text = receivedData?.naziv
        checkIfFavorite()
        print("The barcode is \(code)")
        
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
            let image:UIImage = barcodeParserObj.returnEAN8(string: string)
            return image
        }
            
        else if typeOfBarcode == "org.iso.Code128" {
            
            let image:UIImage = barcodeParserObj.returnCode128(string: string)
            return image
           /* let data = string.data(using: String.Encoding.ascii)
            if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 5, y: 5)
                
                if let output = filter.outputImage?.applying(transform) {
                    let image = UIImage(ciImage: output)
                    return image
                }
            }*/
            
            
        }
        return nil
    }
    
    func addTapRecognizerToImageView(){
        favoritesImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFavorites))
        favoritesImage.addGestureRecognizer(tapRecognizer)
    }
    
    func toggleFavorites(){
        if favoritesImage.image == UIImage(named: "notFavorite"){
            favoritesImage.image = UIImage(named: "favorite")
            saveFavorite()
        }   else {
            favoritesImage.image = UIImage(named: "notFavorite")
        }
        
    }
    
    func saveFavorite(){
        let numberOfCard = receivedData?.kod
        let vendor = receivedData?.naziv
        
        let imageForFavorites:UIImage = generateBarcode(from:(numberOfCard)!)!
        let userDefaultsImage = UIImagePNGRepresentation(imageForFavorites)

        UserDefaults.init(suiteName: "group.com.darko")?.setValue(numberOfCard, forKey: "brojKartice")
        UserDefaults.init(suiteName: "group.com.darko")?.setValue(vendor, forKey: "vendor")
        UserDefaults.init(suiteName: "group.com.darko")?.set(userDefaultsImage, forKey: "image")
        
        defaults.synchronize()
    }
 
    func checkIfFavorite(){
        let numberOfCard = receivedData?.kod
        let numberOfFavCard = UserDefaults.init(suiteName: "group.com.darko")?.value(forKey: "brojKartice") as! String
   
        if numberOfCard == numberOfFavCard {
            favoritesImage.image = UIImage(named: "favorite")
        }
    }
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    

  
    @IBOutlet weak var favoritesImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var codeNumber: UILabel!
    
    
}
