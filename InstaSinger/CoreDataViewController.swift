//
//  CoreDataViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 12/4/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var favoris = [NSManagedObject]()


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//SaveSong()
        print("lel data")
        add()
    
    }
    
    
    
    
    //CoreData
    
    
     
     func SaveSong()
     {
     
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let entity = NSEntityDescription.entity(forEntityName: "Favoris", in:
     managedContext)
     let etudiant = NSManagedObject(entity: entity!, insertInto: managedContext)
     etudiant.setValue("ok3", forKey:"preview")
     etudiant.setValue("ok3", forKey:"singer")
     etudiant.setValue("ok3", forKey:"song")
     etudiant.setValue("ok3", forKey:"songImage")
     
     
     
     
     do{
     try managedContext.save()
        print("saved ......")
     // self.navigationController?.popViewController(animated: true)
     } catch let error as NSError  {
     print("Could not save \(error), \(error.userInfo)")
     }}
     
     
    
    
    
     func add(){
     
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let managedContext = appDelegate.persistentContainer.viewContext
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
     //let predicate = NSPredicate(format: "name == %@",find)
     //fetchRequest.predicate = predicate
     
     
     do {
     let result = try managedContext.fetch(fetchRequest)
     favoris = result as! [NSManagedObject]
     print(favoris)
     print("core data")
     }
     catch let error as NSError {
     print("Could not fetch \(error), \(error.userInfo)")
     }
     }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!

        
        let f = favoris[indexPath.row]
           
       myCell.textLabel?.text = f.value(forKey: "singer") as? String
       
        
        return myCell
        
   
    
    
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return favoris.count
    }
     
 


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
