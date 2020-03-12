//
//  WeatherCell.swift
//  ScoutMaster
//
//  Created by Jason Ruan on 3/6/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

public enum ForecastType {
    case daily
    case hourly
}

class WeatherCell: UICollectionViewCell {
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .init(white: 0.3, alpha: 0.3)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI Objects
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var weatherIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.tintColor = .lightGray
        return iv
    }()
    
    lazy var weatherSummaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var lowTemperature: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var highTemperature: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var temperatureStackView: UIStackView = {
        let sv = UIStackView()
        let lineSeparator = UIView()
        
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        
        lineSeparator.backgroundColor = .black
        lineSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        lineSeparator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        sv.addArrangedSubview(self.lowTemperature)
        sv.addArrangedSubview(lineSeparator)
        sv.addArrangedSubview(self.highTemperature)
        return sv
    }()
    
    
    //MARK: - Properties
    var forecastType: ForecastType?
    
    //MARK: - Functions
    private func setUpCell() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(weatherSummaryLabel)
        contentView.addSubview(temperatureStackView)
        
        constrainSubviews()
        
    }
    
    private func constrainSubviews() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            dateLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height / 5)
        ])
        
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.topAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.bottomAnchor),
            weatherIconImageView.centerXAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.centerXAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height / 3)
        ])
        
        weatherSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherSummaryLabel.topAnchor.constraint(equalTo: weatherIconImageView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            weatherSummaryLabel.centerXAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.centerXAnchor),
            weatherSummaryLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            weatherSummaryLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureStackView.topAnchor.constraint(equalTo: weatherSummaryLabel.safeAreaLayoutGuide.bottomAnchor),
            temperatureStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            temperatureStackView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            temperatureStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
}
