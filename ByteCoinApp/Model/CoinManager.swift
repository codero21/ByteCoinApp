//
//  CoinManager.swift
//  ByteCoinApp
//
//  Created by Rollin Francois on 5/23/20.
//  Copyright © 2020 Francois Technology. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    //Create the method stubs wihtout implementation in the protocol.
    //It's usually a good idea to also pass along a reference to the current class.
    //e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    //Check the Clima module for more info on this.
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}


struct CoinManager {
    //Create an optional delegate that will have to implement the delegate methods.
    //Which we can notify when we have updated the price.
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B4F2171B-9BE3-48B6-BA41-4A0A15EFCF51"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        //        Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //        Use optional Binding to unwrap the URL that's ceated from the urlString
        if let url = URL(string: urlString) {
            //            Print to console
            //print(urlString)
            
            //            Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //            Create a new data task for the URLSession
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                //                Format the data we got back as a string to be able to print it.
                //                let dataAsString = String(data: data!, encoding: .utf8)
                //                print(dataAsString!)
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        
                        //Round the price down to 2 decimal places.
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        //Call the delegate method in the delegate (ViewController) and
                        //pass along the necessary data.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            //            Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        //        Create JSONDecoder
        let decoder = JSONDecoder()
        
        do {
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch  {
            //Catch and print any errors.
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
        
    }
    
}
