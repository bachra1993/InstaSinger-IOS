//
//  UserInfo.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/9/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UserInfo : NSObject {
    
    let email : String! = ""
    let fullname : String! = ""
    let profilePictureURL : String! = ""
    let username : String! = ""
    
    
    
    func getCurrentUserUid() -> String{
        
        
        if let user = FIRAuth.auth()?.currentUser {
            
            let uid = user.uid;
            
            
            return uid
            
            
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
        } else {
            return "No User"
            // No user is signed in.
        }
        
        
        
        
     
        
        
    }
    
    
    
    
    
    
}
