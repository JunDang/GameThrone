//
//  Character.swift
//  GameThronesFavorites
//
//  Created by Yinhuan Yuan on 5/16/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import Foundation

class Character: CustomStringConvertible {
    var name: String
    var houseName: String
    var imageThumbURL: String
    var hasFavorited: Bool = false
    init(dictionary: [String: Any]) {
        self.name = dictionary["characterName"] as? String ?? ""
        self.houseName = dictionary["houseName"] as? String ?? ""
        self.imageThumbURL = dictionary["characterImageThumb"] as? String ?? ""
    }
    
    var description: String {
        return "name: " + self.name + "house name: " + self.houseName + "imageURL: " + self.imageThumbURL
    }
}
