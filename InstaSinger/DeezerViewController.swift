//
//  DeezerViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/18/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import EZLoadingActivity
import Kingfisher
import CoreData
/*
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


*/

class DeezerViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate{
    
    
    var SearchURL = String()
    var mainImageURL = NSURL()
    
    var TopSingerImageUrl = String()
    
    var favoris = [NSManagedObject]()
        var CheckFavorits : Bool = false

    
    
    
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
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
    
    
    
    
    
    func getdata(url : String) {
        
        Checked = false
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
                    
                    
                    
                    let mainImageURL = self.artistJSON["picture_big"] as! String
                    
                    
                //    let mainImageURL = NSURL(string : self.artistJSON["picture_big"] as! String)!
                   // let mainImageData = NSData(contentsOf: mainImageURL as URL)
                  //  let mainImage = UIImage(data: mainImageData as! Data)
                    
                   
                    
                    
                  
                    
                    
                    self.posts.append(post.init(mainImage: mainImageURL, name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    
                    
                    
                    
                       self.tableView.reloadData()
                    EZLoadingActivity.hide(true, animated: true)

                    
                }
                
      
             
                
                    
                
                
               
               

                
            }
        }
    }
    
  
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        TopSongs()
      //  SaveSong()
        
     //   add()
        
        
        
       
      
      
      

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
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
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let SongCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SongCell")!
        
        
   
        
       // SongCell.imageView?.kf.setImage(with: posts[indexPath.row].mainImage as! Resource?)
        
                let pic:UIImageView = SongCell.viewWithTag(200) as! UIImageView
        let back:UIView = SongCell.viewWithTag(100)!
        let song:UILabel = SongCell.viewWithTag(1) as! UILabel
        let singer:UILabel = SongCell.viewWithTag(2) as! UILabel


        
        
      
        
        
        back.backgroundColor = UIColor.white
       
        back.layer.cornerRadius = 5.0
        pic.layer.cornerRadius = 5.0
        
        
        
        pic.layer.borderWidth = 0.7
         pic.layer.borderColor = Color.black.cgColor
        back.layer.borderWidth = 0.7
        back.layer.borderColor = Color.black.cgColor
        
        //back.layer.masksToBounds = false
        //pic.layer.masksToBounds = false
        
        pic.layer.shadowColor = UIColor.black.cgColor
        pic.layer.shadowOffset = CGSize(width: 3, height: 3)
        pic.layer.shadowOpacity = 0.8
        
        back.layer.shadowColor = UIColor.black.cgColor
        
        
        
        if CheckFavorits == true {
                 let f = favoris[indexPath.row]
            song.text = f.value(forKey: "song") as! String?
            singer.text = f.value(forKey: "singer") as! String?
            let url = URL(string : f.value(forKey: "songImage") as! String)
            pic.kf.setImage(with: url )


            
            
        }
        else {
            
       
        
        
        
        
        
        if Checked ==  false {
             let url = URL(string: posts[indexPath.row].mainImage)
            pic.kf.setImage(with: url )
            song.text = posts[indexPath.row].name
              singer.text = posts[indexPath.row].singer


            
            
            
        }
        else if (Checked == true ) {
            
            print(singers[indexPath.row].singer)
            
            let urlb = URL(string: singers[indexPath.row].mainImage)

            
            pic.kf.setImage(with: urlb )
            song.text = singers[indexPath.row].singer
            
        }
             }
        

  
            print(self.data.count)
            
        
        
        
        
        
       
        
        
        return SongCell

        

        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        // Set The Intiale State
        cell.alpha = 0
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        
        //Chnage final State
        UIView.animate(withDuration: 1.0) {
           cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }
        
        
        
        
    }
    
    
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        let keyword = searchBar.text
        SearchURL = "https://api.deezer.com/search?q=\(keyword!)"
        posts.removeAll()
        getdata(url : SearchURL)
        self.view.endEditing(true)
     

    }
    
    
    
    
    //Fetch Top 10 songs 
    
    
    
    
    
    
    func TopSongs(){
        posts.removeAll()
        Checked = false
        CheckFavorits = false

        
        
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
                    
                    
                    let mainImageURL = self.artistJSON["picture_big"] as! String

                    
                
                    
                    //let mainImageURL = NSURL(string : self.artistJSON["picture_big"] as! String)!
                    //let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                    
                
                    self.posts.append(post.init(mainImage: mainImageURL, name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    
              
                    
                    
                  self.tableView.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    @IBAction func FetchTopSongs(_ sender: Any) {
           TopSongs()
        
        
        
        
    }
    
    
    
    
    
    
    //Fetching Top Artists with url of their TrackList 
    
    
    
    
    
    
    
    
    
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
                    
                    let mainImageURL = SongJson["picture_big"] as! String
                    let singer = SongJson["name"] as! String
                    let TrackListUrl = SongJson["tracklist"] as! String
                    self.TopSingerImageUrl = mainImageURL
                    
                    
                    
               

                    self.singers.append(topSinger.init(mainImage: mainImageURL, TrackListUrl: TrackListUrl, singer: singer))
                    

                    
                    
                    
                    
                    //let mainImageURL = NSURL(string : self.artistJSON["picture_big"] as! String)!
                    //let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                /*
                    
                    self.posts.append(post.init(mainImage: mainImageURL, name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    
                    */
                    
                    
                    self.tableView.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            }
        }
        
        
        
        
    }

    
    
    
    
    
    
    @IBAction func FetchTopArtists(_ sender: Any) {
        TopArtists()
    }
    
    
    
    
    
    
    
    
    
    
    func top50(url : String) {
        
        Checked = false
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
                    
                    
                    
                //    let mainImageURL = self.artistJSON["picture_big"] as! String
                    
                    
                    //    let mainImageURL = NSURL(string : self.artistJSON["picture_big"] as! String)!
                    // let mainImageData = NSData(contentsOf: mainImageURL as URL)
                    //  let mainImage = UIImage(data: mainImageData as! Data)
                    
                    
                    
                    
                    
                    
                    
                    self.posts.append(post.init(mainImage:  self.albumJSON["cover_big"] as! String! ,name: SongJson["title_short"] as! String, songURL: SongJson["preview"] as! String!, singer: self.artistJSON["name"] as! String))
                    
                    
                    
                    
                    
                    self.tableView.reloadData()
                    EZLoadingActivity.hide(true, animated: true)
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Checked == true {
            top50(url: singers[indexPath.row].TrackListUrl)
            
        }
        
    }
    
    
    

    
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if Checked == false {
            return true
        }
        
        else {
            return false
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        if (CheckFavorits == false ) {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGray
            return [more]
        }
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
            
            
            
            
            
            
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
            
            
            
            
            do{
                try managedContext.save()
                print("saved ......")
                // self.navigationController?.popViewController(animated: true)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            
            
        }
        favorite.backgroundColor = UIColor.orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blue
        
        return [share, favorite]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
    
    
    
    //CoreData
    

    

    
  
    
    

    
    
    @IBAction func Favoris(_ sender: Any ) {
        
        CheckFavorits = true
        ShowFavoris()
        
        
        
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
            tableView.reloadData()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    
    
    
    
    
    
 
    
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! AudioVC
        
        
        if CheckFavorits == true {
            let f = favoris[indexPath!]
            vc.image = f.value(forKey: "songImage") as! String
            vc.mainSongTitle = f.value(forKey: "song") as! String
            vc.previewURL = f.value(forKey: "preview") as! String
            vc.singer = f.value(forKey: "singer") as! String
            
            
        }
        else {
        
        vc.image = posts[indexPath!].mainImage
        vc.mainSongTitle = posts[indexPath!].name
        vc.previewURL = posts[indexPath!].songURL
        vc.singer = posts[indexPath!].singer
        print(posts[indexPath!].songURL)
        
        
        
        }
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
