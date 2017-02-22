//
//  SignUPViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/21/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit


class SignUPViewController: UIViewController {
    
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
        
        //MARK: - Button Action
        @IBAction func signUPAction(_ sender: UIButton) {
            
            if self.firstname.text!.isEmpty || self.lastname.text!.isEmpty || self.username.text!.isEmpty || self.pwd.text!.isEmpty || self.pwd1.text!.isEmpty {
                let alt = UIAlertController(title: "Enter Value", message: "All Fields are Mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alt, animated: true, completion: nil)
                
            }else if pwd.text != pwd1.text{
                let alt = UIAlertController(title: "Confirm Password", message: "Password Can't match, Enter Same Password", preferredStyle: UIAlertControllerStyle.alert)
                alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alt, animated: true, completion: nil)
            }else {
                _ = self.firstname.text
            }
            
            let parameters = ["name": self.firstname.text!,"surname": self.lastname.text!,"username": self.username.text!,"password": self.pwd.text!]
                
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

    
