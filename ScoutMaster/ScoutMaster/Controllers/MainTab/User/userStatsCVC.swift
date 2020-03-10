//
//  userStatsCVC.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 3/2/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class userStatsCVC: UICollectionViewCell {
    
    
    lazy var StatLabel: UILabel = {
       let name = UILabel()
        name.font = UIFont(name: "Baskerville", size: 22)
        name.textAlignment = .left
        name.textColor = .white
        return name
    }()
    
    lazy var statStat: UILabel = {
       let name = UILabel()
        name.font = UIFont(name: "Baskerville", size: 22)
        name.textAlignment = .left
        name.textColor = .white
        return name
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        contentView.backgroundColor = .white
    }
    
    private func addViews(){
        contentView.addSubview(StatLabel)
        contentView.addSubview(statStat)
    }
    
    private func addConstraints(){
        constrainStatLabel()
        constrainStatStat()
       
        
    }
    
    private func constrainStatLabel(){
       self.StatLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.StatLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.StatLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.StatLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func constrainStatStat(){
        self.statStat.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.statStat.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.statStat.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.statStat.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
