//
//  FaveHikeCVC.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 2/11/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class FaveHikeCVC: UICollectionViewCell {
    
    weak var delegate: ProfileVC?
    
    lazy var userFavedImages : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alps")
        return imageView
    }()
    
    lazy var userFavedTrailName: UILabel = {
       let name = UILabel()
        name.font = UIFont(name: "Baskerville", size: 22)
        name.textAlignment = .left
        name.textColor = .white
        return name
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.3, alpha: 0.7)
        return view
    }()
    
    lazy var faved: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(unfave(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func unfave (_ sender: UIButton) {
        delegate?.unfavorite(tag: sender.tag)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        contentView.backgroundColor = .white
    }
//  MARK: PRIVATE FUNC
    
    private func addViews(){
        contentView.addSubview(userFavedImages)
        contentView.addSubview(infoView)
        contentView.addSubview(userFavedTrailName)
        contentView.addSubview(faved)
        
    }
    
    private func addConstraints(){
        constrainImageView()
        setInfoViewConstraints()
        constrainName()
        faveButtonConstraint()
        
    }
    
    
    
    private func constrainImageView(){
       self.userFavedImages.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userFavedImages.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.userFavedImages.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.userFavedImages.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func setInfoViewConstraints() {
        self.infoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoView.leadingAnchor.constraint(equalTo: self.userFavedImages.leadingAnchor),
            self.infoView.trailingAnchor.constraint(equalTo: self.userFavedImages.trailingAnchor),
            self.infoView.heightAnchor.constraint(equalToConstant: 100),
            self.infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func constrainName() {
        self.userFavedTrailName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.userFavedTrailName.leadingAnchor.constraint(equalTo: self.infoView.leadingAnchor, constant: 5),
            self.userFavedTrailName.trailingAnchor.constraint(equalTo: self.infoView.trailingAnchor, constant: -5),
            self.userFavedTrailName.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func faveButtonConstraint() {
        self.faved.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.faved.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            self.faved.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -75),
            self.faved.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
