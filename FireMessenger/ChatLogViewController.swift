//
//  ChatLogViewController.swift
//  FireMessenger
//
//  Created by Eyes on 2020-01-07.
//  Copyright © 2020 Eyes. All rights reserved.
//

import Foundation
import UIKit

class ChatLogController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var friend : Friend? {
        didSet {
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by : {$0.date!.compare($1.date!) == .orderedAscending})
        }
    }
    
    var messages : [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        cell.messageTextView.text = messages?[indexPath.item].text
        if let profileImageName = friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
        }
        if let message = messages?[indexPath.item], let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string : messageText).boundingRect(with: size, options : options, attributes : [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context : nil)
            
            if !message.isSender {
                cell.messageTextView.frame = CGRect(x: 54,y: 0,width: estimatedFrame.width + 16,height: estimatedFrame.height + 18)
                cell.textBubbleView.frame = CGRect(x: 48 - 10 , y: -4, width: estimatedFrame.width + 16 + 8 + 16,height: estimatedFrame.height + 18 + 4)
                cell.profileImageView.isHidden = false
//                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha : 1)
                cell.messageTextView.textColor = .black
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha : 1)
                cell.bubbleImageView.image = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8,y: 0,width: estimatedFrame.width + 16,height: estimatedFrame.height + 18)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4 ,width: estimatedFrame.width + 16 + 8 + 10,height: estimatedFrame.height + 18 + 6)
                cell.profileImageView.isHidden = true
//                cell.textBubbleView.backgroundColor = UIColor(red : 0, green: 137/255, blue : 249/255, alpha : 1)
                cell.messageTextView.textColor = .white
                cell.bubbleImageView.tintColor = UIColor(red : 0, green: 137/255, blue : 249/255, alpha : 1)
                cell.bubbleImageView.image = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
            }
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string : messageText).boundingRect(with: size, options : options, attributes : [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context : nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8,left: 0,bottom: 0,right: 0)
    }
}

class ChatLogMessageCell : BaseCell {
    
    let textBubbleView : UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.95, alpha : 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize : 18)
        textView.text = "Sample Message"
        textView.backgroundColor = .clear
        return textView
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let bubbleImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.90, alpha : 1)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: messageTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
    
}
