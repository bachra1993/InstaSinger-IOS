//
//  CameraViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AssetsLibrary
import Firebase
import FirebaseDatabase
import FirebaseStorage
import EZLoadingActivity
import Alamofire
import SwiftSpinner



class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var closePalyerBtn: UIButton!
    @IBOutlet var switchCameraBtn:UIButton?
    @IBOutlet var flashLightBtn:UIButton?
    @IBOutlet var doneBtn:UIButton!
    @IBOutlet var closeBtn:UIButton!
    @IBOutlet var videoPreviewView:UIView!
    @IBOutlet var clipsScrollView:UIScrollView!
    @IBOutlet var recordBtn:UIButton!
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var trashButton:UIButton!
    @IBOutlet var clipsCollectionView:UICollectionView!
    
    
    
    @IBOutlet weak var activity_animation: UIActivityIndicatorView!
    
    @IBOutlet weak var progress_bar: UIProgressView!
    
    
    
    var previewURL = String()
    var SongURL = String ()
    var SingerURL = String ()
    var PictureURL = String ()
    var ServerURL :String = "http://a3tihooli.com/instasinger/upload.php"
    var ServerUploadFile:String = "http://a3tihooli.com/instasinger/uploads/"
   
    
    
    
    
    
    var videoPlayer:AVPlayerViewController?
    var avPlayerLayer:AVPlayerLayer?
    var thumbnails = [UIImage]()
    var draggableThumbnail:DraggableThumbnail?
    var selectedIndexPath:IndexPath?
    var selectedPlayingVideo:Int = 0
    var captureSession:AVCaptureSession?
    var audioCapture:AVCaptureDevice?
    var backCameraVideoCapture:AVCaptureDevice?
    var frontCameraVideoCapture:AVCaptureDevice?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var frontCamera:Bool = false
    var flash:Bool = false
    var recordingInProgress = false
    var output:AVCaptureMovieFileOutput!
    var videoClips:[URL] = [URL]()
    var videoThumbnail:[Thumbnail] = [Thumbnail]()
    var animating:Bool = false
    var time:Int = 0
    var UserUid:String = ""
    var user = UserInfo()
    
    var timer:Timer?
    
    override func viewDidLoad() {
        print("app did started ::: ç")
        super.viewDidLoad()
        
        progress_bar.isHidden = true
        
        
        
        
        
        
        //   downloadFileFromURL(url: URL(string: previewURL)!)
        
        
        
        
        
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkTimer
            ), userInfo: nil, repeats: true)
        
        
        
        
        captureSession = AVCaptureSession()
        clipsCollectionView.canCancelContentTouches = false
        clipsCollectionView.isExclusiveTouch = false
        
        // clipsScrollView.canCancelContentTouches = false
        // clipsScrollView.exclusiveTouch = false
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            
            if (device as AnyObject).hasMediaType(AVMediaTypeAudio){
                audioCapture = device as? AVCaptureDevice
            }else if (device as AnyObject).hasMediaType(AVMediaTypeVideo){
                if (device as AnyObject).position == AVCaptureDevicePosition.back{
                    backCameraVideoCapture = device as? AVCaptureDevice
                }else{
                    frontCameraVideoCapture = device as? AVCaptureDevice
                }
                
            }
            
            
        }
        
        // if audio capture did no get set no media type available :( return from the method
        if audioCapture == nil{
            return
        }
        beginSession()
    }
    
    func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewView.clipsToBounds = true
        previewLayer?.frame = self.view.bounds
        self.videoPreviewView.layer.addSublayer(previewLayer!)
        
        captureSession?.startRunning()
        
        
        // start by adding audio capture
        do{
            try captureSession?.addInput(AVCaptureDeviceInput(device: audioCapture!))
        }catch{
            print(error)
            return
        }
        
        do{
            try captureSession?.addInput(AVCaptureDeviceInput(device: backCameraVideoCapture!))
        }catch{
            print(error)
            return
        }
        
        output = AVCaptureMovieFileOutput()
        output.maxRecordedDuration = CMTimeMake(10, 1)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(CameraViewController.handleLongGesture(_:)))
        longPressGesture.minimumPressDuration = 0.1
        clipsCollectionView.addGestureRecognizer(longPressGesture)
        
        
        let maxDuration = CMTimeMakeWithSeconds(180, 30)
        output.maxRecordedDuration = maxDuration
        captureSession?.addOutput(output)
        let connection = output.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        captureSession?.sessionPreset = AVCaptureSessionPreset1280x720
        captureSession?.commitConfiguration()
        
        
        videoPreviewView.bringSubview(toFront: self.trashButton)
        videoPreviewView.bringSubview(toFront: self.timeLabel)
        
        self.viewStyling()
    }
    
    func viewStyling(){
        
        self.trashButton.isHidden = true
        // let image = UIImage(named: //"record")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //recordBtn.setImage(image, for: UIControlState())
        //recordBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swapCamera(){
        
        
        for i in 0 ..< captureSession!.inputs.count {
            
            let input = captureSession!.inputs[i] as! AVCaptureDeviceInput
            let device = input.device as AVCaptureDevice
            
            if device.hasMediaType(AVMediaTypeVideo){
                captureSession?.removeInput(input)
            }
            
            
        }
        
        if frontCamera{
            try! captureSession?.addInput(AVCaptureDeviceInput(device: backCameraVideoCapture!))
            flashLightBtn?.isEnabled = true

        }else{
            try! captureSession?.addInput(AVCaptureDeviceInput(device: frontCameraVideoCapture!))
            flashLightBtn?.isEnabled = false

        }
        
        frontCamera = !frontCamera
        
        
    }
    
    @IBAction func toggleFlashlight(){
        
        for i in 0 ..< captureSession!.inputs.count {
            
            let input = captureSession!.inputs[i] as! AVCaptureDeviceInput
            let device = input.device as AVCaptureDevice
            
            if device.hasMediaType(AVMediaTypeVideo){
                
                try! device.lockForConfiguration()
                if device.hasTorch && !device.isTorchActive {
                    
                    device.torchMode = AVCaptureTorchMode.on
                    
                }else{
                    device.torchMode = AVCaptureTorchMode.off
                }
                
                device.unlockForConfiguration()
                
            }
            
            
        }
        
    }
    
    
    @IBAction func recordVideo(){
        
        let myString = "\(time)"
        let myInt = (myString as NSString).integerValue
        
        
        if (recordingInProgress == false && myInt == 5) {
            let alert = UIAlertController(title: "Warning", message: "Can't Record anymore", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            
            
            if recordingInProgress {
                
                
                StopRecord()
                
                
                
                recordBtn.tintColor = UIColor.black
                
            }else{
                
                StartRecording()
                
                
                
            }
            
        }
        print("print timer " )
        print ("\(time)")
        
    }
    
    
    func StopRecord () {
        player.pause()
        self.stopTimer()
        output.stopRecording()
        recordingInProgress = !recordingInProgress
        
        
    }
    
    
    func StartRecording() {
        
        
        let myString = "\(time)"
        
        
        
        
        
        
        recordBtn.tintColor = UIColor.red
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let date = Date()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let outputPath = "\(documentsPath)/\(formatter.string(from: date)).mp4"
        let outputURL = URL(fileURLWithPath: outputPath)
        player.play()
        output.startRecording(toOutputFileURL: outputURL, recordingDelegate: self)
        self.startTimer()
        recordingInProgress = !recordingInProgress
        
        
    }
    
    
    
    
    
    func checkTimer () {
        
        
        let myString = "\(time)"
        let myInt = (myString as NSString).integerValue
        
        
        if ( recordingInProgress && myInt == 5  ) {
            print("before 5")
            StopRecord()
        }
        
        
        
        
    }
    
    
    
    
    
    @IBAction func doneBtnClicked(){
        let myString = "\(time)"
        let myInt = (myString as NSString).integerValue
        
        if (myInt < 3)
        {
            
            let alert = UIAlertController(title: "Warning", message: "Video must be at least 3 seconds long", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.mergeVideoClips()
            
        }
        
        
        
    }
    
    // MARK: AVCaptureFileOutputRecordingDelegate methods
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        cropVideo(outputFileURL)
        // getThumbnail(outputFileURL)
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }
    
    
    func cropVideo(_ outputFileURL:URL){
        
        let videoAsset: AVAsset = AVAsset(url: outputFileURL) as AVAsset
        
        let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first! as AVAssetTrack
        
        let composition = AVMutableComposition()
        composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        
        let videoComposition = AVMutableVideoComposition()
        
        videoComposition.renderSize = CGSize(width: 720, height: 720)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(180, 30))
        
        // rotate to portrait
        let transformer:AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        let t1 = CGAffineTransform(translationX: 720, y: 0);
        let t2 = t1.rotated(by: CGFloat(M_PI_2));
        
        transformer.setTransform(t2, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let date = Date()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let outputPath = "\(documentsPath)/\(formatter.string(from: date)).mp4"
        let outputURL = URL(fileURLWithPath: outputPath)
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        exporter.outputURL = outputURL
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        exporter.exportAsynchronously(completionHandler: { () -> Void in
            DispatchQueue.main.async(execute: {
                self.handleExportCompletion(exporter)
            })
        })
    }
    
    func handleExportCompletion(_ session: AVAssetExportSession) {
        let thumbnail =  self.getThumbnail(session.outputURL!)
        videoClips.append(session.outputURL!)
        
        thumbnails.append(thumbnail)
        self.clipsCollectionView.reloadData()
        let indexPath = IndexPath(item: thumbnails.count - 1, section: 0)
        self.clipsCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
        /*
         if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(session.outputURL) {
         var completionBlock: ALAssetsLibraryWriteVideoCompletionBlock
         
         completionBlock = { assetUrl, error in
         if error != nil {
         print("error writing to disk")
         } else {
         
         }
         }
         
         library.writeVideoAtPathToSavedPhotosAlbum(session.outputURL, completionBlock: completionBlock)
         }
         
         let player = AVPlayer(URL: session.outputURL!)
         let playerController = AVPlayerViewController()
         playerController.player = player
         self.presentViewController(playerController, animated: true) {
         player.play()
         }
         
         */
        
        
    }
    
    
    func getThumbnail(_ outputFileURL:URL) -> UIImage {
        
        let clip = AVURLAsset(url: outputFileURL)
        let imgGenerator = AVAssetImageGenerator(asset: clip)
        let cgImage = try! imgGenerator.copyCGImage(
            at: CMTimeMake(0, 1), actualTime: nil)
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
        
    }
    
    // hide status bar
    override var prefersStatusBarHidden : Bool {
        return true;
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: - CollectionView stuff
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath)
        let lblDate:UIImageView = cell.viewWithTag(100) as! UIImageView
        lblDate.image = thumbnails[indexPath.row]
        cell.isExclusiveTouch = false
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.selectedIndexPath = destinationIndexPath
        
        let url = videoClips[sourceIndexPath.row]
        let thumbnail = thumbnails[sourceIndexPath.row]
        
        videoClips.remove(at: sourceIndexPath.row)
        videoClips.insert(url, at: destinationIndexPath.row)
        thumbnails.remove(at: sourceIndexPath.row)
        thumbnails.insert(thumbnail, at: destinationIndexPath.row)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPlayingVideo = indexPath.row;
        self.addVideoPlayer(self.videoClips[indexPath.row])
    }
    
    func addVideoPlayer(_ url:URL){
        
        
        let playerItem = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.itemDidFinsihPlaying(_:)), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        //   let player = AVPlayer(URL: session.outputURL!)
        let playerController = AVPlayerViewController()
        playerController.player = playerItem
        self.present(playerController, animated: true) {
            playerItem.play()
        }
        
        
        
        
        
    }
    
    
    func itemDidFinsihPlaying(_ notification:Notification){
        print("finished")
        self.selectedPlayingVideo += 1
        if selectedPlayingVideo < self.videoClips.count {
            self.addVideoPlayer(self.videoClips[self.selectedPlayingVideo])
        }
    }
    
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer){
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            if let selectedIndexPath = self.clipsCollectionView.indexPathForItem(at: gesture.location(in: self.clipsCollectionView)){
                self.selectedIndexPath = selectedIndexPath
                clipsCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                
            }else {
                break
                
            }
        case UIGestureRecognizerState.changed:
            let touchPoint = gesture.location(in: self.view)
            let hitView = self.view.hitTest(touchPoint, with: nil)
            if (hitView == self.trashButton){
                self.trashButton.tintColor = UIColor.red
            }else if (hitView == self.videoPreviewView){
                self.trashButton.isHidden = false
                self.trashButton.tintColor = UIColor.black
                print("trash3")
                
            }else{
                self.trashButton.isHidden = true
                self.trashButton.tintColor = UIColor.black
                print("trash4")
                
            }
            
            clipsCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            let touchPoint = gesture.location(in: self.view)
            let hitView = self.view.hitTest(touchPoint, with: nil)
            if (hitView == self.trashButton){
                print("trash5")
                
                let cell = clipsCollectionView.cellForItem(at: self.selectedIndexPath!)
                let avAsset = AVURLAsset(url: self.videoClips[self.selectedIndexPath!.row])
                let duration = CMTimeGetSeconds(avAsset.duration)
                self.time -= Int(duration)
                self.updateTimeLabel()
                self.thumbnails.remove(at: self.selectedIndexPath!.row)
                self.videoClips.remove(at: self.selectedIndexPath!.row)
                cell?.removeFromSuperview()
                
                self.clipsCollectionView.reloadData()
                
            }
            //    self.clipsCollectionView.reloadData()
            
            self.trashButton.isHidden = true
            self.trashButton.tintColor = UIColor.black
            
            clipsCollectionView.endInteractiveMovement()
        default:
            clipsCollectionView.cancelInteractiveMovement()
        }
    }
    
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(CameraViewController.addTime), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer(){
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func addTime(){
        self.time += 1
        self.updateTimeLabel()
    }
    
    func updateTimeLabel(){
        self.timeLabel.text = "\(time)"
    }
    
    
    func mergeVideoClips(){
        
        let composition = AVMutableComposition()
        
        let videoTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let audioTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var time:Double = 0.0
        for video in self.videoClips {
            let asset = AVAsset(url: video)
            let videoAssetTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
            let audioAssetTrack = asset.tracks(withMediaType: AVMediaTypeAudio)[0]
            let atTime = CMTime(seconds: time, preferredTimescale:1)
            do{
                try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration) , of: videoAssetTrack, at: atTime)
                
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration) , of: audioAssetTrack, at: atTime)
                
            }catch{
                print("something bad happend I don't want to talk about it")
            }
            time +=  asset.duration.seconds
            
        }
        
        
        
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let savePath = "\(directory)/mergedVideo-\(date).mp4"
        let url = URL(fileURLWithPath: savePath)
        
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = url
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.outputFileType = AVFileTypeMPEG4
        
        
        
        
        exporter?.exportAsynchronously(completionHandler: { () -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.finalExportCompletion(exporter!)
                
                /*
                 upload to firebase
                 EZLoadingActivity.show("Loading...", disableUI: true)
                 
                 let video = date
                 
                 let uplaod = FIRStorage.storage().reference().child(video).putFile(url, metadata: nil)
                 
                 { (metadata, error) in
                 
                 
                 
                 if (error != nil ) {
                 
                 
                 
                 }else
                 {
                 var ref: FIRDatabaseReference!
                 ref = FIRDatabase.database().reference()
                 let key = ref.child("videos").childByAutoId().key
                 
                 let video : [String : AnyObject] = ["URL" : metadata?.downloadURL()?.absoluteString as AnyObject , "likes" : "0" as AnyObject  ,
                 "comments" : key as AnyObject ,
                 "singer" : self.SingerURL as AnyObject ,
                 "song" : self.SongURL as AnyObject,
                 "songPicture" : self.PictureURL as AnyObject ,
                 
                 
                 ]
                 
                 self.UserUid = self.user.getCurrentUserUid()
                 
                 
                 
                 ref.child("videos").child(self.UserUid).child(key).setValue(video)
                 
                 
                 
                 
                 
                 
                 
                 }
                 
                 
                 
                 }
                 
                 _ = uplaod.observe(.progress) { snapshot in
                 // A progress event occurred
                 
                 if let progress = snapshot.progress {
                 let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                 self.progress_bar.setProgress(Float(percentComplete), animated: true)
                 print(percentComplete)
                 
                 
                 
                 
                 
                 }
                 
                 }
                 
                 
                 
                 _ = uplaod.observe(.success) { snapshot in
                 
                 EZLoadingActivity.hide(true, animated: true)
                 
                 let alert = UIAlertController(title: "Done", message: "Video Uploded", preferredStyle: UIAlertControllerStyle.alert)
                 alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                 
                 
                 
                 
                 
                 }*/
                
                
                
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference()
                let key = ref.child("videos").childByAutoId().key
                
                print("korass")
                print(url)
                let video = date
                
                var fileName :String = key
                fileName += ".mp4"
                
                
                let FileNameWithURL = "\(self.ServerUploadFile)\(key).mp4"
                
                //    let filePath = documentsPath.stringByAppendingPathComponent(fileName)
                let fileURL = NSURL(fileURLWithPath: savePath)
                
                
                
                
              //  EZLoadingActivity.show("Uploading...", disableUI: true)
            
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(url, withName: "uploaded_file", fileName: fileName, mimeType: "video/mp4")
                        
                },
                    to:self.ServerURL,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseString { response in
                                debugPrint(response)
                                
                                
                                //Upload Video info to firebase
                                
                                
                                
                                
                                
                                let video : [String : AnyObject] = ["URL" : FileNameWithURL as AnyObject ,
                                                                    "likes" : "0" as AnyObject  ,
                                                                    "comments" : key as AnyObject ,
                                                                    "singer" : self.SingerURL as AnyObject ,
                                                                    "song" : self.SongURL as AnyObject,
                                                                    "songPicture" : self.PictureURL as AnyObject ,
                                                                    ]
                                
                                self.UserUid = self.user.getCurrentUserUid()
                                
                                
                                
                                ref.child("videos").child(self.UserUid).child(key).setValue(video)
                                
                                
                                
                                
                                
                                
                                
                                
                               // EZLoadingActivity.hide(true, animated: true)
                                SwiftSpinner.hide()
                                let alert = UIAlertController(title: "Done", message: "Video Uploded", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            upload.uploadProgress{
                                progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted)")
                                
                                    SwiftSpinner.show(progress: progress.fractionCompleted, title: "Uploading video")
                                self.progress_bar.setProgress(Float(progress.fractionCompleted), animated: true)
                                
                                
                            }
                            
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                }
                )
                
                
                print("video saved to galery")
                
            })
            
        })
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func finalExportCompletion(_ session: AVAssetExportSession) {
        let library = ALAssetsLibrary()
        if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: session.outputURL) {
            var completionBlock: ALAssetsLibraryWriteVideoCompletionBlock
            
            completionBlock = { assetUrl, error in
                if error != nil {
                    print("error writing to disk")
                } else {
                    
                }
            }
            
            library.writeVideoAtPath(toSavedPhotosAlbum: session.outputURL, completionBlock: completionBlock)
        }
        
        
        
        
    }
    
    
    
    @IBAction func PreviewVideo(_ sender: Any, session: AVAssetExportSession) {
        print("og")
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        
        print("dismiss view ")
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    //audio test
    
    /*
     
     func downloadFileFromURL(url : URL ){
     var downloadTask = URLSessionDownloadTask()
     activity_animation.startAnimating()
     activity_animation.hidesWhenStopped = true
     
     self.recordBtn.isUserInteractionEnabled = false
     downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
     
     customURL , response , error in
     DispatchQueue.main.async {
     self.play(url: customURL!)
     //  self.slider.maximumValue = Float(player.duration)
     }
     })
     downloadTask.resume()
     
     
     }
     
     
     func play(url : URL){
     do{
     player = try AVAudioPlayer(contentsOf: url)
     player.prepareToPlay()
     self.recordBtn.isUserInteractionEnabled = true
     
     
     activity_animation.stopAnimating()
     
     
     }
     catch {
     print(error)
     
     }
     }
     
     
     */
    @IBAction func Prview(_ sender: Any) {
        player.play()
    }
    
    
    
    
    
    
    
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
    
    
    
    
    
    
    
    
}



