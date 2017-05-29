//
//  ViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import FirebaseStorage

class TrashViewController: UIViewController {
    
    

    var NS : NSURL!
    

    override func viewDidLoad() {
       // test()
        
        super.viewDidLoad()
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreafted.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
   
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var text1: UITextField!
    
    
    @IBOutlet weak var text2: UITextField!
    
    
    @IBAction func SignIn(_ sender: Any) {
        
        
        FIRAuth.auth()?.createUser(withEmail: text1.text!, password: text2.text!) { (user, error) in
            // ...
            if let user = user{
                
                
                let Myuser : [String : AnyObject] = ["email" : self.text1.text as AnyObject,"password" : self.text2.text as AnyObject]
                
                var ref: FIRDatabaseReference!
                
                ref = FIRDatabase.database().reference()
                ref.child("users").child(user.uid).setValue(Myuser)
           
                
               
                print(error?.localizedDescription as Any)
            }
            else{
                
                print(error?.localizedDescription as Any)
            }
        }
        
        
    }
    
    
    
    
    @IBAction func LogIn(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: text1.text!, password: text2.text!) { (user, error) in
            // ...
            if let user = user{
                
                print("User Loged")
                print(user.uid)
                print(error?.localizedDescription as Any)
            }
            else{
                print("user not Loged")
            
                print(error?.localizedDescription as Any)
            }
        }

        }







   
    @IBOutlet weak var myImage: UIImageView!
    
    
    @IBAction func SaveTest(_ sender: Any) {
    /*
        let titre = "Hello"
        let message = "4eme"
          let post : [String : AnyObject] = ["titre" : titre as AnyObject,"message" : message as AnyObject]
        
         var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("Post").child("ok").childByAutoId().setValue(post)
        
        
       */
        
        /*
        let filename = "test.png"
        
        var image = UIImage()
        image = myImage.image!
        let imageData = UIImagePNGRepresentation(image)
        let uplaod = FIRStorage.storage().reference().child(filename).put(imageData!, metadata: nil)
        { (metadata, error) in
            
            if (error != nil ) {
                  print(error?.localizedDescription)
            }else
            {
                  print(error?.localizedDescription)
            }
            
            
            
        }
      
        
        
        let observer = uplaod.observe(.progress) { snapshot in
            // A progress event occurred
        
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print(percentComplete)
            }
        }*/
        
        
    }
    
  
    
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        
        print("retrive")
        
        
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
  
        
        ref.child("Post").queryOrderedByKey().observe(.childAdded, with: {
            
            snapshot in
            
            
            
        let  test = snapshot.childSnapshot(forPath: "message").value as! String
            
                 print(test)
            
            
            
            
            
        }){ (error) in
            print(error.localizedDescription)
        
  
        

    }
    
    
 */
}

}




        
  













