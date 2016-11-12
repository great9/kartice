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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        var barcode = UIImage()
        let code = receivedData?.kod
        //barcode = generateBarcode(from:code)
        typeOfBarcode = receivedData?.type
        
        barcode = generateBarcode(from: code!)!
        
        codeImage.image = barcode
        codeNumber.text = code
        vendorLabel.text = receivedData?.naziv
        
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
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    

    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var codeNumber: UILabel!
    
    
}
