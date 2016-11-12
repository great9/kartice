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
 
 func addTitleAndFormattingToPageNavBar(titleToPut: String, fontName: String, sizeOfTitle: CGFloat){
         navigationController!.navigationBar.barTintColor = .white
         navigationController!.navigationBar.tintColor = .white
         navigationController!.navigationBar.titleTextAttributes =
         ([NSFontAttributeName: UIFont(name: fontName, size: sizeOfTitle)!,
         NSForegroundColorAttributeName: UIColor.black])
         title = titleToPut
        }
    
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
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    struct customColors {
        static let darkPurple = UIColor(displayP3Red: 252, green: 23, blue: 11, alpha: 0.2)
        static let yellow = UIColor(displayP3Red: 247, green: 239, blue: 105, alpha: 0.87)
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
