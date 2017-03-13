//
//  Author.swift
//  TP5
//
//  Created by Antoine Hébert on 2017-03-12.
//  Copyright © 2017 Antoine Hébert. All rights reserved.
//

import Foundation
import CoreData

class Author: NSManagedObject{
    
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var gender: Int16
    @NSManaged var biography: String
    @NSManaged var imageAssetName: String
    @NSManaged var books: Set<Book>
    
    static let ENTITY_NAME: String = "Author"
    
    var booksCount: Int{
        return books.count
    }
    
}



