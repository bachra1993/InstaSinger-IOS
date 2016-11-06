//
//  DraggableThumbnail.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit

protocol DraggableThumbnailDelegate{
    func finishedDragging()
    func thumbnailDestroyed()
}

class DraggableThumbnail: UIImageView {
    
    var delegate:DraggableThumbnailDelegate!
    var originalFrame:CGRect!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    /*
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
     }
     
     override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
     delegate.finishedDragging()
     self.animateToPreviousThumbnail()
     }
     
     
     override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
     let touch:UITouch = touches.first!
     self.center = touch.locationInView(self.superview)
     
     }
     */
    
    func animateToPreviousThumbnail(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = self.originalFrame
        }, completion: { (success) -> Void in
            self.delegate.thumbnailDestroyed()
            self.removeFromSuperview()
        })
    }
    
}
