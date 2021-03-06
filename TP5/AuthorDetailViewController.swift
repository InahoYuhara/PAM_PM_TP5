//
//  AuthorDetailViewController.swift
//  TP5
//
//  Created by Antoine Hébert on 2017-03-13.
//  Copyright © 2017 Antoine Hébert. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AuthorDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate,UITextFieldDelegate {
    
        var author: Author!
        private var fetchedResultsController: NSFetchedResultsController<Book>!
    
    @IBOutlet weak var AuthorGenderIcon: UIImageView!
    @IBOutlet weak var AuthorDetailPortrait: UIImageView!
    @IBOutlet weak var AuthorDetailLabel: UILabel!
    @IBOutlet weak var AuthorDetailBio: UITextView!
    @IBOutlet weak var BookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        AuthorDetailPortrait.image = UIImage(named: "\(author.imageAssetName)")
        AuthorDetailLabel.text = "\(author.firstname) \(author.lastname)"
        AuthorDetailBio.text = "\(author.biography)"
        if(author.gender == 0){
            AuthorGenderIcon.image = UIImage(named: "male")
        }else{
            AuthorGenderIcon.image = UIImage(named: "female")
        }
        
        do{
        
            let context = CoreDataStack.instance.persistentContainer.viewContext
            let request = NSFetchRequest<Book>(entityName: Book.ENTITY_NAME)
            request.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
            request.predicate = NSPredicate(format: "author == %@", author)
          
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            try fetchedResultsController.performFetch()

        }catch{}
        
        BookTableView.delegate = self
        BookTableView.dataSource = self

        
    }
    func numberOfSections(in tabkeView: UITableView) -> Int{
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections[section].numberOfObjects
        }else {
            return fetchedResultsController.fetchedObjects!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorDetailBook_Cell", for: indexPath)
        
        let book: Book = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(book.title): "
        cell.detailTextLabel?.text = "\(book.yearPublished)"
        
        if(book.isRead == true){
            cell.imageView?.image = UIImage(named: "glasses")
        }else{cell.imageView?.image = nil}
        
        return cell
    }
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let member = self.fetchedResultsController.object(at: indexPath)
        
        if(member.isRead == false){
            let BookIsRead = UITableViewRowAction(style: .normal, title: "\(NSLocalizedString("editRowRead", comment: ""))") { (_, indexPath) in
                _ = CoreDataStack.instance.persistentContainer.viewContext
                member.isRead = true
                CoreDataStack.instance.saveContext()
                tableView.endEditing(true)
            }
            BookIsRead.backgroundColor = UIColor.green
            return[BookIsRead]
            
        }else{
            let BookNotRead = UITableViewRowAction(style: .normal, title: "\(NSLocalizedString("editRowToRead", comment: ""))") { (_, indexPath) in
                _ = CoreDataStack.instance.persistentContainer.viewContext
                member.isRead = false
                CoreDataStack.instance.saveContext()
                tableView.endEditing(true)
            }
            BookNotRead.backgroundColor = UIColor.red
            return[BookNotRead]
            
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.BookTableView.reloadData()
    }
    
}
