//
//  MessageViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 1/3/17.
//  Copyright © 2017 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MessageViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var userUID : String!
       var user = UserInfo()
    
    
        var listMessage = [NSDictionary?]()
    
        var usersArray = [String?]()
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

   
    }
    
    
    @IBAction func HowToSend(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Chat", message: "Swipe Left from the Search view to start new conversation", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        listMessage.removeAll()
        usersArray.removeAll()
       
        
        userUID = user.getCurrentUserUid()
        
        print("interface message")
        
        
        let  ref = FIRDatabase.database().reference()
    
        
        ref.child("User_Message").child(userUID).observe(
            .childAdded, with: { (snapshot) in
                
                
                // print (snapshot)
                let dictionary = snapshot.value as? [String : AnyObject]
                
                
                
                ref.child("users").child(snapshot.key).observe(.value, with: { (snapshot) in
                    
                    
                    let dictionary = snapshot.value as? [String : AnyObject]
                    
                    
                    print("user info")
                    print(snapshot)
                    self.listMessage.append(dictionary as NSDictionary?)
                    self.usersArray.append(snapshot.key)
                    
                    
                  self.tableView.reloadData()
                    
                    
                })
                
                
                
                
                print(snapshot.key)
                // print(dictionary)
                
                
                //
                
                
                
        })

    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMessage.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MessageCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")!
        
        
        let fullNameLabel:UILabel = MessageCell.viewWithTag(100) as! UILabel
        let Picture:UIImageView = MessageCell.viewWithTag(200) as! UIImageView
        
        
        let message : NSDictionary?
        message = self.listMessage[indexPath.row]
        
        let url = URL(string: (message?.value(forKey: "profilePictureURL") as! String))
        
        
        
        
        
        fullNameLabel.text = message?.value(forKey: "fullname") as! String?
        Picture.kf.setImage(with: url)
        
        
        Picture.layer.cornerRadius = Picture.frame.size.width / 2
        Picture.layer.masksToBounds = true
        
        Picture.layer.borderWidth = 2
        Picture.layer.borderColor = UIColor.white.cgColor
        
        return MessageCell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
        

        
        print("salem")
        print(indexPath.row)
        let userM = usersArray[indexPath.row]
        print(  userM)
        
        
    }
    
    
    
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let userM = usersArray[(indexPath?.row)!]
        let userS = listMessage[(indexPath?.row)!]
        let userNameToSend =  userS?.value(forKey: "fullname") as! String
       
       
        
   
        let controller = segue.destination as? SendMessageViewController
        controller?.userUID = userM
        controller?.userName = userNameToSend
     
  

        

        
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
