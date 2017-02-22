//
//  SignUPViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/21/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit


class SignUPViewController: UIViewController {
    
    @IBOutlet var fet: UIButton!
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
                let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
                let link = "http://127.0.0.1:8085/test"
            let parameters = ["name":"Abhishek1","surname": "ABCD","username":"1234", "password":"Master1"] as Dictionary<String, String>
                let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
                
                let session = URLSession.shared
                request.httpMethod = "POST"
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let task = session.dataTask(with: request as URLRequest) { data, response, error in
                    guard data != nil else {
                        print("no data found: \(error)")
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            print("Response: \(json)")
                        } else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    } catch let parseError {
                        print(parseError)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                }
                
                task.resume()
            
                
            
        }
    
    @IBAction func fet(_ sender: Any) {
            let link = "http://127.0.0.1:8085/fetch/"
            let url:URL = URL(string: link)!
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (
                data, response, error) in
                guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                    return
                }
                self.extract_json(data!)
            })
            task.resume()
    }
    
        func extract_json(_ data: Data)
        {
            print(data)
            let json: Any?
            do
            {
                json = try JSONSerialization.jsonObject(with: data, options: [])
            }
            catch
            {
                return
            }
 
            guard let data_list = json as? NSArray else
            {
                return
            }
            if let countries_list = json as? NSArray
            {
                for i in 0 ..< data_list.count
                {
                    if let country_obj = countries_list[i] as? NSDictionary
                    {
                        if let country_name = country_obj["name"] as? String
                        {
                            if let country_code = country_obj["password"] as? String
                            {
                                
                                TableData.append("Name: " + country_name + "Password: " + country_code)
                                print(country_obj)
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async(execute: {})
            
        }

    
    
}

    
