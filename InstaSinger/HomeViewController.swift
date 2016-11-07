//
//  HomeViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation

import AVKit

class HomeViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Table View Code (Done MSG hELLO)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Fin Liste Des Etudiants"
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Début liste Des Etudiants"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        
        let VideoPreview:UIView = myCell.viewWithTag(200)!
      
        

        
        let videoURL = NSURL(string: "file:///Applications/XAMPP/xamppfiles/htdocs/api/uploads/20161104_204212.mp4")
        
        let player = AVPlayer(url: videoURL! as URL)
        
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = VideoPreview.frame
        
        
        
      //  playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
     //   playerLayer.frame = myCell.contentView.bounds
       // playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        
        myCell.layer.addSublayer(playerLayer)
        
       // player.play()

        
        
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
    
    
    
    

}
