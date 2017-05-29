//
//  AudioVC.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/19/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import EZLoadingActivity


class AudioVC: UIViewController {
    
    
    var image = String()
    var mainSongTitle = String()
    var previewURL = String()
    var singer = String()
    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var songTitle: UILabel!
    override func viewDidLoad() {
        EZLoadingActivity.show("Playing...", disableUI: true)

        songTitle.text = mainSongTitle
        
        let url = URL(string: image)

        
        background.kf.setImage(with: url)
        mainImageView.kf.setImage(with: url)


        downloadFileFromURL(url: URL(string: previewURL)!)
        
       
     
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)

    }
    
    
    func downloadFileFromURL(url : URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            
            customURL , response , error in
         
                self.play(url: customURL!)
            EZLoadingActivity.hide(true, animated: true)
                           // self.slider.maximumValue = Float(player.duration)
        
                 })
            downloadTask.resume()
 
        
    }

    
    func play(url : URL){
        do{
        player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
          
            

   

        }
        catch {
            print(error)
            
        }
    }

    
    
    
    @IBAction func PlayBtn(_ sender: Any) {
        
      
            
            if player.isPlaying{
                player.pause()
                playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                
            }else{
                player.play()
                playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
            
            
        }
        
  
    
    
    
    @IBAction func ChangerTimePlayer(_ sender: Any) {
    player.stop()
    player.currentTime = TimeInterval(slider.value)
    player.prepareToPlay()
    player.play()
    
    }
    
    
    
    
    
    
    func updateTime(_ timer: Timer) {

        
      // slider.value = Float(player.currentTime)
       // slider.value  = Float(20)

        print("ok")
        NSLog("hi")
       
        
    }
    
    
    @IBAction func Stop_Player(_ sender: Any) {
        
        player.stop()
        player.currentTime = 0
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "RecordVideo")
        {
            // print("user to pass")
            // print(otherUser?.value(forKey: "uid") as! String)
            player.stop()
            player.currentTime = 0
            
            let RecordVideo = segue.destination as! CameraViewController
            RecordVideo.previewURL = previewURL
            RecordVideo.SongURL = mainSongTitle
            RecordVideo.PictureURL = image
            RecordVideo.SingerURL = singer
           
            
        }
       
        
        
        
        
        
    }

    
    
    
    
    
}
