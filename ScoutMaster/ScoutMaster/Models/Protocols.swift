//
//  Protocols.swift
//  ScoutMaster
//
//  Created by Tia Lendor on 2/13/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

protocol ButtonPressed: AnyObject {
    func buttonPressed(tag: Int)
}

protocol FaveCellDelegate: AnyObject {
    func unfavorite(tag: Int)
}
