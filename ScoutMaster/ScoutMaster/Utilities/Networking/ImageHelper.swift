//
//  ImageHelper.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/28/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    private init() {}
    static let shared = ImageHelper()
    
    func fetchImage(urlString: String, completionHandler: @escaping (Result<UIImage,AppError>) -> ()) {
        NetworkManager.shared.fetchData(urlString: urlString) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard let image = UIImage(data: data) else {completionHandler(.failure(.badImageData))
                    return
                }
                completionHandler(.success(image))
            }
        }
    }
}
