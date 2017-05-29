//
//  SearchUserViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/11/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SearchUserViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    
    let followsearchControllerBar = UISearchController(searchResultsController: nil )

    
    @IBOutlet weak var followUserTableView: UITableView!
    var usersArray = [NSDictionary?]()
    var ref: FIRDatabaseReference!
    var user = UserInfo()
    let loggedInUser = FIRAuth.auth()?.currentUser
    var filtreusersArray = [NSDictionary?]()
    
    var namearray = [String]()
    
    func filtreContext(searchText: String , scope: String = "ALL" )
    {
        filtreusersArray.removeAll()
        print("filtter begins ........")
        print(namearray)
        
        for (index,element) in namearray.enumerated() {
            
            print(element)
            if (element.contains(searchText))
                //(element.lowercased().range(of: searchText) != nil)
            {
                print(element)
                self.filtreusersArray.append(usersArray[index])
                
            }
            
            
        }
        
        
        self.followUserTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followsearchControllerBar.searchResultsUpdater = self
        followsearchControllerBar.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        
        followUserTableView.tableHeaderView = followsearchControllerBar.searchBar
        
        print("madridddd")
        
        
        let  ref = FIRDatabase.database().reference()
        
        
        
        
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            
            
            
            print("research start")
            
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
            
            
            if(key == self.user.getCurrentUserUid())
            {
                print("Same as logged in user, so don't show!")
            }
            else
            {
                let fullname : String = (snapshot?.value(forKey: "fullname") as! String?)!
                self.namearray.append(fullname)
                print(key)
                self.usersArray.append(snapshot)
                self.followUserTableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            }
            self.followUserTableView.reloadData()
            
            
            
            
            
            
            /*
             let  test = snapshot.childSnapshot(forPath: "fullname").value as? String?
             
             print(test)
             
             */
            
            
            
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        
  
        let  ref = FIRDatabase.database().reference()

        let userD : NSDictionary?
        if (followsearchControllerBar.isActive && followsearchControllerBar.searchBar.text != "")
        {
            userD = self.filtreusersArray[indexPath.row]
        }
        else
        {
            userD = self.usersArray[indexPath.row]
        }
        
        
        
        
        let OtherUid = userD?["uid"] as! String
        let currentUID = user.getCurrentUserUid()
        
        let message : [String : AnyObject] = ["fromId" : currentUID as AnyObject,
                                              "text" : "This user want to chat with you ! " as AnyObject  ,
                                              "time" : "date" as AnyObject,
                                              "toId" : OtherUid as AnyObject ,
                                              
                                              
                                              ]
        
        
  
        let key =  ref.child("User_Message").child(currentUID).child(OtherUid).childByAutoId().key

        
        ref.child("User_Message").child(user.getCurrentUserUid()).child(OtherUid).child(key).setValue("1")
        ref.child("User_Message").child(OtherUid).child(user.getCurrentUserUid()).child(key).setValue("1")
        ref.child("Messages").child(key).setValue(message)
        
        
        let alert = UIAlertController(title: "Done", message: "Conversertion started Check your messages ", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
        
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Message"
    }
    
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (followsearchControllerBar.isActive && followsearchControllerBar.searchBar.text != "")
        {
            return filtreusersArray.count
        }
        return usersArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let SearchCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")!
        
        let fullNameLabel:UILabel = SearchCell.viewWithTag(200) as! UILabel
        let followersLabel:UILabel = SearchCell.viewWithTag(201) as! UILabel

        let Picture:UIImageView = SearchCell.viewWithTag(100) as! UIImageView
        
        let user : NSDictionary?
        if (followsearchControllerBar.isActive && followsearchControllerBar.searchBar.text != "")
        {
            user = self.filtreusersArray[indexPath.row]
        }
        else
        {
            user = self.usersArray[indexPath.row]
        }
        

        
        
        print("list of users ")
        
        
        let url = URL(string: (user?.value(forKey: "profilePictureURL") as! String))
        print("test el search view ")
        
        
        
        Picture.kf.setImage(with: url)
        
        Picture.layer.cornerRadius = Picture.frame.size.width / 2
        Picture.layer.masksToBounds = true
        
        Picture.layer.borderWidth = 2
        Picture.layer.borderColor = UIColor.white.cgColor
        
        fullNameLabel.text = user?.value(forKey: "fullname") as! String?
        
        let followersCount = user?.value(forKey: "followersCount")as? NSNumber

        
        
        
       
        
        if (followersCount != nil){
            
            followersLabel.text = ("Followers:" + " " + "\(followersCount!)")
            
        }else{
            followersLabel.text = ("Followers:" + " " + "0")
            
            
        }


        
        
        
        
        return SearchCell
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowUser" {
                
                
                if (followsearchControllerBar.isActive && followsearchControllerBar.searchBar.text != "")
                {
                    if let indexPath = followUserTableView.indexPathForSelectedRow {
                        let user = filtreusersArray[indexPath.row]
                        let controller = segue.destination as? OtherProfileViewController
                        controller?.otherUser = user
                        
                    }
                }
                else
                {
                    if let indexPath = followUserTableView.indexPathForSelectedRow {
                        let user = usersArray[indexPath.row]
                        let controller = segue.destination as? OtherProfileViewController
                        controller?.otherUser = user
                        
                    }
                }
                
                
            }
        
      
        
        }
    
}



        







extension SearchUserViewController : UISearchResultsUpdating
{
    
    func updateSearchResults(for searchController: UISearchController) {
        filtreContext(searchText: followsearchControllerBar.searchBar.text!)
    }
    
}






