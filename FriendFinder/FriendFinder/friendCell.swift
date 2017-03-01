//
//  friendCell.swift
//  FriendFinder
//
//  Created by devloper65 on 2/22/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class friendCell: UITableViewCell {

    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var lblname: UILabel!
    @IBOutlet var btnAdd: UIButton!
    var data: [AnyObject]!
    var session: URLSession!
    var task: URLSessionDataTask!
    var status: Int!
    var Controller: FriendViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        session = URLSession.shared
        task = URLSessionDataTask()
        imageProfile.layer.borderWidth = 1.0
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
        
    }
    func reloadTable(_ user_id: String){
            let parameters:[String:String]? = ["username": UserDefaults.standard.value(forKey: "user") as! String,"user_id":user_id]
            
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "chkRelation", Request_parameter: parameters, Request_parameter_Images: nil, status: {(result) in
            }, response_Dictionary: { (json) in
                DispatchQueue.main.async {
                    if json.value(forKey: "resp") as! String == "friends" {
                        self.btnAdd.setImage(UIImage(named: "removefriend"), for: .normal)
                        self.status = 1
                    }else if json.value(forKey: "resp") as! String == "not" {
                        self.btnAdd.setImage(UIImage(named: "addfriend"), for: .normal)
                        self.status = 0
                    }else{
                        self.btnAdd.setImage(UIImage(named: "blank"), for: .normal)
                        self.btnAdd.isEnabled = false
                    }
                }
            }, response_Array: { (resultArr) in
                
            }, isTokenEmbeded: false)
        }
        
    func changeBtn(){
        if(status == 1){
            self.btnAdd.setImage(UIImage(named: "removefriend"), for: .normal)
        }else{
            self.btnAdd.setImage(UIImage(named: "addfriend"), for: .normal)
        }
        
    }
    
    func unfriend(){
        let parameter = ["user1":UserDefaults.standard.value(forKey: "user") as! String,"user2":self.lblname.text!,"signal":"2"]
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "changeRelation", Request_parameter: parameter, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            DispatchQueue.main.async {
                if json.value(forKey: "resp") as! String == "changed" {
                    self.subviews.last?.removeFromSuperview()
                    self.btnAdd.isHidden = false
                    if self.status == 1{
                        self.status = 0
                    }else{
                        self.status = 1
                    }
                    self.changeBtn()
                    self.Controller.fetchData()
                }else{
                    UIView.animate(withDuration: 0.6, animations: {
                        self.subviews.last?.removeFromSuperview()
                    })
                    let lbl = UILabel(frame: self.btnAdd.frame)
                    lbl.text = "error"
                    lbl.textColor = UIColor.red
                    self.addSubview(lbl)
                    UIView.animate(withDuration: 0.6, animations: {
                        self.subviews.last?.removeFromSuperview()
                    })
                }
            }
        }, response_Array: { (arr) in
            
        }, isTokenEmbeded: false)
    }
    
    @IBAction func changeRelation(_ sender: Any) {
        var parameter:[String:String] = [:]
        if(status == 1){
            btnAdd.isHidden = true
            let btnRelation = UIButton(frame: CGRect(x:btnAdd.frame.origin.x - 70,y:btnAdd.frame.origin.y,width: 100,height: 40))
            btnRelation.setTitle("Confirm", for: .normal)
            btnRelation.layer.cornerRadius = 5
            btnRelation.layer.borderWidth = 1
            btnRelation.setTitleColor(UIColor.blue, for: .normal)
            btnRelation.backgroundColor = UIColor.clear
            btnRelation.addTarget(self, action: #selector(unfriend), for: .touchDown)
            self.addSubview(btnRelation)
        }else{
            parameter = ["user1":UserDefaults.standard.value(forKey: "user") as! String,"user2":self.lblname.text!,"signal":"1"]
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "changeRelation", Request_parameter: parameter, Request_parameter_Images: nil, status: { (result) in
                
            }, response_Dictionary: { (json) in
                DispatchQueue.main.async {
                    if json.value(forKey: "resp") as! String == "changed" {
                        if self.status == 1{
                            self.status = 0
                        }else{
                            self.status = 1
                        }
                        self.changeBtn()
                        self.Controller.fetchData()
                    }else{
                        UIView.animate(withDuration: 0.6, animations: {
                            self.subviews.last?.removeFromSuperview()
                        })
                        let lbl = UILabel(frame: self.btnAdd.frame)
                        lbl.text = "error"
                        lbl.textColor = UIColor.red
                        self.addSubview(lbl)
                        UIView.animate(withDuration: 0.6, animations: {
                            self.subviews.last?.removeFromSuperview()
                        })
                    }
                }
            }, response_Array: { (arr) in
                
            }, isTokenEmbeded: false)
        }
        
    }
    
    
    
}
