//
//  CoreDataStack.swift
//  Quiz5
//
//  Created by James Hoffman on 2017-02-07.
//  Copyright © 2017 PAM. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let instance = CoreDataStack()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quiz5")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func insertInitialData() {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<Author>(entityName: Author.entity().name!)
        
        do {
            let itemsCount = try context.fetch(request).count
            
            if (itemsCount == 0) {
                
                if let path = Bundle.main.path(forResource: "InitialData", ofType: "plist"),
                    let data = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                    
                    for (_ , authorData) in data {
                        let authorEntity = NSEntityDescription.insertNewObject(forEntityName: Author.entity().name!, into: context) as! Author
                        
                        authorEntity.firstname = authorData["firstname"] as! String
                        authorEntity.lastname = authorData["lastname"] as! String
                        authorEntity.gender = authorData["gender"] as! Int16
                        authorEntity.imageAssetName = authorData["imageName"] as! String
                        authorEntity.biography = authorData["bio"] as! String
                        
                        for (_, bookData) in authorData["books"] as! [String : AnyObject] {
                            let bookEntity = NSEntityDescription.insertNewObject(forEntityName: Book.entity().name!, into: context) as! Book
                            
                            bookEntity.title = bookData["title"] as! String
                            bookEntity.yearPublished = bookData["year"] as! Int16
                            bookEntity.abstract = bookData["abstract"] as! String
                            bookEntity.isRead = false
                            bookEntity.author = authorEntity
                        }
                    }
                }
                
                saveContext()
            }
        } catch { }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
