//  Bitcoin Price Tracker
//  ViewController.swift
//  Henghui He

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySymbol = ""
    
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
       
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row]
        print (finalURL)
        getBitCoinPrice(url: finalURL)
        currencySymbol = symbolArray[row]
        
    }
    
//    //MARK: - Networking
//    /***************************************************************/
    func getBitCoinPrice(url: String) {
       
        Alamofire.request(url, method: .get).responseJSON
        {   response in
            
               if response.result.isSuccess {

                   print("Sucess! Got the price data")
                
                   let bitCoinPriceJSON : JSON = JSON(response.result.value!)
                        self.updateBitCoinPrice(json: bitCoinPriceJSON)
                    }
                
               else {
                  print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

        }
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    func updateBitCoinPrice(json : JSON) {
        
      if let bitCoinprice = json["ask"].double
        {
            bitcoinPriceLabel.text = String("\(currencySymbol) \(bitCoinprice)")
        }
        else{
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
}

