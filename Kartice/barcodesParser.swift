//
//  barcodesParser.swift
//  Kartice
//
//  Created by Darko Dujmovic on 10/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//

import Foundation
import RSBarcodes



class  barcodeParser {
    
    let generator = RSUnifiedCodeGenerator.codeGen()
    
    func returnEAN13(string:String) -> UIImage{
    let barcodeImage: UIImage = (generator?.genCode(withContents: string, machineReadableCodeObjectType: AVMetadataObjectTypeEAN13Code))!
    return barcodeImage
    }
    func returnCode39(string:String) -> UIImage{
    let barcodeImage: UIImage = (generator?.genCode(withContents: string, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code))!
    return barcodeImage
    }
    func returnEAN8(string:String)-> UIImage{
    let barcodeImage: UIImage = (generator?.genCode(withContents: string, machineReadableCodeObjectType: AVMetadataObjectTypeEAN8Code))!
    return barcodeImage
    }
    func returnCode128(string:String)-> UIImage{
        let barcodeImage: UIImage = (generator?.genCode(withContents: string, machineReadableCodeObjectType: AVMetadataObjectTypeCode128Code))!
        return barcodeImage
    }
    
    
    func generateBarcode(from string: String, typeOfBarcode: String) -> UIImage? {
        
        if typeOfBarcode == "org.gs1.EAN-13"{
            let image: UIImage = self.returnEAN13(string: string)
            return image
        }
            
        else if typeOfBarcode == "org.iso.Code39"{
            let image: UIImage = self.returnCode39(string: string)
            return image
            
        }
            
        else if typeOfBarcode == "org.gs1.EAN-8"{
            let image: UIImage = self.returnEAN8(string: string)
            return image
            
        }
            
        else if typeOfBarcode == "org.iso.Code128" {
            let data = string.data(using: String.Encoding.ascii)
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

    
}

