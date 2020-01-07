//
//  ViewController.swift
//  FireMessenger
//
//  Created by Eyes on 2020-01-06.
//  Copyright © 2020 Eyes. All rights reserved.
//

import UIKit
import CoreData

class FriendsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var messages : [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        setupData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.item] {
            cell.message = message
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.friend = messages?[indexPath.row].friend
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

class MessageCell : BaseCell {
    
    override var isHighlighted : Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : .white
            nameLabelView.textColor = isHighlighted ? .white : .black
            timeLabelView.textColor = isHighlighted ? .white : .darkGray
            messageLabelView.textColor = isHighlighted ? .white : .darkGray
        }
    }
    
    var message : Message? {
        didSet {
            nameLabelView.text = message?.friend?.name ?? ""
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            } else {
                profileImageView.image = nil
                hasReadImageView.image = nil
            }
            
            messageLabelView.text = message?.text
            
            if let date = message?.date {
                let df = DateFormatter()
                df.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = Date().timeIntervalSince(date)
                
                let secondInDays : TimeInterval = 60 * 60 * 24
                
                if (elapsedTimeInSeconds > 7 * secondInDays) {
                    df.dateFormat = "MM/dd/yy"
                } else if (elapsedTimeInSeconds > secondInDays) {
                    df.dateFormat = "EEE"
                }
                
                timeLabelView.text = df.string(from: date)
            }
        }
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white : 0.5, alpha : 0.5)
        return view
    }()
    
    let nameLabelView : UILabel = {
        let label = UILabel()
        label.text = "Friend Name"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabelView : UILabel = {
        let label = UILabel()
        label.text = "Your friend's message and something else..."
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabelView : UILabel = {
        let label = UILabel()
        label.text = "12:05 PM"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        profileImageView.image = UIImage(named: "cat")
        hasReadImageView.image = UIImage(named: "cat")

        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabelView)
        containerView.addSubview(messageLabelView)
        containerView.addSubview(timeLabelView)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabelView, timeLabelView)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabelView, messageLabelView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabelView, hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:|[v0(20)]", views: timeLabelView)
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
    
}

class BaseCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

extension UIView {
    func addConstraintsWithFormat(format : String, views : UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension FriendsViewController {
    
    func createMessageWithText(text : String, friend : Friend, minutesAgo : Double, context : NSManagedObjectContext) {
        let dogMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        dogMessage.friend = friend
        dogMessage.text = text
        dogMessage.date = Date().addingTimeInterval(-minutesAgo * 60)
    }
    
    func setupData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        clearData()
        if let context = delegate?.persistentContainer.viewContext {
            let cat = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            cat.name = "Catty Cat"
            cat.profileImageName = "cat"

            createMessageWithText(text: "Heyy I'm cat", friend: cat, minutesAgo : 3, context: context)
            createMessageWithText(text: "Hope you are doing good. I'm also doing good. ", friend: cat, minutesAgo : 2, context: context)
            createMessageWithText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus finibus semper arcu, eu scelerisque libero. Vivamus convallis, lacus sed venenatis ultrices, lacus augue ornare nibh, in placerat eros ex non nisl. Integer nulla quam, tincidunt eu mollis non, sodales a mi. Vivamus sagittis id justo eget ultrices. Maecenas non libero egestas, condimentum lacus eget, mollis justo. Aenean nulla tellus, tincidunt vitae ullamcorper quis, ullamcorper id augue. Etiam tincidunt velit dapibus nunc fringilla facilisis.", friend: cat, minutesAgo : 1, context: context)

            let dog = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            dog.name = "Cute Dog"
            dog.profileImageName = "dog"

            createMessageWithText(text: "Heyy I'm dog", friend: dog, minutesAgo : 2, context: context)

            do {
                try context.save()
            } catch let error {
                print(error)
            }
            
//            messages = [message,dogMessage]
            
        }
        loadData()
    }
        
        func clearData() {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            if let context = delegate?.persistentContainer.viewContext {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                let friendFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                let deleteFriendsRequest = NSBatchDeleteRequest(fetchRequest: friendFetchRequest)
                
                do {
                    try context.execute(deleteRequest)
                    try context.execute(deleteFriendsRequest)
                    try context.save()
                } catch let error {
                    print("error deleting : \(error)")
                }
                
            }
        }
        
        func loadData() {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            if let context = delegate?.persistentContainer.viewContext {
                
                messages = []
                
                if let friendsRequest = fetchFriends() {
                    for friend in friendsRequest {
                        let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
                        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                        fetchRequest.predicate = NSPredicate(format : "friend.name = %@", friend.name!)
                        fetchRequest.fetchLimit = 1
                        do {
                            let fetchedMessages = try context.fetch(fetchRequest)
                            messages?.append(contentsOf: fetchedMessages)
                        } catch let error {
                            print(error)
                        }
                    }
                }
                
                messages = messages?.sorted(by : {$0.date!.compare($1.date!) == .orderedDescending})
            }
        }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request : NSFetchRequest<Friend> = Friend.fetchRequest()
            do {
                return try context.fetch(request)
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}



//class Message : NSObject {
//    var text : String?
//    var date : Date?
//
//    var friend : Friend?
//}
//
//class Friend : NSObject {
//    var name : String?
//    var profileImageName : String?
//}

