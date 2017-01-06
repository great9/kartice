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
    
    //Custom colors
    
    struct customColors {
        static let darkPurple = UIColor(displayP3Red: 252, green: 23, blue: 11, alpha: 0.2)
        static let greenTV = UIColor(red:0.00, green:0.66, blue:0.65, alpha:0.35)
        static let blue1TV = UIColor(red:0.31, green:0.50, blue:0.60, alpha:1.0)
        static let lightPurpleTV = UIColor(red:0.83, green:0.76, blue:0.99, alpha:0.35)
        static let darkPurpleTV = UIColor(red:0.60, green:0.56, blue:0.78, alpha:0.35)
        static let lighterPurpleTV = UIColor(red:0.93, green:0.79, blue:1.00, alpha:0.35)
        
        //scheme colors
        static let scheme1Color1 = UIColor(red:0.33, green:0.38, blue:0.44, alpha:1.0)
        static let scheme1Color2 = UIColor(red:0.31, green:0.80, blue:0.77, alpha:1.0)
        static let scheme1Color2faded = UIColor(red:0.31, green:0.80, blue:0.77, alpha:0.4)
        static let scheme1Color3 = UIColor(red:0.78, green:0.96, blue:0.39, alpha:1.0)
        static let scheme1Color4 = UIColor(red:1.00, green:0.42, blue:0.42, alpha:1.0)
    }
    
    //Animations
    
    func animateButton(button: UIButton){
        let bounds = button.bounds
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .allowAnimatedContent , animations: {
            button.alpha = 1
            button.bounds = CGRect(x: bounds.origin.x , y: bounds.origin.y, width: bounds.size.width + 80, height: bounds.size.height)
            button.isEnabled = false
        }, completion: nil )
        
    }
    func animateOut(button: UIButton){
        let bounds = button.bounds
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .allowAnimatedContent , animations: {
            button.alpha = 0.5
            button.bounds = CGRect(x: bounds.origin.x , y: bounds.origin.y, width: bounds.size.width - 80, height: bounds.size.height)
            button.isEnabled = false
        }, completion: nil )
        
    }
    func animateButtonIn(button: UIButton){
        let bounds = button.bounds
        UIView.animate(withDuration: 0.25, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .allowAnimatedContent , animations: {
            button.bounds = CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width + 80, height: bounds.size.height)
            button.alpha = 1
        }, completion: nil )
        
    }

 
}


extension UIView{
    
    // Some animations on UIView level
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 10, y:self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 10, y:self.center.y)
        self.layer.add(animation, forKey: "position")
    }
    
    func shake2() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 15, y:self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 15, y:self.center.y)
        self.layer.add(animation, forKey: "position")
    }
    
    func pulsate(button: UIButton){
        
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]
        
        button.layer.add(animationGroup, forKey: "pulse")
    
    }

}

