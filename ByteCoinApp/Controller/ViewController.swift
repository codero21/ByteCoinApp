//
//  ViewController.swift
//  ByteCoinApp
//
//  Created by Rollin Francois on 5/23/20.
//  Copyright © 2020 Francois Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let coinManager = CoinManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//         Set the ViewController class as the datasource to the currencyPicker object.
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//      Get the number of items in the array
        return coinManager.currencyArray.count
    }
}

