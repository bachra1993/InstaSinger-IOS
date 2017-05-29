//
//  FirstViewController.swift
//  InstaSinger
//
//  Created by Trabelsi Firas on 11/24/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
class FirstViewController: UIViewController {
    // initiation du player du video background
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    // fin initiation du player
    
    
    
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    
    lazy var container1ViewController : ViewController =
        {
            let storyboard = UIStoryboard (name: "Main", bundle: Bundle.main)
            var viewController = storyboard.instantiateViewController(withIdentifier : "ViewController") as! ViewController
            self.addViewControllerAsChildViewController(childViewController: viewController)
            return viewController
    }()
    
    lazy var container2ViewController : RegisterViewController =
        {
            let storyboard = UIStoryboard (name: "Main", bundle: Bundle.main)
            var viewController = storyboard.instantiateViewController(withIdentifier : "RegisterViewController") as! RegisterViewController
            self.addViewControllerAsChildViewController(childViewController: viewController)
            return viewController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedcontrol.layer.cornerRadius = 0.0
        segmentedcontrol.layer.borderWidth = 1
        // La partie du video background
        
        
        let theURL = Bundle.main.url(forResource: "video", withExtension: "mov")
        
        avPlayer = AVPlayer.init(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear;
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        // Fin du partie video background
        
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    private func setupView()
    {
        setupSegmentedControl()
        updateView()
        
    }
    
    private func setupSegmentedControl()
    {
        segmentedcontrol.removeAllSegments()
        segmentedcontrol.insertSegment(withTitle: "SignIn", at: 0, animated: false)
        segmentedcontrol.insertSegment(withTitle: "SignUp", at: 1, animated: false)
        segmentedcontrol.addTarget(self, action: #selector(selectionDidChange(sender :)), for: .valueChanged)
        segmentedcontrol.selectedSegmentIndex = 0
    }
    private func updateView()
    {
        container1ViewController.view.isHidden = !(segmentedcontrol.selectedSegmentIndex == 0)
        container2ViewController.view.isHidden = (segmentedcontrol.selectedSegmentIndex == 0)
        
    }
    
    @objc private func selectionDidChange(sender : UISegmentedControl)
    {
        updateView()
        self.view.bringSubview(toFront: segmentedcontrol)

    }
    
    
    
    func addViewControllerAsChildViewController( childViewController: UIViewController)
    {
        self.view.bringSubview(toFront: segmentedcontrol)
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        let w = self.view.frame.width
        let y = self.view.frame.height
        let frame = CGRect(x: 0, y: 0, width: w, height: y)
        
        childViewController.view.frame = frame
        //childViewController.view.autoresizingMask = [ .flexibleHeight,.flexibleWidth]
        //childViewController.didMove(toParentViewController: self)
        
    }
    // func video background
    func playerItemDidReachEnd(notification: NSNotification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreafted.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        avPlayer.play()
        paused = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        avPlayer.play()
        paused = true
    }
    
    
}

