//
//  MainDocumentViewController.swift
//  DocumentsCoreData
//
//  Created by Megan Wilson on 9/19/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit
import CoreData

class MainDocumentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchController, UISearchResultsUpdating, UISearchBarDelegate {
   
    
    @IBOutlet weak var docTableView: UITableView!
    let dateForm = DateFormatter()
    var doc = [Document]()
    var searchControll : UISearchController?
    var selectedSearch = Search.everything
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"
        dateForm.dateStyle = .medium
        dateForm.timeStyle = .medium
        // Do any additional setup after loading the view.
        
        searchControll = UISearchController(searchResultsController: nil)
        searchControll?.searchResultsUpdater = self
        searchControll?.obscuresBackgroundDuringPresentation = false
        searchControll?.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchControll
        definesPresentationContext = true
        searchControll?.searchBar.scopeButtonTitles = Search.title
        searchControll?.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentsTableViewCell{
            let document = doc[indexPath.row]
            cell.nameLabel.text = document.name
            cell.sizeLabel.text = String(document.size) + " bytes"
            
            if let modifiedDate = document.modifiedDate{
                cell.modLabel.text = dateForm.string(from: modifiedDate)
            }
            else{
                cell.modLabel.text = "Empty"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete  {
            deleteDoc(at: indexPath)
        }
    }
    
    
   
    func fetchDocs() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest() as! NSFetchRequest<Document>
        do {
            doc = try manageContext.fetch(fetchRequest)
        } catch {
            alertNotifyUser(message: "Fetch for documents was not performed.")
            return
        }
    }
    
    
    
    
    
    
    
    
    
    
    func deleteDoc(at indexPath: IndexPath) {
        let document = doc[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            
            do {
                try managedObjectContext.save()
                self.doc.remove(at: indexPath.row)
                docTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                docTableView.reloadData()
            }
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            (alertAction) -> Void in
            print("OK selected")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let place = segue.destination as? DocViewController,
            let segueIdentifier = segue.identifier, segueIdentifier == "existingDoc",
            let row = docTableView.indexPathForSelectedRow?.row{
            place.document = doc[row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDocs()
        docTableView.reloadData()
    }
    

    
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


