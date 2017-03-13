//
//  BookDetailViewController.swift
//  TP5
//
//  Created by Antoine Hébert on 2017-03-13.
//  Copyright © 2017 Antoine Hébert. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BookDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var ReadNotRead: UISegmentedControl!
    @IBOutlet weak var SubTitleLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BookDesc: UITextView!
    var book: Book!
    
    private var fetchedResultsController: NSFetchedResultsController<Book>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.text = book.title
        SubTitleLabel.text = "\(book.yearPublished), \(book.author.firstname) \(book.author.lastname)"
        SubTitleLabel.font = SubTitleLabel.font.withSize(13)
        
        BookDesc.text = book.abstract
        ReadNotRead.setTitle("Lu", forSegmentAt: 0)
        ReadNotRead.setTitle("Non lu", forSegmentAt: 1)
        
        do{
            
            let context = CoreDataStack.instance.persistentContainer.viewContext
            let request = NSFetchRequest<Book>(entityName: Book.ENTITY_NAME)
            request.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
            //request.predicate = NSPredicate(format: "book == %@", self.book)
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            try fetchedResultsController.performFetch()
            
        }catch{}

        
        
        if(book.isRead == true){
            ReadNotRead.selectedSegmentIndex = 0
        }
        else{ReadNotRead.selectedSegmentIndex = 1}
    }

    @IBAction func IndexChanged(_ sender: Any) {
        
        switch ReadNotRead.selectedSegmentIndex
        {
        case 0:book.isRead = true
            
        case 1:book.isRead = false
        default:
            break
        }
        
    }
   
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if(book.isRead == true){
            ReadNotRead.selectedSegmentIndex = 0
        }else{ReadNotRead.selectedSegmentIndex = 1}
    }
}
