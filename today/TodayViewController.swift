//
//  TodayViewController.swift
//  today
//
//  Created by Darko Dujmovic on 22/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var behindBarcodeView: UIView!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
  
        }
        
        if self.preferredContentSize.height > 199{
            
        behindBarcodeView.isHidden = false
        codeLabel.isHidden = false
        barcodeImage.isHidden = false
        
        if let code = UserDefaults.init(suiteName: "group.com.darko")?.value(forKey: "brojKartice"){
            codeLabel.text = code as? String
        }else {
            codeLabel.text = "Mark a card as favorite"
        }
        if let vendor = UserDefaults.init(suiteName: "group.com.darko")?.value(forKey: "vendor"){
        
                vendorLabel.text = vendor as? String
        } else {
            vendorLabel.text = "You haven't set any card as favorite"
            behindBarcodeView.isHidden = true
            
        }
        
        if let image = UserDefaults.init(suiteName: "group.com.darko")?.value(forKey: "image"){
            let imageToPresent = UIImage(data: image as! Data)
            barcodeImage.image = imageToPresent
            }
        }
        else {
            let messageWhenWidgetIsSmall = "Click on 'Show more' to show the barcode"
            vendorLabel.text = messageWhenWidgetIsSmall
            behindBarcodeView.isHidden = true
            codeLabel.isHidden = true
            barcodeImage.isHidden = true
        }
        

        
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // For iOS 10
    @available(iOS 10.0, *)
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: 320, height: 200) : CGSize(width: maxSize.width, height: 110)
        
        viewDidLoad()
      
    }
    
}
