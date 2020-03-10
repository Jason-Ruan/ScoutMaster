//
//  POIPersistence.swift
//  ScoutMaster
//
//  Created by Sam Roman on 3/9/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation
struct POIPersistenceHelper {

    private static var list = [PointOfInterest]()

    static let manager = POIPersistenceHelper()

    func save(newItem: PointOfInterest) throws {
        try persistenceHelper.save(newElement: newItem)
    }
    func getItems() throws -> [PointOfInterest] {
        return try persistenceHelper.getObjects()
    }

    func delete(index: Int) throws {
        return try persistenceHelper.deleteAtIndex(index: index)

    }

    private let persistenceHelper = PersistenceHelper<PointOfInterest>(fileName: "pointsOfInterest.plist")
    private init() {}
}
