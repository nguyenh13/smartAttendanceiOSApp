//
//  studentListViewController.swift
//  SmartAttendance
//
//  Created by Hung Nguyen on 10/30/18.
//  Copyright © 2018 Hung Nguyen. All rights reserved.
//

import UIKit
import CoreData

class StudentListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var studentList = [StudentData]()
    var student: StudentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fetch data in studentList in order show display data everytime the view is loaded.
        let fetchRequest: NSFetchRequest<StudentData> = StudentData.fetchRequest()
        do {
            let studentList = try PersistenceService.context.fetch(fetchRequest)
            self.studentList = studentList
            self.tableView.reloadData()
        } catch {}
        
    }
    
    
    //Add button to add student cell after choosing a single class
    @IBAction func addStudentTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Student", message: nil, preferredStyle: .alert)
        alert.addTextField { (studentListTF) in
            studentListTF.placeholder = "Enter name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let student = alert.textFields?.first?.text else { return }
            print(student)
            let person = StudentData(context: PersistenceService.context)
            person.student_name = student
            PersistenceService.saveContext()
            self.studentList.append(person)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert,animated: true)
    }
    
    //Datasource Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stuCell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        stuCell.textLabel?.text = studentList[indexPath.row].student_name
        
        return stuCell
    }
    
    //Editing function, allows to swipe cell to delete, swipe all the way left to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let person = studentList[indexPath.row]
        studentList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        PersistenceService.context.delete(person)
        PersistenceService.saveContext()

        let fetchRequest: NSFetchRequest<StudentData> = StudentData.fetchRequest()
        do {
            let studentList = try PersistenceService.context.fetch(fetchRequest)
            self.studentList = studentList
        } catch {}
        self.tableView.reloadData()
        print("Delete \(person)")
    }


}
