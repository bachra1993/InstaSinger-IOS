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

import AVKit

class HomeViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    
    
    
    //Buttons
    
    


   @IBOutlet weak var tableView: UITableView!
    var videos = [Videos]()
    var user = UserInfo()
    var userUID : String!

    
    
    var videoURL = NSURL()
    
    
    var player = AVPlayer()
    
    
    
    var playerLayer = AVPlayerLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     //   self.toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
     // self.toolBar.shadowImage(forToolbarPosition: UIBarPosition.any)
          fetchVideos()
        self.tableView.isPagingEnabled = true
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
      
        
    }
    
    
        // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Table View Code (Done MSG hELLO)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
        
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Fin Liste Des Etudiants"
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Début liste Des Etudiants"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        let myvideo = videos[indexPath.row]
        
     
      
        

        
        
        DispatchQueue.main.async(execute: {
            let VideoPreview:UIView = myCell.viewWithTag(200)!
            let btnLike:UIButton = myCell.viewWithTag(101) as! UIButton
            let btnComment:UIButton = myCell.viewWithTag(102) as! UIButton
            let btnMore:UIButton = myCell.viewWithTag(103) as! UIButton

        
        self.videoURL = NSURL(string: myvideo.URL)!
        
        
       
        
       self.player = AVPlayer(url: self.videoURL as URL)
        
        
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        
    //   VideoPreview.clipsToBounds = true
      self.playerLayer.frame = VideoPreview.layer.bounds
        
        
        
  //  playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
     //   playerLayer.frame = myCell.contentView.bounds
        self.playerLayer.videoGravity = AVLayerVideoGravityResize
        
        
   myCell.layer.addSublayer(self.playerLayer)
           
            myCell.addSubview(btnMore)
             myCell.addSubview(btnLike)
             myCell.addSubview(btnComment)
            
        
      //  player.play()
        
        
        })
        
       
        
        
        
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("im taped")
       // player.play()
        
        
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
    
    
    
}
