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
            messages = messages?.sorted(by : {$0.date!.compare($1.date!) == .orderedDescending})
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
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string : messageText).boundingRect(with: size, options : options, attributes : [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context : nil)
            
            cell.messageTextView.frame = CGRect(x: 54,y: 0,width: estimatedFrame.width + 16,height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 46,y: 0,width: estimatedFrame.width + 16 + 54,height: estimatedFrame.height + 20)
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
        view.backgroundColor = UIColor(white: 0.95, alpha : 1)
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
    
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: messageTextView)
    }
    
}
