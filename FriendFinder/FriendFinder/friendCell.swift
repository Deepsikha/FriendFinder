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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        session = URLSession.shared
        task = URLSessionDataTask()
        imageProfile.layer.borderWidth = 1.0
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
    }
        func reloadTable(){
            let url:URL! = URL(string: "http://127.0.0.1:8085/chkFnd")
            task = session.dataTask(with: url, completionHandler: { (location: Data?, response: URLResponse?, error: Error?) -> Void in
                if location != nil{
                    let data:Data! = location!
                    do{
                        let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                        print(dic)
                        self.data = dic.value(forKey : "data") as? [AnyObject]
                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.tblView.reloadData()
//                            self.refresh?.endRefreshing()
                            if self.data[0] as! Decimal == 1 {
                                self.btnAdd.setImage(UIImage(named: "addfriend"), for: .normal)
                            }else {
                                self.btnAdd.setImage(UIImage(named: "removefriend"), for: .normal)
                            }
                        })
                    }catch{
                        //print("something went wrong, try again")
                    }
                }
            })
            task.resume()
        }
        


    @IBAction func btnAddAction(_ sender: UIButton) {
        btnAdd.setImage(UIImage(named: "removefriend"), for: .normal)
        reloadTable()
    }
    
}
