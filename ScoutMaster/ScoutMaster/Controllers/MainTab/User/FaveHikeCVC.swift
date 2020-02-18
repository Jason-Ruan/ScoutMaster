//
//  FaveHikeCVC.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 2/11/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class FaveHikeCVC: UICollectionViewCell {
    
    lazy var userFavedImages : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alps")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        contentView.backgroundColor = .white
    }
//  MARK: PRIVATE FUNC
    
    private func addViews(){
        contentView.addSubview(userFavedImages)
        
    }
    
    private func addConstraints(){
        constrainImageView()
        
    }
    
    private func constrainImageView(){
        userFavedImages.translatesAutoresizingMaskIntoConstraints = false
        [userFavedImages.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
         userFavedImages.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
         userFavedImages.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.50),
         userFavedImages.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44)
            ].forEach{$0.isActive = true}
    }
    
    /*
    func configureCell(post: FavedHikes) {
        FirebaseStorage.postManager.getImages(profileUrl: post.img) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let imageData):
                self.userFavedImages.image = UIImage(data: imageData)
            }
        }
        FirestoreService.manager.getUserFromPost(creatorID: <#T##String#>, completion: <#T##(Result<AppUser, Error>) -> ()#>) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let user):
                    print("configureCell success")
                }
            }
        }
    }
 */
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
