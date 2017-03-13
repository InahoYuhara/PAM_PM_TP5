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

    
    @IBOutlet weak var AuthorDetailPortrait: UIImageView!
    @IBOutlet weak var AuthorDetailLabel: UILabel!
    @IBOutlet weak var AuthorDetailBio: UITextView!
    
    @IBOutlet weak var BookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        AuthorDetailPortrait.image = UIImage(named: "\(author.imageAssetName)")
        AuthorDetailLabel.text = "\(author.firstname) \(author.lastname)"
        AuthorDetailBio.text = "\(author.biography)"
        
        do{
        
            let context = CoreDataStack.instance.persistentContainer.viewContext
            let request = NSFetchRequest<Book>(entityName: Book.ENTITY_NAME)
            request.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
            request.predicate = NSPredicate(format: "author.firstname == %@", author.firstname)
          
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
        print("numberofsection")
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            print("if let if")
            return sections[section].numberOfObjects
        }else {
            print("if let else")
            return fetchedResultsController.fetchedObjects!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CellforRow")
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorDetailBook_Cell", for: indexPath)
        
        let book: Book = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(book.title): "
        
        if(book.isRead == true){
            cell.imageView?.image = UIImage(named: "glasses")
        }
        
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("HER")
        self.BookTableView.reloadData()
    }
    
}
