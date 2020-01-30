//
//  Dashboard.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    var HPTrails = [Trail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        Trail.getTrails(lat: 41.3406907, long: -76.2594981) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let hikingProjectAPI):
                    self.HPTrails = hikingProjectAPI
                    print(self.HPTrails)
                }
            }
        }
    }


}
