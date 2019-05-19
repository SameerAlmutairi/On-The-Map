//
//  TableViewController.swift
//  On The Map
//
//  Created by Sameer Almutairi on 17/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UIViewController {

    let tableCellID = "CustomCell"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.deleteSession { (data, error) in
            if data != nil {
                UserDefaults.standard.set("", forKey: "accountKey")
                self.dismiss(animated: true, completion: nil)
            }
            else {
                // add alert
                print("Logout Faild")
            }
        }
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        loadingAllStudentsLocations()
    }
    
    func loadingAllStudentsLocations() {
        ParseClient.getAllStudentLocation { (response, error) in
            if let resposen = response {
                Students.students = resposen
                self.tableView.reloadData()
            }
            else {
                print("Loading Faild")
            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID) as! CustomTableViewCell
        let student = (Students.students[indexPath.row])
        cell.nameLable.text = student.mapString
        cell.mediaLabel.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        tableView.deselectRow(at: indexPath, animated: true)
        if let url = Students.students[indexPath.row].mediaURL {
            let url = URL(string: url)
            if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
}
