//
//  SignUPViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/21/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import GooglePlaces


class SignUPViewController: UIViewController,GMSAutocompleteViewControllerDelegate {

    
    @IBOutlet var email: UITextField!
    @IBOutlet var lbl1: UILabel!
        @IBOutlet var city: UITextField!
        @IBOutlet var cty: UILabel!
        @IBOutlet var firstname: UITextField!
        @IBOutlet var lastname: UITextField!
        @IBOutlet var username: UITextField!
        @IBOutlet var pwd: UITextField!
        @IBOutlet var pwd1: UITextField!
        @IBOutlet var btnsubmit: UIButton!
        var TableData:Array< String > = Array < String >()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "SIGN UP"
            self.navigationController?.navigationBar.isHidden = true
            btnsubmit.layer.cornerRadius = 8
                }
    
    
    enum PasswordStrength: Int {
        case None
        case Weak
        case Moderate
        case Strong
        
        static func checkStrength(password: String) -> PasswordStrength {
            let len: Int = password.characters.count
            var strength: Int = 0
            
            switch len {
            case 0:
                return .None
            case 1...4:
                strength = strength+1
            case 5...8:
                strength += 2
            default:
                strength += 3
            }
            
            // Upper case, Lower case, Number & Symbols
            let patterns = ["^(?=.*[A-Z]).*$", "^(?=.*[a-z]).*$", "^(?=.*[0-9]).*$", "^(?=.*[!@#%&-_=:;\"'<>,`~\\*\\?\\+\\[\\]\\(\\)\\{\\}\\^\\$\\|\\\\\\.\\/]).*$"]
            
            for pattern in patterns {
                if (password.range(of: pattern, options: .regularExpression) != nil) {
                    strength = strength+1
                }
            }
            
            switch strength {
            case 0:
                return .None
            case 1...3:
                return .Weak
            case 4...6:
                return .Moderate
            default:
                return .Strong
            }
        }
    }
    
    
    @IBAction func auto(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func pwd(_ sender: Any) {
        let abc = String(describing: PasswordStrength.checkStrength(password: pwd.text!))
        print(abc)
        check(abc)
    }
    func check(_ pass : String){
        lbl1.text = pass
    }
    
    
    @IBAction func bck(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
        @IBAction func signUPAction(_ sender: UIButton) {
            
            if self.firstname.text!.isEmpty || self.lastname.text!.isEmpty || self.username.text!.isEmpty || self.pwd.text!.isEmpty || self.pwd1.text!.isEmpty || self.city.text!.isEmpty || (self.email.text?.isEmpty)! || (isValidEmail(testStr: self.email.text!) != true) {
                let alt = UIAlertController(title: "Enter Value", message: "All Fields are Mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alt, animated: true, completion: nil)
                
                
            }else if pwd.text != pwd1.text{
                let alt = UIAlertController(title: "Confirm Password", message: "Password Can't match, Enter Same Password", preferredStyle: UIAlertControllerStyle.alert)
                alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alt, animated: true, completion: nil)
            }
            
            else {
                let nm = self.firstname.text?.appending(" ").appending(self.lastname.text!)
                let parameters = ["name": nm!,"username": self.username.text!,"password": self.pwd.text!,"locality": self.city.text!,"email" : self.email.text!]
                print(self.city.text!)
                server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "reg", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
                
            }, response_Dictionary: { (json) in
                DispatchQueue.main.async {
                    if json.value(forKey: "resp") != nil{
                     if(json.value(forKey: "resp") as! String == "Taken"){
                        let alt = UIAlertController(title: "Username already taken!", message: "Please enter a different username", preferredStyle: UIAlertControllerStyle.alert)
                        alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alt, animated: true, completion: nil)
                        self.username.text = ""
                    }
                     else if(json.value(forKey: "resp") as! String == "Success"){
                        UserDefaults.standard.set(self.username.text, forKey: "user")
                    
                        self.navigationController?.pushViewController(LoginViewController(nibName: "LoginViewController", bundle: nil), animated: true)
                    }
                    }
                     else {
                        print(json.value(forKey: "error")!)
                    }
                }
            
            }, response_Array: { (resultsArr) in
                
            }, isTokenEmbeded: false)
            }
            
            
        }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        city.text = place.name
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
}





    
