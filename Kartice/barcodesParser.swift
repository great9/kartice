//
//  barcodesParser.swift
//  Kartice
//
//  Created by Darko Dujmovic on 10/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//

import Foundation
import RSBarcodes


struct typesOfBarcodes {
    var EAN13 = AVMetadataObjectTypeEAN13Code
}


class  barcodeParser {
    let genv2 = RSUnifiedCodeGenerator.codeGen()
    
    
    func returnEAN13(string:String) -> UIImage{
    let barcodeImage: UIImage = (genv2?.genCode(withContents: string, machineReadableCodeObjectType: AVMetadataObjectTypeEAN13Code))!
    return barcodeImage
    }
    func returnCode39(string:String) -> UIImage{
        let barcodeImage: UIImage = (genv2?.genCode(withContents: string, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code))!
    return barcodeImage
    }
    
}

