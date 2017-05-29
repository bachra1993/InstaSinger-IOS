//
//  SearchUserTableViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/14/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SearchUserTableViewController: UITableViewController , UISearchResultsUpdating{
    
    
    
    
    
    
    
    
    
    
    
    var usersArray = [NSDictionary?]()
      var userFilter = [NSDictionary?]()
    var fullUserArray = [String]()
    var filteredItems = [String]()
    var searchControlelr : UISearchController!
    var resultController = UITableViewController()
    
    
    
    
    
    var ref: FIRDatabaseReference!
    var user = UserInfo()
    let loggedInUser = FIRAuth.auth()?.currentUser

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultController.tableView.delegate = self
        self.resultController.tableView.dataSource = self
        
        self.searchControlelr = UISearchController(searchResultsController: resultController)
        self.tableView.tableHeaderView = self.searchControlelr.searchBar
        self.searchControlelr.searchResultsUpdater = self
        
        
        
        
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
                
                
                
                
                
                print(key)
                self.usersArray.append(snapshot)
                print("seeeeeeeeeeeee")
                let name = snapshot?.value(forKey: "fullname") as! String
                self.fullUserArray.append(name)
                self.tableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            }
            
            
            
            
            
            
            
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
    
    
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        /*
        self.filteredItems = self.fullUserArray.filter { (name:String) -> Bool in
            if name.contains(self.searchControlelr.searchBar.text!) {
                return true
            }else {
                return false
            }
        }
        */
      
        

        
        
        
        
        
        
         self.resultController.tableView.reloadData()
           }

        
      

    
      
        
 
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if (tableView == self.tableView)
        {
            return fullUserArray.count
        }else {
            return filteredItems.count
        }
        
        
        
    
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let SearchCell = UITableViewCell()
        if (tableView == self.tableView)
        {
            
            // userArray = self.filteredItems[indexPath.row]
            SearchCell.textLabel?.text = fullUserArray[indexPath.row]
            
            
            
            
            
        }else {
            
            
            
            
            
            // userArray = self.fullUserArray[indexPath.row]
            SearchCell.textLabel?.text = filteredItems[indexPath.row]
            
            
            
            
            
        }
        
        
        
        
        
        
        
        return SearchCell
        
        
        
    }
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.performSegue(withIdentifier: "userInfo", sender: indexPath);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if (tableView == self.tableView)
        {
            if segue.identifier == "userInfo" {
                print("seguuuue show ussser")
                if let indexPath = tableView.indexPathForSelectedRow {
                    let user = usersArray[indexPath.row]
                    let controller = segue.destination as? OtherProfileViewController
                    controller?.otherUser = user
                    
                }
            }
        }else {
            if segue.identifier == "userInfo" {
                print("seguuuue show ussser")
                if let indexPath = tableView.indexPathForSelectedRow {
                  //  userFilter =
                    let user = userFilter[indexPath.row]
                    let controller = segue.destination as? OtherProfileViewController
                    controller?.otherUser = user
                    
                }
            }
        }

       
    }
    
    
    
    

    }
