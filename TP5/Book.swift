//
//  Book.swift
//  TP5
//
//  Created by Antoine Hébert on 2017-03-12.
//  Copyright © 2017 Antoine Hébert. All rights reserved.
//

import Foundation
import CoreData

class Book: NSManagedObject {
    
    
    @NSManaged var title: String
    @NSManaged var yearPublished: Int16
    @NSManaged var abstract: String
    @NSManaged var isRead: Bool
    @NSManaged var name: String
    @NSManaged var author: Author
    
    static let ENTITY_NAME: String = "Book"
}
