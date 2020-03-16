//
//  WeatherTableViewCell.swift
//  Weather Designs
//
//  Created by Jason Ruan on 3/12/20.
//  Copyright © 2020 Jason Ruan. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    //MARK: - UI Objects
    
    lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Damascus-Bold", size: 8)
        return label
    }()
    
    lazy var weatherIconImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var weatherDescription: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Tamil Sangam MN", size: 12)
        return label
    }()
    
    lazy var lowTempLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemBlue
        label.font = UIFont(name: "Damascus-Bold", size: 8)
        return label
    }()
    
    lazy var highTempLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemRed
        label.font = UIFont(name: "Damascus-Bold", size: 8)
        return label
    }()
    
    
    //MARK: - Private Properties
    
    
    //MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setUpViews()
    }
    
    
    //MARK: - Private Functions
    private func setUpViews() {
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(weatherDescription)
        weatherDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherDescription.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            weatherDescription.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -30),
        ])
        
        contentView.addSubview(weatherIconImageView)
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            weatherIconImageView.trailingAnchor.constraint(equalTo: weatherDescription.leadingAnchor, constant: -10),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 5),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
        
        
        
        contentView.addSubview(highTempLabel)
        highTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            highTempLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            highTempLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        contentView.addSubview(lowTempLabel)
        lowTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lowTempLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            lowTempLabel.trailingAnchor.constraint(equalTo: highTempLabel.safeAreaLayoutGuide.leadingAnchor, constant: -20)
        ])
        
    }

}
