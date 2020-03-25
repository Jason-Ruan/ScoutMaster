//
//  MyTrailPersistenceHelper.swift
//  ScoutMaster
//
//  Created by Sam Roman on 3/16/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

struct MyTrailPersistenceHelper {

    private static var list = [MyTrail]()

    static let manager = MyTrailPersistenceHelper()

    func save(newItem: MyTrail) throws {
        try persistenceHelper.save(newElement: newItem)
    }
    func getItems() throws -> [MyTrail] {
        return try persistenceHelper.getObjects()
    }

    func delete(index: Int) throws {
        return try persistenceHelper.deleteAtIndex(index: index)

    }

    private let persistenceHelper = PersistenceHelper<MyTrail>(fileName: "MyTrails.plist")
    private init() {}
}
