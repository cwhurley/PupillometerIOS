//
//  HistoryTableViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 20/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//
// https://www.youtube.com/watch?v=MC4mDQ7UqEEimport 


import UIKit
import CoreData

class HistoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var PersonData:[Person] = []
    var removePerson = Person()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.fetchData()
        self.tableView.reloadData()    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // Declare number of sections in table
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Declare the number of rows in section by counting the number of people in PersonData
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.PersonData.count
    }

    // Declare what will be displayed in each row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let name = PersonData[indexPath.row]
        cell.textLabel?.text = "\(name.name!) - \(name.date!)"
        
        return cell
    }
    
    // Declare table heading
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RECORED HISTORY"
    }
    
    // Declare what happens when row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "showPersonData", sender: self)
    }
    
    // Override the segue to send selected data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPersonData")
        {
            
            let rowIndex = tableView.indexPathForSelectedRow?.row
            
            let destination = segue.destination as! PersonPageViewController
            destination.personData = PersonData[rowIndex!]
            
        }
        else
        {
            print("no transfer")
        }
    }
    
    // Fetch the data from PersonData
    func fetchData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do
        {
            PersonData = try context.fetch(Person.fetchRequest())
        }
        catch
        {
            print(error)
        }
    }
    
    // For deleting row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            
            //let index = PersonData[]
            print("Remove:",PersonData[indexPath.row])
            removePerson = PersonData[indexPath.row]
            PersonData.remove(at: indexPath.row)
            
            
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            deleteUser()
        }
        print(PersonData)
    }
    
    // Deleting the information from PersonData
    func deleteUser () {
        
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            context.delete(removePerson)
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    

}



