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
        


    @IBAction func btnAddAction(_ sender: UIButton) {
        print(status)
    }
    
}
