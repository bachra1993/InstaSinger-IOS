//
//  CommentsViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 12/8/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CommentsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var CommentsKey:String?
    var listComments = [NSDictionary?]()
     var listKeys = [String?]()
    
    
    var user = UserInfo()
    var userUID : String!


    @IBOutlet weak var textInput: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


    print("passed key ")
        
        
        textInput.layer.borderColor = UIColor(colorLiteralRed: 74/255, green: 144/255, blue: 226/255, alpha: 100).cgColor
        textInput.layer.borderWidth = 1
        textInput.layer.cornerRadius = 25
        print("nijib bel base")
        print(CommentsKey!)
        
        let  ref = FIRDatabase.database().reference()

        
        ref.child("comments").child(CommentsKey!).observe(.childAdded, with: { (snapshot) in
            

       // print (snapshot)
            let dictionary = snapshot.value as? [String : AnyObject]
            self.listComments.append(dictionary as NSDictionary?)
            self.listKeys.append(snapshot.key)
           print(dictionary?["text"] )
            
            
                 self.tableView.insertRows(at: [IndexPath(row:self.listComments.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            
        
        
        
        
         })
        
        
        print("get current user")
        
        
      
      
        
        
        
        
        
    }

    @IBAction func SendComments(_ sender: Any) {
        userUID = user.getCurrentUserUid()
        var ref: FIRDatabaseReference!
        print(userUID)
        ref = FIRDatabase.database().reference()
        
        
        
        ref.child("users").child(userUID).observe(.value, with: { (snapshot) in
            
            
            print(snapshot)
            
            let snapshot = snapshot.value as! [String: AnyObject]
            
            
            let date = NSDate()
            let calendar = NSCalendar.current
            let hour = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            let day = calendar.component(.day, from: date as Date)
            let month = calendar.component(.month, from: date as Date)
            let year = calendar.component(.year, from: date as Date)
            
            
            
            let dateToSend = "\(hour):\(minutes) - \(day)/\(month)/\(year)"
            
            
            print(dateToSend)
            
         

            
            
            
            let comments : [String : AnyObject] = ["date" : dateToSend as AnyObject,
                                                   "text" : self.textInput.text as AnyObject  ,
                                                   "userPostedName" : snapshot["fullname"]!,
                                                   "userId" : self.userUID as AnyObject ,
                                                   "userPostedPicture" : snapshot["profilePictureURL"]!,
                                                   "userPostedUsername" : snapshot["username"]!,
                                                   
                                                   
                                                   
                                                   ]
            
            let  ref = FIRDatabase.database().reference()
            
            
            
            ref.child("comments").child(self.CommentsKey!).childByAutoId().setValue(comments)
            
            
            self.textInput.text = ""
            
            
            
            
            
            
            
            
            
            
            
        }){ (error) in
            print(error.localizedDescription)
            
            
            
            
        }

        
      

        print(textInput.text)
        view.endEditing(true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        
        userUID = user.getCurrentUserUid()

        print("delete button pressed")
        print(indexPath.row)
        
        let comment : NSDictionary?
        comment = self.listComments[indexPath.row]
        
        
        
        print(comment)
        print(listKeys[indexPath.row])
        let commentUserUid = comment?.value(forKey: "userId")
        let  ref = FIRDatabase.database().reference()
        
        
        
        
        

        
        
        print(userUID)
        
        
        if ( userUID == commentUserUid  as! String) {
            
        
            
        print("Comment should be deleted")
            ref.child("comments").child(self.CommentsKey!).child(listKeys[indexPath.row]!).removeValue()
            
            
            listComments.remove(at: indexPath.row)
            listKeys.remove(at: indexPath.row)
            
            tableView.reloadData()
            
            
            
        }else {
            let alert = UIAlertController(title: "Warning", message: "You can't delete this comment", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  listComments.count ;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let CommentCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")!
        
        
        let comment : NSDictionary?
        comment = self.listComments[indexPath.row]
        
        
        
      
        let Picture:UIImageView = CommentCell.viewWithTag(100) as! UIImageView
        
          let NameLabel:UILabel = CommentCell.viewWithTag(200) as! UILabel
                 let TextLabel:UILabel = CommentCell.viewWithTag(201) as! UILabel
        let DateLabel:UILabel = CommentCell.viewWithTag(202) as! UILabel

        
        
        
        Picture.layer.cornerRadius = Picture.frame.size.width / 2
        Picture.layer.masksToBounds = true
        
        
        
        Picture.layer.borderWidth = 1
        Picture.layer.borderColor = UIColor(colorLiteralRed: 74/255, green: 144/255, blue: 226/255, alpha: 100).cgColor
        
        let url = URL(string: (comment?.value(forKey: "userPostedPicture") as! String))
        Picture.kf.setImage(with: url)

        NameLabel.text = comment?.value(forKey: "userPostedName") as! String?
        TextLabel.text = comment?.value(forKey: "text") as! String?
        DateLabel.text = comment?.value(forKey: "date") as! String?


        
        
        
        
        return CommentCell
        
    }
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

    @IBAction func back(_ sender: Any) {
 self.dismiss(animated: true, completion: nil)    }
    
    
    
    
    
    
    
    
    
    
    
    func UserDetail() {
        
        userUID = user.getCurrentUserUid()
        var ref: FIRDatabaseReference!
        print(userUID)
        ref = FIRDatabase.database().reference()
        
        
        
        ref.child("users").child(userUID).observe(.value, with: { (snapshot) in
            
            
            print(snapshot)
        
           
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }){ (error) in
            print(error.localizedDescription)
            
            
            
            
        }
        
        
    }
    
    
    
    
    
}
