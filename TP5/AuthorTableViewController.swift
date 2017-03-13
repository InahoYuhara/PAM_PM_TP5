//
//  AuthorTableViewController.swift
//  TP5
//
//  Created by Antoine Hébert on 2017-03-12.
//  Copyright © 2017 Antoine Hébert. All rights reserved.
//


import UIKit
import CoreData


class AuthorTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<Author>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request = NSFetchRequest<Author>(entityName: Author.ENTITY_NAME)
        request.sortDescriptors = [NSSortDescriptor(key: "firstname", ascending: true)]
                                   //NSSortDescriptor(key: "gender", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: /*#keyPath(Author.gender)*/"gender", cacheName: nil)
        do{
            
            let results =  try context.fetch(request)
            if(results.count == 0)
            {
                
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
                
            }
            
            //fetchedResultsController.delegate = self
            
            try fetchedResultsController.performFetch()

            
        }catch{}
        
    }
    
    
    override func numberOfSections(in tabkeView: UITableView) -> Int{
        print("\(fetchedResultsController.sections?.count)")
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections[section].numberOfObjects
        }else {
            return fetchedResultsController.fetchedObjects!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "author_cell", for: indexPath)
        let author = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = author.firstname
        cell.detailTextLabel?.text = "Books: \(author.booksCount)"
        
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return fetchedResultsController.sections![section].name
        switch section{
        case 0:
            return "MAN"
        case 1:
            return "WOMAN"
        default:
            return "nothing"
        }
    }


    
}
