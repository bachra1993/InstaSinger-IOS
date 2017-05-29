//
//  OtherProfileViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/12/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVKit



class OtherProfileViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    
    var otherUser:NSDictionary?
    var loggedInUserData:NSDictionary?
    let loggedInUser = FIRAuth.auth()?.currentUser
    
    var databaseRef:FIRDatabaseReference!
    var  profilePictureURL : String!
    var videos = [Videos]()
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var videoURL = NSURL()
    var  KeyUser : String?
    

    @IBOutlet weak var followers_btn: UIButton!
    
    @IBOutlet weak var followingBtn: UIButton!
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var activityAnimation: UIActivityIndicatorView!

    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblFullName: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityAnimation.startAnimating()
        
        self.LoadUserProfile()


        
       
        self.fetchVideos()
        
        
        
        //create a reference to the firebase database
        databaseRef = FIRDatabase.database().reference()
        
        //add an observer for the logged in user
        databaseRef.child("users").child(self.loggedInUser!.uid).observe(FIRDataEventType.value, with: { (snapshott) in
            
            print("VALUE CHANGED IN USER_PROFILES")
            self.loggedInUserData = snapshott.value as? NSDictionary
            //store the key in the users data variable
            self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
            print("Current User Modha Fuckkka ")
                print(snapshott)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //add an observer for the user who's profile is being viewed
        //When the followers count is changed, it is updated here!
        //need to add the uid to the user's data
        databaseRef.child("users").child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            
            
        print("khaled")
            print(snapshot.key)
            

            let uid = self.otherUser?["uid"] as! String
            self.otherUser = snapshot.value as? NSDictionary
            //add the uid to the profile
            self.otherUser?.setValue(uid, forKey: "uid")
            
            print("Profile User Modha Fuckkka ")
            print(snapshot)
         
            
            

            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        //check if the current user is being followed
        //if yes, Enable the UNfollow button
        //if no, Enable the Follow button
        
        databaseRef.child("following").child(self.loggedInUser!.uid).child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if(snapshot.exists())
            {
                self.followBtn.setTitle("Following", for: .normal)
                self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "is_following"), for: .normal)
                
                print("You are following the user")
                

                
                
            }
            else
            {
                self.followBtn.setTitle("Follow", for: .normal)
                self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "not_following"), for: .normal)

                print("You are not following the user")
                           }
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
        
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   videos.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        
        let ImageSong:UIImageView = cell.viewWithTag(201) as! UIImageView

        
     
        let myvideo = videos[indexPath.row]
        
        
        
        
        
        
        
        
        
        
        let url = URL(string: (myvideo.songPicture as String))
        
        
        ImageSong.kf.setImage(with: url)

        
        
        
        
        
        
        
        
        return cell
        
    }
    
    
    @IBAction func FollowBtn(_ sender: Any) {
        
        
        
        
        
        
        
        
        
        let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
        
        
        if(self.followBtn.titleLabel?.text == "Follow")
        {
            print("follow user")
            self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "is_following"), for: .normal)

           
            
            
            let followersData = ["fullname":self.loggedInUserData?["fullname"] as! String,
                                 
                                 "profilePictureURL":self.loggedInUserData?["profilePictureURL"]]
            
            let followingData = ["fullname":self.otherUser?["fullname"] as! String,
                                 
                                 "profilePictureURL":self.otherUser?["profilePictureURL"]]
            
            //"profile_pic":self.otherUser?["profile_pic"] != nil ? self.loggedInUserData?["profile_pic"] as! String : ""
            let childUpdates = [followersRef:followersData,
                                followingRef:followingData]
            
            
            databaseRef.updateChildValues(childUpdates)
            // self.followBtn.titleLabel?.text = "following"
            
            print("data updated")
            
            
            
            //update following count under the logged in user
            //update followers count in the user that is being followed
            let followersCount:Int?
            let followingCount:Int?
            if(self.otherUser?["followersCount"] == nil)
            {
                //set the follower count to 1
                followersCount=1
            }
            else
            {
                followersCount = self.otherUser?["followersCount"] as! Int + 1
            }
            
            //check if logged in user  is following anyone
            //if not following anyone then set the value of followingCount to 1
            if(self.loggedInUserData?["followingCount"] == nil)
            {
                followingCount = 1
            }
                //else just add one to the current following count
            else
            {
                
                followingCount = self.loggedInUserData?["followingCount"] as! Int + 1
            }
            
            databaseRef.child("users").child(self.loggedInUser!.uid).child("followingCount").setValue(followingCount!)
            databaseRef.child("users").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(followersCount!)
            
            
            
            
            
            
            
            
            
            
        }
            
            
            
            
            
            
            
        else
        {
            
            
            
            
            //Lowering Counting Values
            
            databaseRef.child("users").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int - 1)
            databaseRef.child("users").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(self.otherUser!["followersCount"] as! Int - 1)

            self.followBtn.setBackgroundImage(#imageLiteral(resourceName: "not_following"), for: .normal)

            
            
            
            
            
            let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
            let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
            
            
            
            
            
            
            
            
            
            
            
            
            let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
            databaseRef.updateChildValues(childUpdates)
            
            
            
        }
        
        

    }
    
 
    
    
 

    
    //Load Selected User Profile
    
    func LoadUserProfile() {
        self.KeyUser = self.otherUser?["uid"] as? String
        
        
        
    

        
        
        profilePictureURL = self.otherUser?["profilePictureURL"] as? String
        lblFullName.text = self.otherUser?["fullname"] as? String
        let username =  self.otherUser?["username"] as? String
        let followingCount = self.otherUser?["followingCount"] as? NSNumber
        let followersCount = self.otherUser?["followersCount"] as? NSNumber
        
        
  
        
        
       lblUserName.text = "@" + username!
        
        
        //Loading picture with caching
        let url = URL(string: self.profilePictureURL)
        self.profilePicture.kf.setImage(with: url)
      //  self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.layer.masksToBounds = true
        
        self.profilePicture.layer.borderWidth = 2
        self.profilePicture.layer.borderColor = UIColor.white.cgColor
        
        
        
        self.activityAnimation.stopAnimating()
        self.activityAnimation.hidesWhenStopped = true
        
        
        
        
        
        
        
        
        
        
        
        
        if (followingCount != nil)
        {
            self.followingBtn.setTitle("Following" + " " + "\(followingCount!)", for: .normal)
            
        }
        else {
            self.followingBtn.setTitle("Following" + " " + "0", for: .normal)
            
        }
        
        if (followersCount != nil){
            
            self.followers_btn.setTitle("Followers" + " " + "\(followersCount!)", for: .normal)
            
        }else{
            self.followers_btn.setTitle("Followers" + " " + "0", for: .normal)
            
            
        }
        
        
        
        
        
        
        
        
        
        
        /*
        
        print(" image url ")
            print (profilePictureURL)
        
         guard let url = URL(string:profilePictureURL as! String) else { return }
         URLSession.shared.dataTask(with: url) { (data, response, error) in
         if error != nil {
         print("Failed fetching image:", error)
         return
         }
         
         guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
         print("Not a proper HTTPURLResponse or statusCode")
         return
         }
         
         DispatchQueue.main.async {
         
            //Profile Picture Round
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
            self.profilePicture.layer.masksToBounds = true

            

            self.profilePicture.layer.borderWidth = 2
            self.profilePicture.layer.borderColor = UIColor.white.cgColor
            self.activityAnimation.stopAnimating()
            self.activityAnimation.hidesWhenStopped = true

         self.profilePicture.image = UIImage(data: data!)
         }
         }.resume()
 */
        

    }
    
    
    
    
    // load Selected User Videos
    
    
    func fetchVideos(){
    
        databaseRef = FIRDatabase.database().reference()
        
        
        databaseRef.child("videos").child((self.otherUser?["uid"] as? String)!).observe(FIRDataEventType.childAdded, with: {
            
            snapshot in
            
            if let dictionary = snapshot.value as? [String : AnyObject]{
                let video = Videos()
                video.setValuesForKeys(dictionary)
                self.videos.append(video)
 
                print(video.URL)
                
                DispatchQueue.main.async(execute: {
                    
                    self.collectionView.reloadData()
                    
                    
                })

            }
            
            
            
            
            
            
        }){ (error) in
            print(error.localizedDescription)
            
            
            
            
        }
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //CollectionView Display Configuration 
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    
    @IBAction func BachHome(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showFollowingTableViewController")
        {
           // print("user to pass")
           // print(otherUser?.value(forKey: "uid") as! String)
            
            let showFollowingTableViewController = segue.destination as! FollowingViewController
            showFollowingTableViewController.user = KeyUser
            
        }
        
        else if(segue.identifier == "showFollowersTableViewController")
        {
            let showFollowersTableViewController = segue.destination as! FollowersViewController
            showFollowersTableViewController.user = KeyUser
            
        }
        
        
        
            
   
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let myvideo = videos[indexPath.row]
        
        
        
        
        
        self.videoURL = NSURL(string: myvideo.URL)!
        
        
        
        
        
        
        
        
        let playerItem = AVPlayer(url: videoURL as URL)
        
        let playerController = AVPlayerViewController()
        playerController.player = playerItem
        self.present(playerController, animated: true) {
            playerItem.play()
        }
    }

    

    
    
    

}






