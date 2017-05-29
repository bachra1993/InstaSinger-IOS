//
//  CustomTabBarViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/10/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    var user = UserInfo()
    var userUid : String!

   // @IBOutlet weak var tabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
             
        
        
        
        
    //Custom Button
        let itemWidh = self.view.frame.size.width / 5
        let itemHeight = self.tabBar.frame.size.height
        let button = UIButton(frame : CGRect(x: itemWidh * 2, y: self.view.frame.size.height - itemHeight, width: itemWidh, height: itemHeight))
        button.setBackgroundImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        
        
  //  button.addTarget(self, action: "upload", for: UIControlEvents.touchUpInside)
    //   self.view.addSubview(button)
        
        
        
        
    

        // Do any additional setup after loading the view.
    }
    
  /*
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if selectedIndex == 2 {
            
            let mv = CameraViewController()
            self.present(mv, animated: true, completion: nil)

            
            
        }
    }
*/
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
