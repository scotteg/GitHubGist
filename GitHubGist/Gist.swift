//
//  Gist.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/10/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit
import RealmSwift

final class Gist: Object {
    
    enum Keys: String {
        var $: String {
            return rawValue
        }
        
        case id, createdAt
    }
    
    dynamic var id = ""
    dynamic var urlString = ""
    dynamic var htmlUrlString = ""
    dynamic var avatarUrlString = ""
    dynamic var ownerLogin = ""
    dynamic var filename = ""
    dynamic var desc = ""
    dynamic var commentsCount = 0
    dynamic var createdAt = Date()
    
    convenience init(id: String, urlString: String, htmlUrlString: String, avatarUrlString: String, ownerLogin: String, filename: String, description: String, commentsCount: Int, createdAt: Date) {
        self.init()
        self.id = id
        self.urlString = urlString
        self.htmlUrlString = htmlUrlString
        self.avatarUrlString = avatarUrlString
        self.ownerLogin = ownerLogin
        self.filename = filename
        desc = description
        self.commentsCount = commentsCount
        self.createdAt = createdAt
    }
    
    override static func primaryKey() -> String? {
        return Keys.id.$
    }
    
    override static func indexedProperties() -> [String] {
        return [Keys.createdAt.$]
    }
}
