//
//  BookTableViewController.swift
//  TP5
//
//  Created by Antoine Hébert on 2017-03-12.
//  Copyright © 2017 Antoine Hébert. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BookTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    private var fetchedResultsController: NSFetchedResultsController<Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request = NSFetchRequest<Book>(entityName: Book.ENTITY_NAME)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: "isRead", cacheName: nil)
        do{
            
            fetchedResultsController.delegate = self

            //let results =  try context.fetch(request)
            try fetchedResultsController.performFetch()

            
        }catch{}
        
        
    }
    
    override func numberOfSections(in tabkeView: UITableView) -> Int{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "book_cell", for: indexPath)
        let book = fetchedResultsController.object(at: indexPath)
        let author = fetchedResultsController.object(at: indexPath).author
        cell.textLabel?.text = "\(book.title)"
        cell.detailTextLabel?.text = "\(author.lastname), \(author.firstname) (\(book.yearPublished))"
        
       // cell.imageView?.image = UIImage(named: "\(author.imageAssetName)"
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "bookDetail_Segue"){
            if let dest = segue.destination as? BookDetailViewController,
                let cell = sender as? UITableViewCell,
                let indexPath =  tableView.indexPath(for: cell){
                let book = fetchedResultsController.object(at: indexPath)
                dest.book = book
            }
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
            case 0:
            return "\(NSLocalizedString("editRowToRead", comment: ""))"
            case 1:
            return "\(NSLocalizedString("editRowRead", comment: ""))"
            default:
            return "nothing"
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
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

//
//NSfetchedResultsControllerDelegate
//
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    

    
}
