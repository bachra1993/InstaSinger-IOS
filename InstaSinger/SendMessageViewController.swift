//
//  SendMessageViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 1/5/17.
//  Copyright © 2017 Bechir Kaddech. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import JSQMessagesViewController
class SendMessageViewController: JSQMessagesViewController {
    
    
    var userUID : String!
    var currentUID : String!
    var userName : String!
    var user = UserInfo()
    var listMessage = [NSDictionary?]()
    var messages = [JSQMessage]()
    var userImageView : UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = userName
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        currentUID = user.getCurrentUserUid()
        
        self.senderId = currentUID
        self.senderDisplayName = "bechir"
        
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        
        
        
        
        
        //self.navigationItem.title = "ok"
        
        print("user passed")
        print(userUID)
        
        observeMessages()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    private func observeMessages() {
        
        
        
        
        currentUID = user.getCurrentUserUid()
        
        
        let  ref = FIRDatabase.database().reference()
        
        
        ref.child("User_Message").child(currentUID).child(userUID).observe(
            .childAdded, with: { (snapshot) in
                
                print("interface send  message ")
                print (snapshot.key)
                
                
                
                ref.child("Messages").child(snapshot.key).observe(
                    .value, with: { (snapshot) in
                        
                        
                        print("Message")
                        print(snapshot)
                        let dictionary = snapshot.value as? [String : AnyObject]
                        
                        self.listMessage.append(dictionary as NSDictionary?)
                        print(dictionary?["text"])
                        
                        
                        self.addMessage(withId: (dictionary?["fromId"])! as! String, name: "Me", text: (dictionary?["text"])! as! String)
                        self.finishReceivingMessage()
                        self.collectionView.reloadData()
                        
                        //  self.collectionView.insertRows(at: [IndexPath(row:self.listMessage.count-1,section:0)], with: UITableViewRowAnimation.automatic)
                        
                        
                })
                
                
                
        })
        
        
    }
    
    
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        currentUID = user.getCurrentUserUid()
        
        if message.senderId == currentUID
        {
            return outgoingBubbleImageView
            
            
        }
        else {
            
            return incomingBubbleImageView
        }
        
        
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        
        
        return nil
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = 	super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        
        
        return cell
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //  messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        
        finishSendingMessage()
        collectionView.reloadData()
        
        
        
        
        
        //Sending Message to Firebase
        
        
        
        currentUID = user.getCurrentUserUid()
        
        
        
        
        let message : [String : AnyObject] = ["fromId" : currentUID as AnyObject,
                                              "text" : text as AnyObject  ,
                                              "time" : "date" as AnyObject,
                                              "toId" : userUID as AnyObject ,
                                              
                                              
                                              ]
        
        let  ref = FIRDatabase.database().reference()
        let key = ref.child("User-Message").child(currentUID).child(userUID).childByAutoId().key
        print("chips")
        print("current")
        print(currentUID)
        print("other")
        print(userUID)
        
        
        ref.child("User_Message").child(currentUID).child(userUID).child(key).setValue("1")
        ref.child("User_Message").child(userUID).child(currentUID).child(key).setValue("1")
        
        ref.child("Messages").child(key).setValue(message)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
