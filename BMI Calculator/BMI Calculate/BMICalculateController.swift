//
//  BMICalculateController.swift
//  BMI Calculator
//
//  Created by Masum Modi on 2020-12-11.
//  Copyright © 2020 Centennial College. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class BMICalculateController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var segUnit: UISegmentedControl!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    var imperialUnit = false
    var selectedGender = "Male"
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtName.delegate = self
        self.txtAge.delegate = self
        
        self.txtWeight.delegate = self
        self.txtHeight.delegate = self
    
        self.txtName.text = getValueFromPreference(forKey: "name") as? String
        self.txtAge.text = getValueFromPreference(forKey: "age") as? String
    }
    
    
    
    @IBAction func segGenderValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedGender = "Male"
        }else{
            selectedGender = "Female"
        }
    }
    
    @IBAction func segUnitValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            imperialUnit = true
            txtWeight.placeholder = "Weight (lb)"
            txtHeight.placeholder = "Height (in)"
        }else{
            imperialUnit = false
            txtWeight.placeholder = "Weight (kg)"
            txtHeight.placeholder = "Height (mt)"
        }
        txtWeight.text = ""
        lblMessage.text = ""
        lblScore.text = ""
        txtHeight.text = ""
    }
    

    @IBAction func calculateBMI(_ sender: UIButton) {
        
        guard let strWeight = self.txtWeight.text,
            let strHeight = self.txtHeight.text,
            let weight = Float(strWeight),
            let height = Float(strHeight) else {
                return
        }
        
        var result:Float = 0
        
        if imperialUnit {
            result = (weight * 703) / (height*height)
        }else{
            result = (weight) / (height*height)
        }
        
        self.lblScore.text = "BMI Score: " + String(format: "%.2f",result)
        
        calculateMessage(result: result)
        
        
    }
    
    func calculateMessage(result:Float) {
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
        lblMessage.text = message
        
        addToFirestore(result: result,message: message)
    }
    
    
    func addToFirestore(result: Float, message: String) {
        var ref: DocumentReference? = nil
        ref = db.collection("BMIRecords").addDocument(data: [
            "weight": (txtWeight.text! as NSString).floatValue,
            "height": (txtHeight.text! as NSString).floatValue,
            "bmiScore": result,
            "message": message,
            "imperialUnit": imperialUnit,
            "date": Date()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}

//  // extension for textfield delegates
extension BMICalculateController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === self.txtName {
           setValueInPreference(forKey: "name", value: textField.text ?? "")
        } else if textField === self.txtAge {
           setValueInPreference(forKey: "age", value: textField.text ?? "")
        }
        setValueInPreference(forKey: "isMale", value: selectedGender)
    }
}
