//
//  ChangeWeatherViewController.swift
//  WeatherApp
//
//  Created by Os! on 02/01/1440 AH.
//  Copyright © 1440 Os!. All rights reserved.
//

import UIKit
import SwiftyButton

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city : String)
}

class ChangeWeatherViewController: UIViewController {
    
   

    @IBOutlet weak var changeCityButton: PressableButton!
    
    @IBOutlet weak var enterCityTextField: UITextField!
    
    var delegate : ChangeCityDelegate?
    var enteredCityName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        changeCityButton.colors = .init(button: .gray, shadow: .darkGray)
        changeCityButton.disabledColors = .init(button: .gray, shadow: .darkGray)
        changeCityButton.shadowHeight = 10
        changeCityButton.cornerRadius = 8
        changeCityButton.depth = 0.5 // In percentage of shadowHeight
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeCityMethod(_ sender: PressableButton) {
        
        
        //1 Get the city name the user entered in the text field
        enteredCityName = String(enterCityTextField.text!)
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: enteredCityName)
        
         //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backToWeatherView(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
