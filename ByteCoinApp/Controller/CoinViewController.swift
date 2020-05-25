//
//  ViewController.swift
//  ByteCoinApp
//
//  Created by Rollin Francois on 5/23/20.
//  Copyright © 2020 Francois Technology. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //         Set the ViewController class as the currencyLabel to the currencyPicker object.
        coinManager.delegate = self
        //         Set the ViewController class as the datasource to the currencyPicker object.
        currencyPicker.dataSource = self
        //         Set the ViewController class as the delegate for the currencyPicker object.
        currencyPicker.delegate = self
    }
    
}

//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        //Remember that we need to get hold of the main thread to update the UI, otherwise our app will crash if we
        //try to do this from a background thread (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDelegate / UIPickerViewDataSource

extension CoinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //      Get the number of items in the array
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        Print to console
        print(coinManager.currencyArray[row])
        
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
}

