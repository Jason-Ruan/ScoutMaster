//
//  TrailCell.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/31/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class TrailCell: UICollectionViewCell {
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Baskerville", size: 22)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.3, alpha: 0.7)
        return view
    }()
    
//    lazy var vStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [name, image])
//        stackView.distribution = .fillEqually
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        return stackView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCellAppearance()
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(infoView)
        infoView.addSubview(name)
//        self.contentView.addSubview(vStack)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addConstraints() {
        setImageConstraints()
        setNameConstraints()
        setInfoViewConstraints()
    }
    
    func configureCell(trail: Trail){
        backgroundColor = .white
        name.text = "\(trail.name)"
    }
    
    private func setUpCellAppearance() {
        self.layer.cornerRadius = 40
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
    }
    
    
    
    private func setNameConstraints() {
        self.name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.name.leadingAnchor.constraint(equalTo: self.infoView.leadingAnchor, constant: 5),
            self.name.trailingAnchor.constraint(equalTo: self.infoView.trailingAnchor, constant: -5),
            self.name.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setInfoViewConstraints() {
           self.infoView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               self.infoView.leadingAnchor.constraint(equalTo: self.image.leadingAnchor),
               self.infoView.trailingAnchor.constraint(equalTo: self.image.trailingAnchor),
               self.infoView.heightAnchor.constraint(equalToConstant: 100),
               self.infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
           ])
       }
       
    
    private func setImageConstraints() {
        self.image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.image.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
//    private func setNameStackViewConstraints() {
//        self.vStack.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            self.vStack.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 5),
//            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
//            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 5),
//            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
//        ])
//    }

    
}
