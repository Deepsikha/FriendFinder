//
//  ForgotController.swift
//  FriendFinder
//
//  Created by Developer88 on 2/27/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ForgotController: UIViewController {
    
    @IBOutlet var reset: UIButton!
    @IBOutlet var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func bck(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rest(_ sender: Any) {
        
        let pass = randomString(length: 10)
        let parameters = ["email" : self.email.text!,"password": pass]
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "contact", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (param) in
            
        }, response_Array: { (param) in
            
        }, isTokenEmbeded: false)
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }


    

}
