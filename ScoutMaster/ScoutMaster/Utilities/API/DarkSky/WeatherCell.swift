//
//  WeatherCell.swift
//  ScoutMaster
//
//  Created by Jason Ruan on 3/6/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .init(white: 0.3, alpha: 0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI Objects
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if let dayForecast = self.dayForecast, let time = dayForecast.time {
            let dateInput = Date(timeIntervalSinceNow: TimeInterval(exactly: time) ?? 0)
            let formatter = DateFormatter()
            formatter.dateFormat = "E-M/d"
            formatter.locale = .current
            label.text = formatter.string(from: dateInput)
        }
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var weatherIconImageView: UIImageView = {
        let iv = UIImageView()
        if let dayForecast = self.dayForecast, let weatherIconName = dayForecast.icon {
//            iv.image = UIImage(named: weatherIconName)
            iv.image = UIImage(systemName: "cloud")
        }
        iv.backgroundColor = .clear
        iv.tintColor = .lightGray
        return iv
    }()
    
//    lazy var temperatureStackView: UIView = {
//        let view = UIView()
//        return view
//    }()
    
    lazy var temperatureStackView: UIStackView = {
       let sv = UIStackView()
        sv.alignment = .center
        sv.axis = .horizontal
        sv.addArrangedSubview(self.lowTemperature)
        sv.addArrangedSubview(self.highTemperature)
        return sv
    }()
    
    lazy var lowTemperature: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        if let dayForecast = self.dayForecast, let lowTemp = dayForecast.temperatureLow {
            label.text = """
            Low
            \(lowTemp.description)\u{00B0}
            """
        }
        return label
    }()
    
    lazy var highTemperature: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        if let dayForecast = self.dayForecast, let highTemp = dayForecast.temperatureHigh {
            label.text = """
            High
            \(highTemp.description)\u{00B0}
            """
        }
        return label
    }()
    
    
    //MARK: - Properties
    var dayForecast: DayForecastDetails? {
        didSet {
            setUpCell()
        }
    }
    
    
    //MARK: - Functions
    private func setUpCell() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(temperatureStackView)
        
        constrainSubviews()
//        configureTemperatureViews()
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
        
        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureStackView.topAnchor.constraint(equalTo: weatherIconImageView.safeAreaLayoutGuide.bottomAnchor),
            temperatureStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            temperatureStackView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            temperatureStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func configureTemperatureViews() {
//        temperatureView.addSubview(lowTemperature)
//        temperatureView.addSubview(highTemperature)
//
//        lowTemperature.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            lowTemperature.topAnchor.constraint(equalTo: temperatureView.safeAreaLayoutGuide.topAnchor),
//            lowTemperature.centerXAnchor.constraint(equalTo: temperatureView.safeAreaLayoutGuide.centerXAnchor),
//            lowTemperature.widthAnchor.constraint(equalToConstant: temperatureView.frame.width),
//            lowTemperature.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        highTemperature.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            highTemperature.topAnchor.constraint(equalTo: temperatureView.safeAreaLayoutGuide.topAnchor, constant: 100),
//            highTemperature.centerXAnchor.constraint(equalTo: temperatureView.safeAreaLayoutGuide.centerXAnchor),
//            highTemperature.widthAnchor.constraint(equalToConstant: temperatureView.frame.width),
//            highTemperature.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        
        
    }
    
    
}
