//
//  HomePostCell.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/30/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate: class {
    func didTapComment(post: Posts)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    weak var delegate: HomePostCellDelegate?
    
    let PhotoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLike() {
        
        delegate?.didLike(for: self)
    }
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    @objc func handleComment() {
    
        print("handling comment")
        guard let post = self.post else {return}
        delegate?.didTapComment(post: post)
       
    }
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var post: Posts? {
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            PhotoImageView.loadImage(urlString: imageUrl)
            userNameLabel.text = post?.user?.username
            captionLabel.text = post?.caption
            
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            
            guard let userProfileUrl = post?.user?.profileImageUrl else {return}
            userProfileImageView.loadImage(urlString: userProfileUrl)
            
            setUpAttributedLabelText()
        }
    }
    
    fileprivate func setUpAttributedLabelText(){
        
        guard let post = self.post else {return}
        guard let username = post.user?.username else {return}
        guard let caption = post.caption else {return}
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " "+caption, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 3)]))
        
        guard let timeAgo = post.creationDate?.timeAgoDisplay() else {return}
        
        attributedText.append(NSAttributedString(string: timeAgo, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        addSubview(PhotoImageView)
        
        userProfileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        userProfileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: optionsButton.leftAnchor).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: PhotoImageView.topAnchor).isActive = true
        
        optionsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        optionsButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: PhotoImageView.topAnchor).isActive = true
        
        
        PhotoImageView.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 8).isActive = true
        PhotoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        PhotoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        PhotoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setUpActionButtons()
        
        addSubview(bookmarkButton)
        
        bookmarkButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        bookmarkButton.topAnchor.constraint(equalTo: PhotoImageView.bottomAnchor).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(captionLabel)
        
        captionLabel.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    fileprivate func setUpActionButtons(){
        
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: PhotoImageView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
