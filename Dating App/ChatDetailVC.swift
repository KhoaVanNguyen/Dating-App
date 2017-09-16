//
//  ChatDetailVC.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage
class ChatDetailVC: JSQMessagesViewController {
    
    var conversation: Conversation!
    var messages = [JSQMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    var messageRef = FIRDatabase.database().reference().child("messages")
    
        let photoCache = NSCache<AnyObject, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(conversation.id)"
        self.navigationItem.hidesBackButton = false
        
        
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "IC_sendtext"), style: .plain, target: self, action: #selector(self.back_TouchUpInside))
        backBtn.tintColor = #colorLiteral(red: 0.952462852, green: 0.3920735717, blue: 0.9882180095, alpha: 1)
        navigationItem.setLeftBarButton(backBtn, animated: true)
        
        
        
        self.senderId = AuthService.instance.currentUid()
        self.senderDisplayName = "anonymous"
        observeMessages()
    }
    
    func back_TouchUpInside(){
        print("HERE")
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func observeUsers(_ id: String)
    {
        FIRDatabase.database().reference().child("users").child(id).observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                let avatarUrl = dict["profileUrl"] as! String
                
                //                self.setupAvatar(avatarUrl, messageId: id)
            }
        })
        
    }
    
    func setupAvatar(_ url: String, messageId: String)
    {
        if url != "" {
            let fileUrl = URL(string: url)
            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            self.avatarDict[messageId] = userImg
            self.collectionView.reloadData()
            
        } else {
            avatarDict[messageId] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profileImage"), diameter: 30)
            collectionView.reloadData()
        }
        
    }
    
    func observeMessages() {
       
        DataService.instance.loadMessage(inConversation: conversation.id) { (message) in
            print(message)
            
            
            switch message.type {
            case "TEXT":
                
                let jMessage = JSQMessage(senderId: message.senderId, displayName: message.senderName, text: message.text
                )
                self.messages.append(jMessage!)
                self.collectionView.reloadData()
                
            case "PHOTO":
                var photo = JSQPhotoMediaItem(image: nil)
                let fileUrl = message.fileUrl as! String
                
                if let cachedPhoto = self.photoCache.object(forKey: fileUrl as AnyObject) as? JSQPhotoMediaItem {
                    photo = cachedPhoto
                    self.collectionView.reloadData()
                } else {
                    
                    DispatchQueue.main.async {
//                        let data = NSData(contentsOfURL: NSURL(string: fileUrl)! as URL)

                        do {
                            
                            let data = try Data(contentsOf: URL(string: fileUrl)!)
                            let image = UIImage(data: data)
                            photo?.image = image
                            self.collectionView.reloadData()
                            self.photoCache.setObject(photo!, forKey: fileUrl as AnyObject)

                            
                            let photo = JSQPhotoMediaItem(image: nil)
                            let fileUrl = message.fileUrl as! String
                            let downloader = SDWebImageDownloader.shared()
                            downloader?.downloadImage(with: URL(string: fileUrl)!, options: [], progress: nil, completed: { (image, data, error, finished) in
                                DispatchQueue.main.async(execute: {
                                    photo?.image = image
                                    self.collectionView.reloadData()
                                })
                            })
                            
                            self.messages.append(JSQMessage(senderId: self.senderId, displayName: "anonymous", media: photo))
                            
                            if self.senderId == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                        }catch {
                            
                        }
                        
                    }
                    

                }
             
                
                
            case "VIDEO":
                break
//                let fileUrl = dict["fileUrl"] as! String
//                let video = URL(string: fileUrl)!
//                let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
//                self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: videoItem))
//                
//                if self.senderId == senderId {
//                    videoItem?.appliesMediaViewMaskAsOutgoing = true
//                } else {
//                    videoItem?.appliesMediaViewMaskAsOutgoing = false
//                }
                
            default:
                print("unknown data type")
                
            }
            
            
            
         
        }
        
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        //        collectionView.reloadData()
        //        print(messages)
        
        DataService.instance.addMessage(toConversation: self.conversation.id, type: "TEXT", text: text, senderName: "annonymous", senderId: AuthService.instance.currentUid(), recipientName: "annonymous", recipientId: conversation.recipient, fileUrl: nil) { (complete) in
            if complete {
                self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
            }
        }
    
        
        self.finishSendingMessage()
        self.scrollToBottom(animated: true)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("didPressAccessoryButton")
        
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) in
            
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            self.getMediaFrom(kUTTypeImage)
        }
        
        let videoLibrary = UIAlertAction(title: "Video Library", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            self.getMediaFrom(kUTTypeMovie)
            
        }
        
        
        sheet.addAction(photoLibrary)
        sheet.addAction(videoLibrary)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
        //        let imagePicker = UIImagePickerController()
        //        imagePicker.delegate = self
        //        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func getMediaFrom(_ type: CFString) {
        print(type)
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        
        
        if message.senderId == self.senderId {
//            return bubbleFactory!.outgoingMessagesBubbleImage(with: .black)
            return bubbleFactory!.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
        } else {
            
            return bubbleFactory!.incomingMessagesBubbleImage(with: #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1))
            
        }
        
       
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        
        return avatarDict[message.senderId]
        //return JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "profileImage"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of item:\(messages.count)")
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("didTapMessageBubbleAtIndexPath: \(indexPath.item)")
        let message = messages[indexPath.item]
        
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutDidTapped(_ sender: AnyObject) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // From main storyboard instantiate a View controller
//        let LogInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
//
        
        // EDIT LATER
        // Get the app delegate
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        // Set LogIn View Controller as root view controller
//        appDelegate.window?.rootViewController = LogInVC
    }
    
    func sendMedia(_ picture: UIImage?, video: URL?) {
    
        
        if let picture = picture {
            let filePath = "\(AuthService.instance.currentUid())/\(Date.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = UIImageJPEGRepresentation(picture, 0.1)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            FIRStorage.storage().reference().child(filePath).put(data!, metadata: metadata) { (metadata, error)
                in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                
                let newMessage = self.messageRef.childByAutoId()
                let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "PHOTO"]
                
                
                DataService.instance.addMessage(toConversation: self.conversation.id, type: "PHOTO", text: "", senderName: "anonymous", senderId: self.senderId, recipientName: "anonymous", recipientId: self.conversation.recipient, fileUrl: fileUrl, completion: { (completed) in
                    
                })
                
                
            }
            
        } else if let video = video {
            let filePath = "\(AuthService.instance.currentUid())/\(Date.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = try? Data(contentsOf: video)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mp4"
            FIRStorage.storage().reference().child(filePath).put(data!, metadata: metadata) { (metadata, error)
                in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                
//                let newMessage = self.messageRef.childByAutoId()
//                let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO"]
//                newMessage.setValue(messageData)
                
                
                DataService.instance.addMessage(toConversation: self.conversation.id, type: "PHOTO", text: "", senderName: "anonymous", senderId: self.senderId, recipientName: "anonymous", recipientId: self.conversation.recipient, fileUrl: fileUrl, completion: { (completed) in
                    
                })
            }
        }
    }
}

extension ChatDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            sendMedia(picture, video: nil)
        }
        else if let video = info[UIImagePickerControllerMediaURL] as? URL {
            
            sendMedia(nil, video: video)
            
        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
        
    }
}



