//
//  TestViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/8/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVKit
import AVFoundation
import EZLoadingActivity

import GoogleSignIn
import FacebookLogin

import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController  , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
  //  @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var followers_btn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    var videos = [Videos]()
    var user = UserInfo()
    var userUID : String!
    var videoURL = NSURL()
    var  profilePictureURL : String!
    var url = NSURL()
    var loggedInUser : AnyObject?
    
    var keyUser : String?
    
    
    
    
     var testuser:String?

    
   // @IBOutlet weak var navigTab: UINavigationBar!
    
    var player = AVPlayer()
    
    @IBOutlet weak var activityAnimation: UIActivityIndicatorView!
    
    
    var playerLayer = AVPlayerLayer()
    
 
    
    
    
    
    
   

    override func viewDidLoad() {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.videos.removeAll()

      ///  self.activityAnimation.startAnimating()
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        // backView.layer.addSublayer(gradient)
        //  backView.colo = [UIColor.white.cgColor, UIColor.black.cgColor]
        
        print("current user loged i n"+user.getCurrentUserUid())
        fetchVideos()
        UserDetail()
        
        print("test url")
        
        
        
        
        
       
        
        
        
        self.collectionView.reloadData()
        
        
        
        
        
        //Profile Picture Round
        
        
       // super.viewDidLoad()
        
        
        
        
        
        // Load image Profile
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        super.viewDidAppear(true)
     
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        let ImageSong:UIImageView = cell.viewWithTag(201) as! UIImageView

        
        
        
        
        
        let myvideo = videos[indexPath.row]
        let url = URL(string: (myvideo.songPicture as String))

        
        ImageSong.kf.setImage(with: url)

        
        
        
        
        
    
        
 
        return cell
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let myvideo = videos[indexPath.row]
        
        
        
        
        
        self.videoURL = NSURL(string: myvideo.URL)!
        
        
        
        
        
        
        
        
        let playerItem = AVPlayer(url: videoURL as URL)
        
        let playerController = AVPlayerViewController()
        playerController.player = playerItem
        self.present(playerController, animated: true) {
            
            
        }
    }
    
    
    
    
    
    
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
    
    
    
    
    
    func fetchVideos(){
        print("hello bechi")
        userUID = user.getCurrentUserUid()
        var ref: FIRDatabaseReference!
        print(userUID)
        ref = FIRDatabase.database().reference()
        
        
        
        ref.child("videos").child(userUID).observe(.childAdded, with: {
            
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
        EZLoadingActivity.hide(true, animated: false)

        
        
    }
    
    
  
    
    
    
    func UserDetail() {
        
        userUID = user.getCurrentUserUid()
        var ref: FIRDatabaseReference!
        print(userUID)
        ref = FIRDatabase.database().reference()
        
        
        
        ref.child("users").child(userUID).observe(.value, with: { (snapshot) in
            
            
           
           
             self.keyUser = snapshot.key
            
            let snapshot = snapshot.value as! [String: AnyObject]
            
           let username =  snapshot["username"] as? String
            
           self.lblUserName.text = "@" + username!
            self.lblFullName.text = snapshot["fullname"] as? String
            self.profilePictureURL = snapshot["profilePictureURL"] as? String
            
            
            
            //Loading picture with caching
            let url = URL(string: self.profilePictureURL)
            self.profilePicture.kf.setImage(with: url)
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
            self.profilePicture.layer.masksToBounds = true
            
            self.profilePicture.layer.borderWidth = 2
            self.profilePicture.layer.borderColor = UIColor.white.cgColor
            
            
            
            self.activityAnimation.stopAnimating()
            self.activityAnimation.hidesWhenStopped = true
            
            
            
            
            
            
            
            
            
            
            
            
         
            let followingCount = snapshot["followingCount"] as? NSNumber
          let followersCount = snapshot["followersCount"] as? NSNumber
            
            
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

                
            let  email = snapshot.childSnapshot(forPath: "email").value as! String
            let  fullname = snapshot.childSnapshot(forPath: "fullname").value as! String
            let  username = snapshot.childSnapshot(forPath: "username").value as! String
            let FollowersCount = snapshot.childSnapshot(forPath: "followersCount").value as! String
            let FollowingCount = snapshot.childSnapshot(forPath: "followingCount").value as! String
            
            
            
            
            self.profilePictureURL = snapshot.childSnapshot(forPath: "profilePictureURL").value as! String
            
          
              self.lblUser.text = username
            print(FollowersCount)
            print(FollowingCount)
                print(self.profilePictureURL)
            
                */
                
            /*
            guard let url = URL(string: self.profilePictureURL!) else { return }
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
            
            
            
        }){ (error) in
            print(error.localizedDescription)
            
 
            
            
        }
        
        
    }
    
    var isFollowing : Bool = false
    
    
    
 
    
  
    @IBAction func LogOut(_ sender: UIButton) {
        
        
        

    }
    
        
        
        
        
   
    
    
    
    @IBAction func SignOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
        
        
        let manager = FBSDKLoginManager()
        manager.logOut()
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstViewController")
        self.dismiss(animated: true, completion: nil)
        
        self.present(ViewController, animated: true, completion: nil)
    }
    
    
    
    

    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showFollowingTableViewController")
        {
            print("user to pass")
            
            
            let showFollowingTableViewController = segue.destination as! FollowingViewController
            showFollowingTableViewController.user = keyUser
            
        }
        
         else if(segue.identifier == "showFollowersTableViewController")
         {
         let showFollowersTableViewController = segue.destination as! FollowersViewController
         showFollowersTableViewController.user = keyUser
         
         }
    }

    
    
    
    
   
    }
    

    
    
        
        

    

    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


