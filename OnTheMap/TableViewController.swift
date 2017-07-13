//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Laurie Wheeler on 3/12/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    var appDelegate: AppDelegate!
    
    var student: Student?
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
  
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {    
        super.viewWillAppear(animated)
        print("TableViewController viewWillAppear")
        
        
        //Students.allStudents.removeAll()

 
           DBClient.sharedInstance().taskForGETMethod { (results, error) in
            print("taskForGetMethod")
            print("results from taskForGETMethod", results as Any)
            print("error from taskForGETMethod", error as Any)
            
            
            if (error != nil) {
                
                print(error?.localizedDescription as Any)
                let errorMsg  = error?.localizedDescription
        
                OperationQueue.main.addOperation {
                let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                uiAlertController.addAction(defaultAction)
                self.present(uiAlertController, animated: true, completion: nil)
            }
            }
            
            self.performUIUpdatesOnMain { () -> Void in
                self.performUIUpdatesOnMain({ () -> Void in
                    print("performUIUpdatesOnMain")
                    self.tableView.reloadData()
                })
                self.tableView.reloadData()
                
            }
            
        }

    
        self.tableView.reloadData()
        
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        
        if Students.allStudents.count == 0 {
            return 1
        }
        
        else {
        
            return Students.allStudents.count
  
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as UITableViewCell!

        
        let individual = Students.allStudents[indexPath.row]
        
        performUIUpdatesOnMain { () -> Void in
            
            cell?.textLabel?.text = individual.firstName! + " " + individual.lastName! 
           
        }
        
        return cell!
            }

  
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            
            // Closure use of non-escaping parameter 'updates'may allow it to escape
            //parameter 'updates' is implicitly non-escaping

            updates()
        }
}
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAtIndexPath")
        
        let selectedStudentURL = Students.allStudents[indexPath.row].url
        
        
        let url = URL(string: (selectedStudentURL!))!
        
        UIApplication.shared.openURL(url)
        
        
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        
        
        //Students.allStudents.removeAll()

        DBClient.sharedInstance().taskForGETMethod { (results, error) in
            print("taskForGetMethod")
            print("results from taskForGETMethod", results as Any)
            print("error from taskForGETMethod", error as Any)
            
            
            if (error != nil) {
                
                print(error?.localizedDescription as Any)
                let errorMsg  = error?.localizedDescription
                
                OperationQueue.main.addOperation {
                    let uiAlertController = UIAlertController(title: "download error", message: errorMsg, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    uiAlertController.addAction(defaultAction)
                    self.present(uiAlertController, animated: true, completion: nil)
                }
            }
            Students.allStudents.removeAll()
            print("allStudents count", Students.allStudents.count)
            let results = results?.object(forKey: "results") as! NSArray
            
            for student in Student.studentFromResults(results as! [[String : AnyObject]]) {
                    
                    Students.allStudents.append(student)
                }
           
            
            self.performUIUpdatesOnMain { () -> Void in
        self.tableView.reloadData()
            }
        }
    }
}

