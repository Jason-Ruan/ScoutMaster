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
    
    var userPost = [FavedHikes] () {
        didSet {
            faveHikesCollection.reloadData()
        }
    }
    
    var userStats =  [UserStats] () {
        didSet {
            statsCollection.reloadData()
        }
    }
    
    
//    MARK: UI OBJECTS
    
    lazy var userImage: UIImageView = {
    let defaultImage = UIImageView()
        defaultImage.image = UIImage(named: "alps")
        return defaultImage
    }()
    
    lazy var userName: UILabel = {
       let name = UILabel()
        name.text = "Hello Scout!"
        return name
    }()

    
    lazy var faveHikesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .darkGray
        cv.register(FaveHikeCVC.self, forCellWithReuseIdentifier: "faveCell")
        return cv
    }()
    

        lazy var statsCollection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
            let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            cv.backgroundColor = .lightGray
            cv.register(userStatsCVC.self, forCellWithReuseIdentifier: "userStatCell")
            return cv
        }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        faveHikesCollection.delegate = self
        faveHikesCollection.dataSource = self
        statsCollection.delegate = self
        statsCollection.dataSource = self
        view.backgroundColor = .white
        getfaved()
        addSubview()
        addConstraints()
        print(user.uid)
    }
    
// MARK: PRIVATE FUNCS
    
    
    private func getfaved(){
           FirestoreService.manager.getUserFaved(userId: user.uid) { (result) in
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
    
    private func addSubview() {
        view.addSubview(faveHikesCollection)
        view.addSubview(statsCollection)
        view.addSubview(userImage)
        view.addSubview(userName)
    }
    
    private func addConstraints(){
        constrainFaveCollectionView()
        constrainStatsCollection()
        profileimageConstraint()
        profileNameConstraint()
        
    }
    
    
//    private func setUp() {
//        if user.userName == nil {
//            userName.text = user.email
//        } else {
//            userName.text = user.userName
//        }
//
//        if let photoUrl = user.photoURL {
//        FirebaseStorage.profileManager.getImages(profileUrl: photoUrl) { (result) in
//            switch result{
//            case .failure(let error):
//                self.userImage.image = UIImage(named: "alps")
//            case .success(let data):
//                self.userImage.image = UIImage(data: data)
//            }
//        }
//        } else {
//            self.userImage.image = UIImage(named: "alps")
//        }
//    }
    
    
    private func constrainFaveCollectionView(){

        faveHikesCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            faveHikesCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 550),
            faveHikesCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            faveHikesCollection.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func constrainStatsCollection(){
        statsCollection.translatesAutoresizingMaskIntoConstraints = false
        [statsCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
         statsCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
         statsCollection.widthAnchor.constraint(equalTo: view.widthAnchor)].forEach {$0.isActive = true}
    }
    
    private func profileimageConstraint() {
               userImage.translatesAutoresizingMaskIntoConstraints = false
               [userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
                userImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
                userImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant:  300)].forEach{$0.isActive = true}
    }
    
    
    private func profileNameConstraint() {
               userName.translatesAutoresizingMaskIntoConstraints = false
               [userName.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                userName.bottomAnchor.constraint(equalTo: view.topAnchor, constant:  150)].forEach{$0.isActive = true}
    }
    
    
    
    
    

     

}


extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numOfItems = 0
        
        if collectionView == faveHikesCollection {
            
        print("i got \(userPost.count) faved hikes")
        
        numOfItems = userPost.count
            
        } else {
            numOfItems = 5
        }
        
        return numOfItems
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == faveHikesCollection {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "faveCell", for: indexPath) as? FaveHikeCVC else {return UICollectionViewCell()}
        let data = userPost[indexPath.row]
        cell.userFavedTrailName.text = data.name
        
        ImageHelper.shared.fetchImage(urlString: data.img!) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    cell.userFavedImages.image = UIImage(named: "alps")
                case .success(let img):
                    cell.userFavedImages.image = img
                }
            }
        }

        return cell
        } else {
            guard let statCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userStatCell", for: indexPath) as? userStatsCVC else {return UICollectionViewCell()}
//            let statData = userStats[indexPath.row]
            
            statCell.StatLabel.text = "someStats"
            return statCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 380, height: 400)
    }
    
    
    
    
}


