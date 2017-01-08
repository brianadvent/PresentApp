//
//  ChristmasPresentsTableViewController.swift
//  PresentBase
//
//  Created by Brian Advent on 24/12/2016.
//  Copyright © 2016 Brian Advent. All rights reserved.
//

import UIKit
import CoreData

class ChristmasPresentsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //var myGifts = [["name":"Best Friend","image":"1","item":"Camera"],["name":"Mom","image":"2","item":"Flowers"],["name":"Dad","image":"3","item":"Some kind of tech"],["name":"Sister","image":"4","item":"Sweets"]]
    
    
    var presents = [Present]()
    
    var managedObjextContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let iconImageView = UIImageView(image: UIImage(named: "Shape"))
        self.navigationItem.titleView = iconImageView
        
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        loadData()
    
    }
    
    func loadData(){
        let presentRequest:NSFetchRequest<Present> = Present.fetchRequest()
        
        do {
            presents = try managedObjextContext.fetch(presentRequest)
            self.tableView.reloadData()
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PresentsTableViewCell

        let presentItem = presents[indexPath.row]
        
        if let presentImage = UIImage(data: presentItem.image as! Data) {
           cell.backgroundImageView.image = presentImage
        }
        
        cell.nameLabel.text = presentItem.person
        cell.itemLabel.text = presentItem.presentName
        

        return cell
    }
    
    @IBAction func addPresent(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)

        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: { 
                self.createPresentItem(with: image)
            })
        }
        
        
    }

    
    
    func createPresentItem (with image:UIImage) {
        
        let presentItem = Present(context: managedObjextContext)
        presentItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        
        
        let inputAlert = UIAlertController(title: "New Present", message: "Enter a person and a present.", preferredStyle: .alert)
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Person"
        }
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Present"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let personTextField = inputAlert.textFields?.first
            let presentTextField = inputAlert.textFields?.last
            
            if personTextField?.text != "" && presentTextField?.text != "" {
                presentItem.person = personTextField?.text
                presentItem.presentName = presentTextField?.text
                
                do {
                    try self.managedObjextContext.save()
                    self.loadData()
                }catch {
                    print("Could not save data \(error.localizedDescription)")
                }
                
            }
            
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
        
        
        
        
    }
    
    
}
