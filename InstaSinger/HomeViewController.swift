//
//  HomeViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftSpinner


import AVKit

class HomeViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    
    
    
    //Buttons
    
    


    @IBOutlet var tableView: UITableView!
 
    var videos = [Videos]()
    var user = UserInfo()
    var userUID : String!
    var videoURL = NSURL()
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var ref: FIRDatabaseReference!
    var listFollowing = [NSDictionary?]()
    var commentsKey : String!
    var likeBtn = UIButton()
    var Sharebtn = UIButton()

    var SongPicture = UIImageView()
    var profilePicture = UIImageView()
    var listFollowingUser = [NSDictionary?]()
    var LikedVideos = [NSDictionary?]()
    
    var value = NSDictionary()
    // initiation du base
    
    
    
    
    override func viewDidLoad() {
        
    
        

        super.viewDidLoad()


        
        /*
        do {
            
            
            try! FIRAuth.auth()!.signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        */
        
 
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
       
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let currentUser = user{
                
                print("user is signed in")
                
              
                
            }
            
            else {
                SwiftSpinner.hide()
                
              let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let ViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstViewController")
                
                self.present(ViewController, animated: true, completion: nil)

                
            }
        })
        
        
        SwiftSpinner.show(progress: 0.1, title: "Loading videos...")
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        
        //   self.toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        // self.toolBar.shadowImage(forToolbarPosition: UIBarPosition.any)
        // fetchVideos()
  
        self.tableView.isPagingEnabled = true
        
        // FetchUserFollowing()
        
        
        
        
        FetchUserFollowing()
        FetchLikedVideos()
        
        if ( listFollowing.count == 0){
            SwiftSpinner.hide()
        }
       

        
       //  fetchFollowingVideos()

        
        

      
        
    }
    
    
        // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listFollowing.count
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        let ImageSong:UIImageView = myCell.viewWithTag(600) as! UIImageView

        
        let myvideo = self.listFollowing[indexPath.row]
        
        let folloeduser = self.listFollowingUser[indexPath.row]

        let Commentbtn:UIButton = myCell.viewWithTag(500) as! UIButton
        Sharebtn = myCell.viewWithTag(505) as! UIButton
        likeBtn = myCell.viewWithTag(501) as! UIButton

        SongPicture = myCell.viewWithTag(502)! as! UIImageView
        profilePicture = myCell.viewWithTag(503)! as! UIImageView
        let UserNameLabel:UILabel = myCell.viewWithTag(100)! as! UILabel
        let SingerLabel:UILabel = myCell.viewWithTag(101)! as! UILabel
        let SongLabel:UILabel = myCell.viewWithTag(102)! as! UILabel





        
        let urlPicture = URL(string: (myvideo?.value(forKey: "songPicture")  as! String))
        
        
        ImageSong.kf.setImage(with: urlPicture)

        
        
        SingerLabel.text = myvideo?.value(forKey: "singer") as? String
        SongLabel.text = myvideo?.value(forKey: "song") as? String
        
        let url = URL(string: (myvideo?.value(forKey: "songPicture") as! String))
        let url1 = URL(string: (folloeduser?.value(forKey: "profilePictureURL") as! String))
        let username = folloeduser?.value(forKey: "username") as? String
        
        UserNameLabel.text = "@" + username!
        
        SongPicture.layer.cornerRadius = SongPicture.frame.size.width / 2
        SongPicture.layer.masksToBounds = true
        SongPicture.kf.setImage(with: url)
        
        profilePicture.layer.cornerRadius = SongPicture.frame.size.width / 2
        profilePicture.layer.masksToBounds = true
        profilePicture.kf.setImage(with: url1)
    
        
        SongPicture.rotate360Degrees()
        
        
        likeBtn.setTitle(String(indexPath.row), for: .normal)
        likeBtn.titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 1)
        Sharebtn.setTitle(String(indexPath.row), for: .normal)
        Sharebtn.titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 1)
        

        
        
        if(self.IsLiked(uid: myvideo?.value(forKey: "comments") as! String) == true){
        likeBtn.setImage(#imageLiteral(resourceName: "liked_home"), for: .normal)
        }
        else
        {
            likeBtn.setImage(#imageLiteral(resourceName: "like_home"), for: .normal)
        }
        commentsKey = myvideo?.value(forKey: "comments") as! String
  
        
       
        
        
      //  myCell.addSubview(btnMore)
     //   myCell.addSubview(btnLike)
     //   myCell.addSubview(btnComment)
        myCell.addSubview(SongPicture)
        myCell.addSubview(profilePicture)

        myCell.addSubview(Commentbtn)
        myCell.addSubview(likeBtn)
        myCell.addSubview(UserNameLabel)
        myCell.addSubview(SongLabel)
        myCell.addSubview(SingerLabel)



     //  Commentbtn.
        
        
Commentbtn.addTarget(self, action: #selector(self.CommentPressed(sender:)), for: .touchUpInside)
        
        
        Sharebtn.addTarget(self, action: #selector(self.SharePressed(sender:)), for: .touchUpInside)
        
        
likeBtn.addTarget(self, action: #selector(self.LikePressed(sender:)), for: .touchUpInside)

        
    
        
        SwiftSpinner.hide()

        return myCell
    }
    
    func CommentPressed(sender: AnyObject){
           // let buttonTag = sender.tag
        
        print("im pressed")
        print(commentsKey)
        
        performSegue(withIdentifier: "ShowComments", sender: commentsKey)
    }
    func SharePressed(sender: AnyObject){
        let buttonTag = sender.titleLabel??.text
        
        let myvideo = self.listFollowing[Int(buttonTag!)!]
        let videourl = myvideo?.value(forKey: "URL") as! String
        let urlData = NSData(contentsOf: NSURL(string:videourl)! as URL)
        
        if ((urlData) != nil){
            
            print(urlData)
            
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docDirectory = paths[0]
            let filePath = "\(docDirectory)/tmpVideo.mov"
            urlData?.write(toFile: filePath, atomically: true)
            // file saved
            
            let videoLink = NSURL(fileURLWithPath: filePath)
            
            
            let objectsToShare = [videoLink] //comment!, imageData!, myWebsite!]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.setValue("Video", forKey: "subject")
            
            
            //New Excluded Activities Code
            if #available(iOS 9.0, *) {
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.openInIBooks, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print]
            } else {
                // Fallback on earlier versions
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print ]
            }
            
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    
    func LikePressed(sender: AnyObject){
        let buttonTag = sender.titleLabel??.text
        let myvideo = self.listFollowing[Int(buttonTag!)!]
        var x : Int = -1
        let  ref = FIRDatabase.database().reference()

        
        let userRef = ref.child("Likes")
        let uidref = userRef.child(self.user.getCurrentUserUid())
        
        
        if(self.IsLiked(uid: myvideo?.value(forKey: "comments") as! String) == true){
            likeBtn.setImage(#imageLiteral(resourceName: "like_home"), for: .normal)
            print("disleked")

            for item in LikedVideos as [AnyObject]
            {
                //print("x : ",x)
                x = x+1

               // print(LikedVideos)
                //print("size : " ,LikedVideos.count)
                if (item.value(forKey: "videoUID") as! String == myvideo?.value(forKey: "comments") as! String)
                {
                    LikedVideos.remove(at: x)
                    print("removed : " ,x)
                    break
                }

            }
            DispatchQueue.main.async(execute: {
            uidref.child(myvideo?.value(forKey: "comments") as! String).removeValue()
            })
        }
        else
        {
            print("liked")
    
            likeBtn.setImage(#imageLiteral(resourceName: "liked_home"), for: .normal)
            let mylikedvideo : NSDictionary = ["videoUID" : myvideo?.value(forKey: "comments") as! String]
            LikedVideos.append(mylikedvideo)
            print("size : ",LikedVideos.count)
            DispatchQueue.main.async(execute: {
            uidref.child(myvideo?.value(forKey: "comments") as! String).setValue(mylikedvideo)
            })

       }
        
        //print("like pressed " , buttonTag!)
    }
    
    
    
    func IsLiked(uid : String) -> Bool
    {
        var x : Bool = false
    
        for item in LikedVideos as [AnyObject]
        {
            if (item.value(forKey: "videoUID") as! String == uid)
            {
                x = true
            }
        }
    
        return x;
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let url = self.listFollowing[indexPath.row]
        
        let videoUrl = NSURL(string: url?.value(forKey: "URL") as! String)!

        
        let playerItem = AVPlayer(url: videoUrl as URL)

        let playerController = AVPlayerViewController()
        playerController.player = playerItem
        self.present(playerController, animated: true) {
            playerItem.play()
        
        
        }
    }
    
    
    
    
    
    
    

    
 /*
    
    func thm (fileUrl : NSURL) ->UIImage? {
        
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let th = try imageGenerator.copyCGImage(at: CMTimeMake(1,60), actualTime: nil)
            return UIImage(cgImage: th)
        }
        catch let err {
            print(err)
        }
        return nil
        
    }
    
    
    */
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height;
        
    }
    
    
    
    
    
    
    
    
    func fetchVideos(){
        print("hello bechi")
        userUID = user.getCurrentUserUid()
        var ref: FIRDatabaseReference!
        print(userUID)
        ref = FIRDatabase.database().reference()
        
        
        
        ref.child("users").child(userUID).child("videos").observe(.childAdded, with: {
            
            snapshot in
            
            if let dictionary = snapshot.value as? [String : AnyObject]{
                let video = Videos()
                
                video.setValuesForKeys(dictionary)
                self.videos.append(video)
                
            
                print(video.URL)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
                
            }
   
            
        }){ (error) in
            print(error.localizedDescription)
 
        }
    
    
    }
    
    
    
    
    func FetchUserFollowing() {
        let  ref = FIRDatabase.database().reference()
        listFollowing.removeAll()

        ref.child("following").child(self.user.getCurrentUserUid()).queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            print("data returnde")
   
             let FollowedUsedUid = snapshot.key

            ref.child("users").child(FollowedUsedUid).observeSingleEvent(of: .value, with: { (snapshot1) in
                let snapshot1 = snapshot1.value as? NSDictionary
                self.value = snapshot1!
               

                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
      
             //let snapshot = snapshot.value as? NSDictionary
      
            //second run
            
            let  refVideos = FIRDatabase.database().reference()
             self.listFollowingUser.removeAll()
            
            refVideos.child("videos").child(FollowedUsedUid).observe(.childAdded, with: { (snapshotVideos) in
                //print("second run")
                //print(snapshotVideos)
                
                let snapshotVideos = snapshotVideos.value as? NSDictionary
                
                self.listFollowingUser.append(self.value)

                //add the videos to the array
               self.listFollowing.append(snapshotVideos)
                
                self.tableView.insertRows(at: [IndexPath(row:self.listFollowing.count-1,section:0)], with: UITableViewRowAnimation.automatic)
                
   
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
    
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
    }
    
    
    func FetchLikedVideos() {
        let  ref = FIRDatabase.database().reference()
        
        ref.child("Likes").child(self.user.getCurrentUserUid()).observe(.childAdded, with: { (snapshot) in
            print("data returnde")
            
         print("firassssss")
            let value1 = snapshot.value as? NSDictionary
            self.LikedVideos.append(value1)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowComments")
        {
          
            let CommentsView = segue.destination as! CommentsViewController
            CommentsView.CommentsKey = commentsKey

            
        }
            
        
    }

    
  
    
    
}



extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 2.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.autoreverses = true
        
      
        self.layer.add(rotateAnimation, forKey: nil)
    }
}


