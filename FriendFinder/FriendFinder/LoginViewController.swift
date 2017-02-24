//
//  LoginViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/21/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var Forward: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var email: UITextField!
    @IBOutlet var pwd: UITextField!
    @IBOutlet var submit: UIButton!
    @IBOutlet var NewAcc: UIButton!
    
    var defaults = UserDefaults.standard
    var fetchedPerson: [Person] = []
    var filteredArray = [Person]()
    var valueSentFromSignUPPage:String?
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FriendFinder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LOG IN"
        self.navigationController?.navigationBar.isHidden = true
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        email.layer.borderColor = color.cgColor
        email.layer.borderWidth = 2
        email.layer.cornerRadius = 8
        email.placeholder = "  Enter Username"
        email.backgroundColor = UIColor.lightGray
        
        pwd.layer.borderColor = color.cgColor
        pwd.layer.borderWidth = 2
        pwd.layer.cornerRadius = 8
        pwd.placeholder = "  Enter password"
        pwd.backgroundColor = UIColor.lightGray
        
        submit.layer.cornerRadius = 8

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.email.resignFirstResponder()
        self.pwd.resignFirstResponder()
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        // Animation
        label.center.y -= view.bounds.width
        email.center.x -= view.bounds.width
        pwd.center.x += view.bounds.width
        
        UIView.animate(withDuration: 2.0, delay: 0.5, animations: {self.label.center.y += self.view.bounds.width
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            self.email.center.x += self.view.bounds.width
            self.pwd.center.x -= self.view.bounds.width
            self.submit.alpha = 0.5
            self.NewAcc.alpha = 0.8
        }, completion: nil)
        
        UIView.animate(withDuration: 3.0, delay: 2.0, options: [], animations: {self.submit.alpha = 1.0
        }, completion: nil)
    }
    
    //MARK: - ButtonAction
    @IBAction func ForwardAction(_ sender: UIButton) {
        
        // Validation
        if (self.pwd.text?.isEmpty)! || (self.email.text?.isEmpty)! {
            let alt = UIAlertController(title: "Enter Value", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alt.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alt, animated: true, completion: nil)
        }
        else{
            let pd = self.pwd.text
            let un = self.email.text
            let parameters = ["username": un!, "password": pd!] as Dictionary<String, String>
            
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "fetchd", Request_parameter: parameters, sRequest_parameter_Images: nil, status: { (result) in
                
            }, response_Dictionary: { (json) in
                DispatchQueue.main.async {
                    if(json.value(forKey: "resp") as! String == "Success"){
                        self.defaults.set(un , forKey: "user")
                    self.navigationController?.pushViewController(HomeViewController(nibName: "HomeViewController", bundle: nil), animated: true)
                    }
                }

            }, response_Array: { (resultsArr) in
                
            }, isTokenEmbeded: false)
            
        }
        
    }
    
    
    
    @IBAction func signUPAction(_ sender: UIButton) {
        let vc = SignUPViewController(nibName: "SignUPViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
        //Animation
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: [], animations: {
            self.submit.bounds = CGRect(x: UIScreen.main.bounds.origin.x - 20, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width + 60, height: UIScreen.main.bounds.size.height)
            self.submit.isEnabled = false
        }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: [], animations: {
            self.submit.bounds = CGRect(x: UIScreen.main.bounds.origin.x - 20, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.size.width + 60, height: UIScreen.main.bounds.size.height)
            self.submit.isEnabled = false
        }, completion: nil)
    }
    
    //MARK: - Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == email)
        {
            pwd.becomeFirstResponder()
        }
        if (textField == pwd)
        {
            submit.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Next one !!!")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
