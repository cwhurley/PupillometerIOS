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
    
@IBOutlet weak var tableView: UITableView!
    
    var PersonData:[Person] = []
    var removePerson = Person()
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.PersonData.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let name = PersonData[indexPath.row]
        cell.textLabel?.text = "\(name.name!) - \(name.date!)"
        
        
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RECORED HISTORY"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "showPersonData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPersonData")
        {
            
            //let sectionIndex = tableView.indexPathForSelectedRow?.section
            let rowIndex = tableView.indexPathForSelectedRow?.row
            
            let destination = segue.destination as! PersonPageViewController
            destination.personData = PersonData[rowIndex!]
            
        }
        else {print("no transfer")}
    }
    
    func fetchData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            PersonData = try context.fetch(Person.fetchRequest())
        }
        catch{
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
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
    
    

    
    func deleteUser () {
        
        let context = getContext()
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            //remove = removePerson
            context.delete(removePerson)
            
//            //go get the results
//            let PersonData = try getContext().fetch(fetchRequest)
//            
//            //You need to convert to NSManagedObject to use 'for' loops
//            for Person in PersonData as [NSManagedObject] {
//                //get the Key Value pairs (although there may be a better way to do that...
//                context.delete(removePerson)
//            }
            
            //context.delete(Person.)
            
            //save the context
            
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



