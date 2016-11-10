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


class ProfileViewController: UIViewController  , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    var videos = [Videos]()
    var user = UserInfo()
    var userUID : String!
    var videoURL = NSURL()
    
    
    var player = AVPlayer()
    
    
    
    var playerLayer = AVPlayerLayer()
    
    
    
    

    override func viewDidLoad() {
        
        print(user.getCurrentUserUid())
        fetchVideos()
        UserDetail()
    
        
    
        //Follow Button
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 3

        
        
        
        
        //Profile Picture Round
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.layer.masksToBounds = true
        
  
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
     
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        
        
        
        
        let myvideo = videos[indexPath.row]

        
        
        
        DispatchQueue.main.async(execute: {
            let VideoPreview:UIView = cell.viewWithTag(200)!
                       
            self.videoURL = NSURL(string: myvideo.URL)!
            
            
            
            
            self.player = AVPlayer(url: self.videoURL as URL)
            
            
            
            self.playerLayer = AVPlayerLayer(player: self.player)
            
            //   VideoPreview.clipsToBounds = true
            self.playerLayer.frame = VideoPreview.layer.bounds
            
            
            
            //  playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //   playerLayer.frame = myCell.contentView.bounds
            self.playerLayer.videoGravity = AVLayerVideoGravityResize
            
            
            cell.layer.addSublayer(self.playerLayer)
            
      
            
            
            //  player.play()
            
            
        })
        
        

        
    
        
 
        return cell
        
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
        
        
        
        ref.child("users").child(userUID).child("videos").observe(.childAdded, with: {
            
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
    
    
    func UserDetail() {
        

        
        
     
        userUID = user.getCurrentUserUid()
        var ref: FIRDatabaseReference!
        print(userUID)
        ref = FIRDatabase.database().reference()
        
        
        
        ref.child("users").observe(.childAdded, with: {
            
            snapshot in
            
          

                
                let  email = snapshot.childSnapshot(forPath: "email").value as! String
            self.lblUser.text = email
                
                print(email)
            
                
                
                
            
            
            
            
            
            
            
        }){ (error) in
            print(error.localizedDescription)
            
            
            
            
        }
        
        
    }
    
    var isFollowing : Bool = false
    
    @IBAction func FollowUser(_ sender: Any) {
        
        
        if (isFollowing == false) {
            
      
            followBtn.layer.backgroundColor = UIColor(red: 112 / 255, green: 192 / 255, blue: 80 / 255, alpha: 1).cgColor
                followBtn.setTitle("Following", for: .normal)
                        followBtn.layer.borderColor = UIColor(red: 112 / 255, green: 192 / 255, blue: 80 / 255, alpha: 1).cgColor
        
        
        
        followBtn.setTitleColor(UIColor.white, for: .normal)
            isFollowing = true
            
            
            
        }else{
            followBtn.layer.borderColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1).cgColor
            followBtn.layer.backgroundColor = UIColor.clear.cgColor
                followBtn.setTitle("Follow", for: .normal)
             followBtn.setTitleColor(UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1), for: .normal)
            isFollowing = false 
            
            
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


