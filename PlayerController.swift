//
//  ViewController.swift
//  InteractivePlayerView
//
//  Created by AhmetKeskin on 02/09/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import EZLoadingActivity

class PlayerController: UIViewController, InteractivePlayerViewDelegate , AVAudioPlayerDelegate{
    
    
    
    var image = String()
    var mainSongTitle = String()
    var previewURL = String()
    var singer = String()
    
    
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBOutlet weak var singer_lbl: UILabel!
    
    @IBOutlet weak var song_lbl: UILabel!
    @IBOutlet weak var blurBgImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ipv: InteractivePlayerView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playPauseButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        EZLoadingActivity.show("Playing...", disableUI: true)

        song_lbl.text =  singer
        singer_lbl.text = mainSongTitle
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.clear
       

        self.ipv!.delegate = self
        
        
        // duration of music
        self.ipv.progress = 30.0
        
        downloadFileFromURL(url: URL(string: previewURL)!)
        

   




    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string: image)
        
        
        blurBgImage.kf.setImage(with: url)
        self.ipv.coverImage = blurBgImage.image
        self.ipv.restartWithProgress(duration: 30)
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        self.ipv.start()
        player.play()


        self.playButton.isHidden = true
        self.pauseButton.isHidden = false
        
    }

    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        
        self.ipv.stop()
        
        player.stop()
    

        
        self.playButton.isHidden = false
        self.pauseButton.isHidden = true
        
    }
    
    
    
    
    
    
    
    @IBAction func Play_Btn(_ sender: Any) {
        if player.isPlaying == false {
        
        self.ipv.start()
        player.play()
        }
     

    }
    
    
    
    
    
    @IBAction func Pause_Btn(_ sender: Any) {
        if player.isPlaying == true {
        
        self.ipv.stop()
        player.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.ipv.restartWithProgress(duration: 30)
        
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
            player.delegate = self
            player.prepareToPlay()


            
            
            
            
        }
        catch {
            print(error)
            
        }
    }

    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "RecordVideo")
        {
            // print("user to pass")
            // print(otherUser?.value(forKey: "uid") as! String)
            player.stop()
            player.currentTime = 0
            self.ipv.stop()
            
            let RecordVideo = segue.destination as! CameraViewController
            RecordVideo.previewURL = previewURL
            RecordVideo.SongURL = mainSongTitle
            RecordVideo.PictureURL = image
            RecordVideo.SingerURL = singer
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func nextTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 50)
    }
    
    @IBAction func previousTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 10)
    }
    
    /* InteractivePlayerViewDelegate METHODS */
    func actionOneButtonTapped(sender: UIButton, isSelected: Bool) {
        print("shuffle \(isSelected.description)")
    }
    
    func actionTwoButtonTapped(sender: UIButton, isSelected: Bool) {
        print("like \(isSelected.description)")
    }
    
    func actionThreeButtonTapped(sender: UIButton, isSelected: Bool) {
        print("replay \(isSelected.description)")

    }
    
    func interactivePlayerViewDidChangedDuration(playerInteractive: InteractivePlayerView, currentDuration: Double) {
        print("current Duration : \(currentDuration)")
        
        
    }
    
    func interactivePlayerViewDidStartPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did started")
    }
    
    func interactivePlayerViewDidStopPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did stop")
    }
    
    func makeItRounded(view : UIView!, newSize : CGFloat!){
        let saveCenter : CGPoint = view.center
        let newFrame : CGRect = CGRect(x: view.frame.origin.x,y: view.frame.origin.y,width: newSize,height : newSize)
        view.frame = newFrame
        view.layer.cornerRadius = newSize / 2.0
        view.clipsToBounds = true
        view.center = saveCenter
        
    }
}
