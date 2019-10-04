//
//  DocViewController.swift
//  DocumentsCoreData
//
//  Created by Megan Wilson on 9/20/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit

class DocViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var contentText: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        if let document = document{
            let name = document.name
            nameText.text = name
            contentText.text = document.content
            title = name
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameText.text
            else {
                alertNotifyUser(message: "Document not saved.")
                return
        }
        let docName = name.trimmingCharacters(in: .whitespaces)
        if (docName == ""){
            alertNotifyUser(message: "A name is required")
            return
        }
        
        let content = contentText.text
        if document == nil {
            document = Document(name: docName, context: content)
        }
        else{
            document?.update(name: docName, content: content)
        }
        
        if let document = document{
            do{
                let managed = document.managedObjectContext
                try managed?.save()
            }
            catch{
                alertNotifyUser(message: "The context couldn't be saved")
            }
        }
        else{
            alertNotifyUser(message: "The document wasn't created")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameChange(_ sender: Any) {
        title = nameText.text
    }
}
