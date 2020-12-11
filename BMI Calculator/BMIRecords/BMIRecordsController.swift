//
//  BMIRecordsController.swift
//  BMI Calculator
//
//  Created by Masum Modi on 2020-12-11.
//  Copyright © 2020 Centennial College. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class BMIRecordsController: UIViewController {

    var arrRecord = Array<DocumentSnapshot>()
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsMultipleSelectionDuringEditing = false;
        
        loadFirestoreData()
    }
    
    func loadFirestoreData() {
        
        db.collection("BMIRecords").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                self.arrRecord.removeAll()
                self.arrRecord.append(contentsOf: querySnapshot!.documents)
                self.tableView.reloadData()
            }
        }
    }
}


// Table view data source controller
extension BMIRecordsController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRecord.count // Returns number of rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell //Find the cell and recycle it
        cell.parentContext = self
        cell.currentIndex = indexPath.row
        if let currentTask = self.arrRecord[indexPath.row].data(){
            cell.lblResult.text = "BMI Score: " + String(format: "%.2f", (currentTask["bmiScore"] as! NSNumber).floatValue)
            cell.lblMessage.text = currentTask["message"] as? String
            cell.txtWeight.text = String(format: "%d", (currentTask["weight"] as! NSNumber).intValue)
            if let timestamp = currentTask["date"] as? Timestamp{
                let date = timestamp.dateValue()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                let strDate = df.string(from: date)
                cell.lblDate.text = strDate
            }
            cell.record = self.arrRecord[indexPath.row]
        }
        return cell
    }
    
}

