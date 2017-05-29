//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import EZLoadingActivity
import Kingfisher
import CoreData



//Declaration 


var player = AVAudioPlayer()


struct post {
    let mainImage : String!
    let name : String!
    let songURL : String!
    let singer : String!
}


struct topSinger {
    let mainImage : String!
    let TrackListUrl : String!
    let singer : String!
}


var SearchURL = String()
var mainImageURL = NSURL()

var TopSingerImageUrl = String()

var favoris = [NSManagedObject]()
var CheckFavorits : Bool = false
var CheckCanMark: Bool = true







var data = [[String:Any]]()
var posts = [post]()
var singers = [topSinger]()

//artist
var artistJSON = [String : AnyObject]()
var artist = [NSDictionary]()
//song
//  var songJSON = [String : AnyObject]()
var song = [NSDictionary]()
//album
var albumJSON = [String : AnyObject]()
var album = [NSDictionary]()

var Checked : Bool = false











class DemoViewController: ExpandingViewController ,UISearchBarDelegate {
  
  typealias ItemInfo = (imageName: String, title: String)
  fileprivate var cellsIsOpen = [Bool]()
  fileprivate let items: [ItemInfo] = [("item0", "Boston"),("item1", "New York"),("item2", "San Francisco"),("item3", "Washington")]
  
  @IBOutlet weak var pageLabel: UILabel!
    
    var SearchURL = String()
    var mainImageURL = NSURL()
    
    var TopSingerImageUrl = String()
    
    var favoris = [NSManagedObject]()
    var CheckFavorits : Bool = false
    
    
    @IBAction func search(_ sender: Any) {
        
        let alert = UIAlertController(title: "Search", message: "Write song name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text!)")
            
     
            self.SearchURL = "https://api.deezer.com/search?q=\(textField!.text!)"
            self.posts.removeAll()
            if (textField!.text! != "") {
                self.getdata(url: self.SearchURL)
            }
            else {
                
                self.SearchURL = "https://api.deezer.com/search?q=e"
                self.getdata(url: self.SearchURL)

            }


        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    var data = [[String:Any]]()
    var posts = [post]()
    var singers = [topSinger]()
    
    //artist
    var artistJSON = [String : AnyObject]()
    var artist = [NSDictionary]()
    //song
    //  var songJSON = [String : AnyObject]()
    var song = [NSDictionary]()
    //album
    var albumJSON = [String : AnyObject]()
    var album = [NSDictionary]()
    
    var Checked : Bool = false
    
    @IBAction func Favorites(_ sender: Any) {
        CheckFavorits = true
        CheckCanMark = false
        ShowFavoris()
        
    }
    
    @IBAction func TopSongs(_ sender: Any) {
        TopSongs()
    }
    
    @IBAction func TopArtist(_ sender: Any) {
        TopArtists()
        CheckCanMark = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keyword = searchBar.text
        SearchURL = "https://api.deezer.com/search?q=\(keyword!)"
        print("keyword")
        print(keyword)
        posts.removeAll()
        if (keyword != "") {
        getdata(url : SearchURL)
        }
        self.view.endEditing(true)
        
        
        
    }
    func ShowFavoris () {
        posts.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        //let predicate = NSPredicate(format: "name == %@",find)
        //fetchRequest.predicate = predicate
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            favoris = result as! [NSManagedObject]
            collectionView?.reloadData()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    func getdata(url : String) {
        
        
        Checked = false
        CheckCanMark = true
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(url).responseJSON { response in
      
            
            if let JSON = response.result.value {
                let jsonResult:Dictionary = JSON  as! Dictionary<String,AnyObject>
                self.data = jsonResult["data"] as! [[String:Any]]
                
                print("bachra")
            print(jsonResult["total"] as! NSNumber)
                let total = jsonResult["total"] as! NSNumber
                if (total == 0) {
                    print("no songs")
                    EZLoadingActivity.hide(true, animated: true)
                    let alert = UIAlertController(title: "Warning", message: "No songs", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.TopSongs()
                    


                    
                }
                else {
                
                
                for SongJson in self.data {
                    
                    self.artistJSON =  SongJson["artist"]  as! Dictionary<String,AnyObject>
                    self.albumJSON =  SongJson["album"]  as! Dictionary<String,AnyObject>
                    self.artist.append(self.artistJSON as NSDictionary)
                    self.album.append(self.albumJSON as NSDictionary)
                    self.song.append(SongJson as NSDictionary)
                    
                    
                    
                    let mainImageURL = self.artistJSON["picture_xl"] as! String
                    
                    
                    //    let mainImageURL = NSURL(string : self.artistJSON["picture_xl"] as! String)!
                    // let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //  let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                    
                    
                    self.posts.append(post.init(mainImage: mainImageURL, name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    
                    
                    
                    
                    self.collectionView?.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
                }
                
                
                
                
                
                
                
                
                
            }
        }
    }

    func TopArtists(){
        posts.removeAll()
        
        
        Checked = true
        CheckFavorits = false
        
        
        
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        let urlTopSongs = "https://api.deezer.com/chart/0"
        
        Alamofire.request(urlTopSongs).responseJSON { response in

            if let JSON = response.result.value {
                let jsonResult2:Dictionary = JSON  as! Dictionary<String,AnyObject>
                
                let jsonResult = jsonResult2["artists"] as! NSDictionary
                
                
                self.data = jsonResult["data"] as! [[String:Any]]
                
                
                for SongJson in self.data {
                    /*
                     
                     self.artistJSON =  SongJson["name"]  as! Dictionary<String,AnyObject>
                     self.albumJSON =  SongJson["album"]  as! Dictionary<String,AnyObject>
                     self.artist.append(self.artistJSON as NSDictionary)
                     self.album.append(self.albumJSON as NSDictionary)
                     self.song.append(SongJson as NSDictionary)
                     
                     */
                    
                    let mainImageURL = SongJson["picture_xl"] as! String
                    let singer = SongJson["name"] as! String
                    let TrackListUrl = SongJson["tracklist"] as! String
                    self.TopSingerImageUrl = mainImageURL
                    
                    
                    
                    
                    
                    self.singers.append(topSinger.init(mainImage: mainImageURL, TrackListUrl: TrackListUrl, singer: singer))
                    
                    
                    
                    
                    
                    
                    //let mainImageURL = NSURL(string : self.artistJSON["picture_xl"] as! String)!
                    //let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                    /*
                     
                     self.posts.append(post.init(mainImage: mainImageURL, name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                     
                     
                     */
                    
                    
                    self.collectionView?.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            }
        }
        
        
        
        
    }
    
    func top50(url : String) {
        
        Checked = false
        CheckCanMark = true
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(url).responseJSON { response in

            
            if let JSON = response.result.value {
                let jsonResult:Dictionary = JSON  as! Dictionary<String,AnyObject>
                self.data = jsonResult["data"] as! [[String:Any]]
                
                
                for SongJson in self.data {
                    
                    self.artistJSON =  SongJson["artist"]  as! Dictionary<String,AnyObject>
                    self.albumJSON =  SongJson["album"]  as! Dictionary<String,AnyObject>
                    self.artist.append(self.artistJSON as NSDictionary)
                    self.album.append(self.albumJSON as NSDictionary)
                    self.song.append(SongJson as NSDictionary)
                    
                    
                    
                    //    let mainImageURL = self.artistJSON["picture_xl"] as! String
                    
                    
                    //    let mainImageURL = NSURL(string : self.artistJSON["picture_xl"] as! String)!
                    // let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //  let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                    
                    
                    self.posts.append(post.init(mainImage:  self.albumJSON["cover_big"] as! String! ,name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    
                    
                    
                    
                    self.collectionView?.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }

    

    

    
    
    func TopSongs(){
        posts.removeAll()
        Checked = false
        CheckFavorits = false
        CheckCanMark = true
        
        
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        let urlTopSongs = "https://api.deezer.com/chart/0"
        
        Alamofire.request(urlTopSongs).responseJSON { response in
     
            if let JSON = response.result.value {
                let jsonResult2:Dictionary = JSON  as! Dictionary<String,AnyObject>
                
                let jsonResult = jsonResult2["tracks"] as! NSDictionary
                
                
                self.data = jsonResult["data"] as! [[String:Any]]
                
                
                for SongJson in self.data {
                    
                    self.artistJSON =  SongJson["artist"]  as! Dictionary<String,AnyObject>
                    self.albumJSON =  SongJson["album"]  as! Dictionary<String,AnyObject>
                    self.artist.append(self.artistJSON as NSDictionary)
                    self.album.append(self.albumJSON as NSDictionary)
                    self.song.append(SongJson as NSDictionary)
                    
                    
                    let mainImageURL = self.artistJSON["picture_xl"] as! String
                    
                    
                    
                    
                    //let mainImageURL = NSURL(string : self.artistJSON["picture_xl"] as! String)!
                    //let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                    
                    
                    self.posts.append(post.init(mainImage: mainImageURL, name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    print("madrid")
                    
                    
                    
                    self.collectionView?.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
   
                
                
            }
        }
        
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = sender as! NSIndexPath
        let vc = segue.destination as! PlayerController
        
        
        
        if CheckFavorits == true {
            let f = favoris[indexPath.row]
            vc.image = f.value(forKey: "songImage") as! String
            vc.mainSongTitle = f.value(forKey: "song") as! String
            vc.previewURL = f.value(forKey: "preview") as! String
            vc.singer = f.value(forKey: "singer") as! String
            
            
        }else {
        
        vc.image = posts[indexPath.row].mainImage
        vc.mainSongTitle = posts[indexPath.row].name
        vc.previewURL = posts[indexPath.row].songURL
        vc.singer = posts[indexPath.row].singer
        print(posts[indexPath.row].songURL)
        
        
        }
        
    }
    

}

// MARK: life cicle

extension DemoViewController {
  
  override func viewDidLoad() {
    itemSize = CGSize(width: 256, height: 335)
    super.viewDidLoad()
    
    registerCell()
    fillCellIsOpeenArry()
    addGestureToView(collectionView!)
    TopSongs()
  }
}

// MARK: Helpers 

extension DemoViewController {
  
  fileprivate func registerCell() {
    
    let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
  }
  
  fileprivate func fillCellIsOpeenArry() {
    for _ in items {
      cellsIsOpen.append(false)
    }
  }
  
  fileprivate func getViewController() -> ExpandingTableViewController {
    let storyboard = UIStoryboard(storyboard: .Main)
    let toViewController: DemoTableViewController = storyboard.instantiateViewController()
    return toViewController
  }
  

}

/// MARK: Gesture

extension DemoViewController {
  
  fileprivate func addGestureToView(_ toView: UIView) {
    let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .up
    }
    
    let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .down
    }
    toView.addGestureRecognizer(gesutereUp)
    toView.addGestureRecognizer(gesutereDown)
  }

  func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    let indexPath = IndexPath(row: currentIndex, section: 0)
    guard (collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell) != nil else { return }
    // double swipe Up transition
  
    
    print("Im swiped")
    
    
    
    if (CheckFavorits == true ) {
        
        print("delete from core data")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
       
        do{
            managedContext.delete(favoris[indexPath.row])
            favoris.remove(at: indexPath.row)
            collectionView?.reloadData()
            
            try managedContext.save()
        }
        catch let error as NSError
        {
            print(error)
        }
        
    }else {
    
    
    if (CheckCanMark == true) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Favoris", in:
        managedContext)
    let etudiant = NSManagedObject(entity: entity!, insertInto: managedContext)
    //  let url = URL(string: self.posts[indexPath.row].mainImage)
    
    etudiant.setValue(self.posts[indexPath.row].songURL, forKey:"preview")
    etudiant.setValue(self.posts[indexPath.row].singer, forKey:"singer")
    etudiant.setValue(self.posts[indexPath.row].name, forKey:"song")
    etudiant.setValue(self.posts[indexPath.row].mainImage, forKey:"songImage")
        let alert = UIAlertController(title: "Added", message: "Song saved to favorites", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    
    
    
    
    do{
        try managedContext.save()
        print("saved ......")
        // self.navigationController?.popViewController(animated: true)
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
    
    
  //  cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
    }
    else {
    print("cant add to favorite")
        }}}
}

// MARK: UIScrollViewDelegate


// MARK: UICollectionViewDataSource

extension DemoViewController {
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? DemoCollectionViewCell else { return }
    
    print("singer count ")
    print(singers.count)
    print("data count")
    print(data.count)
    
    
    if CheckFavorits == true {
        let f = favoris[indexPath.row]
        cell.customTitle.text = f.value(forKey: "song") as! String?
      //  singer.text = f.value(forKey: "singer") as! String?
        let url = URL(string : f.value(forKey: "songImage") as! String)
       cell.backgroundImageView.kf.setImage(with: url )
        
        
        
        
    }
    else {
        

    if (Checked == false) {
        
    
    let url = URL(string: posts[indexPath.row].mainImage)
    cell.backgroundImageView.kf.setImage(with: url)
    
    
    cell.customTitle.text = posts[indexPath.row].name
    }
    
    else if (Checked == true ) {
        
        print(singers[indexPath.row].singer)
        
        let urlb = URL(string: singers[indexPath.row].mainImage)
        
        
        cell.backgroundImageView.kf.setImage(with: urlb )
       cell.customTitle.text = singers[indexPath.row].singer
        
    }
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    guard let _ = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
          , currentIndex == (indexPath as NSIndexPath).row else { return }
/*
    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
      pushToViewController(getViewController())
      
      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(true)
      }
    }
 
    */
    
    if Checked == true {
        top50(url: singers[indexPath.row].TrackListUrl)
        
    }else {
        
        
    
    performSegue(withIdentifier: "Play", sender: indexPath)
    
    }
  }
    
    
    
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    
    if CheckFavorits == true {
        return favoris.count
        
    }
    else {
    
    if Checked == true {
        return singers.count
        
    }
    else {
        return data.count
        
    }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
  }
    
    
    
}















