//
//  ProfileVC.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import FirebaseAuth 

class ProfileVC: UIViewController {
    
//    MARK: DATA
    var user = AppUser(from: FirebaseAuthService.manager.currentUser!)
    
    var userPost = [Post] () {
        didSet {
            faveHikesCollection.reloadData()
        }
    }
    
    
//    MARK: UI OBJECTS
    
    lazy var userImage: UIImageView = {
    let defaultImage = UIImageView()
        defaultImage.image = UIImage(named: "defaultpicture")
        return defaultImage
    }()
    
    lazy var userName: UILabel = {
       let name = UILabel()
        return name
    }()
    
    /*
    lazy var statsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            cv.backgroundColor = .lightGray
//          cv.register(mainVC.self, forCellWithReuseIdentifier: "mainCell")
//            cv.dataSource = self
//            cv.delegate = self
        return cv
    }()
 */
    
    lazy var faveHikesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .darkGray
        cv.register(FaveHikeCVC.self, forCellWithReuseIdentifier: "faveCell")
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        faveHikesCollection.delegate = self
        faveHikesCollection.dataSource = self
        view.backgroundColor = .white
        getPosts()
        addConstraints()
    }
    
// MARK: PRIVATE FUNCS
    

    
    private func addConstraints(){
        constrainFaveCollectionView()
        
    }
    
    private func constrainFaveCollectionView(){
        view.addSubview(faveHikesCollection)
        faveHikesCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            faveHikesCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faveHikesCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            faveHikesCollection.heightAnchor.constraint(equalToConstant: 300),
            faveHikesCollection.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }

     private func getPosts(){
              FirestoreService.manager.getAllPosts { (result) in
                  DispatchQueue.main.async {
                      switch result{
                      case .failure(let error):
                          print(error)
                      case .success(let data):
                          self.userPost = data
 
                          print(data.count)
                      }
                  }
              }
            
        }

}


extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("i got \(userPost.count) faved hikes")
        
        return userPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "faveCell", for: indexPath) as? FaveHikeCVC else {return UICollectionViewCell()}
        let data = userPost[indexPath.row]
        cell.configureCell(post: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}


