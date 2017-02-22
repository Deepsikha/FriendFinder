//
//  SignUPViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/21/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import CoreData

protocol MyProtocol {
    func passvalue(valueSent:String?)
}

class SignUPViewController: UIViewController {
    
        @IBOutlet var firstname: UITextField!
        @IBOutlet var lastname: UITextField!
        @IBOutlet var username: UITextField!
        @IBOutlet var pwd: UITextField!
        @IBOutlet var pwd1: UITextField!
        @IBOutlet var btnsubmit: UIButton!
        
        var persistentContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "FriendFinder")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {
                    
                    fatalError("Unresolved error \(error)")
                }
            })
            return container
        }()
        var delegate:MyProtocol?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "SIGN UP"
            self.navigationController?.navigationBar.isHidden = false
            
            btnsubmit.layer.cornerRadius = 8
            
            //          su.font = su.font.withSize(50)
            // Do any additional setup after loading the view.
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
                let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let pd = pwd.text
            delegate?.passvalue(valueSent: pd)
            self.save(username: username.text!, pwd: pwd.text!)
        }
        
//        store data using CoreData
//                let managedContext = persistentContainer.viewContext
//                let entity = NSEntityDescription.entity(forEntityName: "FriendFinder", in: managedContext)!
//                let person = NSManagedObject(entity: entity, insertInto: managedContext)
//        
//                 person.setValue(username.text, forKey: "username")
//                 person.setValue(pwd.text, forKey: "password")
//        
//                 do {
//                 try managedContext.save()
//                 } catch {}
//        
//                 print(person)
//                 print("Object Saved.")
        func save(username: String, pwd: String) {
            //1
            let managedContext = persistentContainer.viewContext
            
            // 2
            let entity =
                NSEntityDescription.entity(forEntityName: "Person",
                                           in: managedContext)!
            
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            // 3
            person.setValue(username, forKey: "username")
            person.setValue(pwd, forKey: "password")
            print(person)

            // 4
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
}

    
