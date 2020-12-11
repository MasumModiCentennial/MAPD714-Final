//
//  RecordCell.swift
//  BMI Calculator
//
//  Created by Masum Modi on 2020-12-11.
//  Copyright © 2020 Centennial College. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestore

class RecordCell: UITableViewCell {
    
    var record: DocumentSnapshot!
    let db = Firestore.firestore()

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtWeight: UITextField!
    
    var parentContext: BMIRecordsController!
    
    var currentIndex: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtWeight.delegate = self
    }

}


//  // extension for textfield delegates
extension RecordCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let strWeight = textField.text,
                let weight = Float(strWeight) else {
                return
        }
        
        var result:Float = 0
        let imperialUnit = record["imperialUnit"] as! Bool
        let height = record["height"] as! Float
               
        if imperialUnit {
            result = (weight * 703) / (height*height)
        } else {
            result = (weight) / (height*height)
        }
        
        self.lblResult.text = "BMI Score: " + String(format: "%.2f",result)

        calculateMessage(result: result, weight: weight)
    }
    
    func calculateMessage(result:Float, weight: Float) {
        var message:String = ""
        
        if result < 16 {
            message = "Severe Thinness"
        }else if result>16 && result<17 {
            message = "Moderate Thinness"
        }else if result>17 && result<18.5 {
            message = "Mild Thinness"
        }else if result>18.5 && result<25 {
            message = "Normal"
        }else if result>25 && result<35 {
            message = "Overweight"
        }else if result>30 && result<35 {
            message = "Obese Class I"
        }else if result>35 && result<40 {
            message = "Obese Class II"
        }else if result>40 {
            message = "Obese Class III"
        }else{
            message = "Something went wrong"
        }
        
        self.lblMessage.text = message
        
        let collection = Firestore.firestore().collection("BMIRecords")
          collection.document(record.documentID).updateData([
              "weight": result,
              "bmiScore": weight,
              "message": message,
                  ]) { err in
                      if let err = err {
                          print("Error updating document: \(err)")
                      } else {
                          print("Document successfully updated")
                      }
                }
    }
}
