//
//  extensionsForViewController.swift
//  
//
//  Created by Darko Dujmovic on 16/09/16.
//
//

import UIKit

class extensionsForViewController: UIViewController {
    


    

}


//tap gesture recognizer za hide/show keyboard
extension UIViewController{
 
  
    func makeNavBarTransparent(){
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func makeNavBarNotTransparent(){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .white
    }
 
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func changeTheTitleOfTheBackButton(textToDisplay :String){
        let backItem = UIBarButtonItem()
        backItem.title = textToDisplay
        navigationItem.backBarButtonItem = backItem
    }
    
    func addKeyboardObservers(){
        //notification center za hide/show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height * 0.14)
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height * 0.14)
            }
        }
    }
    
    struct customColors {
        static let darkPurple = UIColor(displayP3Red: 252, green: 23, blue: 11, alpha: 0.2)
       // static let yellow = UIColor(displayP3Red: 247, green: 239, blue: 105, alpha: 0.47)
        static let greenTV = UIColor(red:0.00, green:0.66, blue:0.65, alpha:0.35)
        static let blue1TV = UIColor(red:0.31, green:0.50, blue:0.60, alpha:1.0)
        static let lightPurpleTV = UIColor(red:0.83, green:0.76, blue:0.99, alpha:0.35)
        static let darkPurpleTV = UIColor(red:0.60, green:0.56, blue:0.78, alpha:0.35)
        static let lighterPurpleTV = UIColor(red:0.93, green:0.79, blue:1.00, alpha:0.35)
        
        static let scheme1Color1 = UIColor(red:0.33, green:0.38, blue:0.44, alpha:1.0)
        static let scheme1Color2 = UIColor(red:0.31, green:0.80, blue:0.77, alpha:1.0)
        static let scheme1Color3 = UIColor(red:0.78, green:0.96, blue:0.39, alpha:1.0)
        static let scheme1Color4 = UIColor(red:1.00, green:0.42, blue:0.42, alpha:1.0)
    }
 
}
 /*
    func addTapGestureRecognizer(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        //tap.cancelsTouchesInView = false;
    }
    

    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }

    
    
}*/
