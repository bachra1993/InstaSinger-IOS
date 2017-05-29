//
//  FollowersViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/14/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
class FollowersViewController: UIViewController , UITableViewDataSource ,UITableViewDelegate {

    @IBOutlet weak var FollowersTableView: UITableView!
    
    var ref: FIRDatabaseReference!
    
    var user:String?
    
    
    var listFollowers = [NSDictionary?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("followers").child(self.user!).queryOrdered(byChild: "fullname").observe(.childAdded, with: { (snapshot) in
            print("data returnd")
            print(snapshot)
            
            let snapshot = snapshot.value as? NSDictionary
            
            //add the users to the array
            self.listFollowers.append(snapshot)
            
            self.FollowersTableView.insertRows(at: [IndexPath(row:self.listFollowers.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFollowers.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let FollowingCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell")!
        
        
        let fullNameLabel:UILabel = FollowingCell.viewWithTag(200) as! UILabel
        let Picture:UIImageView = FollowingCell.viewWithTag(100) as! UIImageView
        
        
        
        let user : NSDictionary?
        user = self.listFollowers[indexPath.row]
        
        let url = URL(string: (user?.value(forKey: "profilePictureURL") as! String))
        
        Picture.kf.setImage(with: url)
        Picture.layer.cornerRadius = Picture.frame.size.width / 2
        Picture.layer.masksToBounds = true
        
        Picture.layer.borderWidth = 2
        Picture.layer.borderColor = UIColor.white.cgColor
        
        
        
        print("list of users ")
        //  print(user.email)
        //   FollowingCell.textLabel?.text = user?.value(forKey: "fullname") as! String?
        
        fullNameLabel.text = user?.value(forKey: "fullname") as! String?
        
        
        
        
        
        
        //  SearchCell.textLabel?.text = "hello"
        
        
        return FollowingCell
        
        
        
    }
    
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    


}
