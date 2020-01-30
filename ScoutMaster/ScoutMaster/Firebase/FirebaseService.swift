//
//  FirebaseService.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 1/30/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case posts
    case comments
    case markets
    case produceByMonth = "Produce"
    case produce = "ProduceByType"
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
    }
}


class FirestoreService {
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    func updateCurrentUser(userName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<(), Error>) -> ()){
        guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
            //MARK: TODO - handle can't get current user
            return
        }
        var updateFields = [String:Any]()
        
        if let user = userName {
            updateFields["userName"] = user
        }
        
        if let photo = photoURL {
            updateFields["photoURL"] = photo.absoluteString
        }
        
       
        //PUT request
        db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    /*
    func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                    let userID = snapshot.documentID
                    let user = AppUser(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
 */
    
    
 
    
  
    
   
    
    
    
//MARK: Posts

      

    

//    MARK: Faves
       /*
       
       func createfave(faved: FavedEvents, completion: @escaping (Result<(), Error>) -> ()) {
           let fields = faved.fieldsDict
           
           db.collection(FireStoreCollections.posts.rawValue).addDocument(data: fields) { (error) in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(()))
               }
           }
       }
       
       func getUserFaved(userId: String, completion: @escaping(Result<[FavedEvents], Error>) -> () ) {
           db.collection(FireStoreCollections.posts.rawValue).whereField("creatorID", isEqualTo: userId).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let posts = snapshot?.documents.compactMap({ (snapshot) -> FavedEvents? in
                        let postId = snapshot.documentID
                        let post = FavedEvents(from: snapshot.data(), id: postId)
                        return post
                    })
                    completion(.success(posts ?? []))
                }
            }
        }
    
    */
       


    private init () {}
}
