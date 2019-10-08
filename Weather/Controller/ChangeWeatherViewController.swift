//
//  ChangeWeatherViewController.swift
//  Weather
//
//  Created by Osmani Perez on 9/8/19.
//  Copyright © 2019 Osmani Perez. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredCityName(city: String)
}

class ChangeWeatherViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?

    @IBOutlet weak var enterCityTextField: UITextField!
    
    @IBAction func getWeatherPressed(_ sender: UIButton) {
        let cityName = enterCityTextField.text!
        delegate?.userEnteredCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
