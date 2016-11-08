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

class ViewController: UIViewController {
    
    

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
                print(user.email)
                
                print("User Cretaed")
                print(user)
                print(error?.localizedDescription)
            }
            else{
                print("user not created")
                print(user)
                print(error?.localizedDescription)
            }
        }
        
        
    }
    
    
    
    
    @IBAction func LogIn(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: text1.text!, password: text2.text!) { (user, error) in
            // ...
            if let user = user{
                print(user.email)
                
                print("User Loged")
                print(user)
                print(error?.localizedDescription)
            }
            else{
                print("user not Loged")
                print(user)
                print(error?.localizedDescription)
            }
        }

        }
        
  
    
    
    
    
    
    
    
   }













