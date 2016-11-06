//
//  Thumbnail.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit

protocol ThumbnailDelegate {
    func thumbnailTouchesMoved(_ thumbnail:Thumbnail, touches: Set<UITouch>, withEvent event: UIEvent?);
    func thumbnailTouchesEnded(_ thumbnail:Thumbnail, touches: Set<UITouch>, withEvent event: UIEvent?);
}

class Thumbnail: UIImageView, DraggableThumbnailDelegate {
    
    var delegate:ThumbnailDelegate!
    var originalFrame:CGRect!
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self.hidden = true
        // self.originalFrame = self.frame
        delegate.thumbnailTouchesMoved(self, touches: touches, withEvent:event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate.thumbnailTouchesEnded(self, touches: touches, withEvent: event)
        self.animateToPreviousThumbnail()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch:UITouch = touches.first!
        self.center = touch.location(in: self.superview)
        delegate.thumbnailTouchesMoved(self, touches: touches, withEvent: event)
        
    }
    
    func animateToPreviousThumbnail(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = self.originalFrame
        }, completion: { (success) -> Void in
        })
    }
    
    
    func finishedDragging() {
    }
    
    func thumbnailDestroyed() {
        self.isHidden = false
    }
    
}

