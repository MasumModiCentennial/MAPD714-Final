//
//  Helper.swift
//  BMI Calculator
//
//  Created by Masum Modi on 2020-12-11.
//  Copyright © 2020 Centennial College. All rights reserved.
//


import Foundation
import UIKit


//MARK:- GCD
func getMainQueue(completion: @escaping (() -> Void)) {
    DispatchQueue.main.async {
        completion()
    }
}
func getDelayMainQueue(delay: Double, completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        completion()
    }
}
func getBackgroundQueue(qos: DispatchQoS.QoSClass = DispatchQoS.QoSClass.background, completion: @escaping (() -> Void)){
    DispatchQueue.global(qos: qos).async {
        completion()
    }
}

//MARK:- Set/Get/RemoceValueFromPreference
func setValueInPreference(forKey: String, value: Any) {
    let userDefault = UserDefaults.standard
    userDefault.set(value, forKey: forKey)
    userDefault.synchronize()
}

func getValueFromPreference(forKey: String) -> Any? {
    let userDefault = UserDefaults.standard
    if let prefValue = userDefault.value(forKey: forKey) {
        return prefValue
    }
    return nil
}
