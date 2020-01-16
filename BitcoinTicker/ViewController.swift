//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let currencyArray = ["AUD - Australian Dollar", "BRL - Brazilian Real","CAD - Canadian Dollar","CNY - Chinese Yuan","EUR - Euro","GBP - Pound Sterling","HKD - Hong Kong","IDR - Indonesian Rupiah","ILS - Iserali New Shekel","INR - Indian Rupee","JPY - Japanese Yen","MXN - Mexican Peso","NOK - Norwegian Krone","NZD - New Zealand Dollar","PLN - Poland Zloty","RON - Romanian Leu","RUB - Russian Ruble","SEK - Swedish Krona","SGD - Singapore Dollar","USD - US Dollar","ZAR - South African Rand"]
    
    let cryptoArray = ["BTC - Bitcoin","BCH - Bitcoin Cash", "ETH - Ethereum", "XRP - Ripple", "LTC - Litecoin", "XMR - Monero", "ZEC - Zcash" ]
    var finalURL = ""
//    var cryptoURL = ""
    var bitcoinPrice : String = ""
    var converterLabelValue : String = ""
    
    //Variables for state
    var cryptoValue : String = "BTC"
    var currencyValue : String = "USD"
    
    var image : String = "BTC"
    @IBOutlet weak var imageCrypto: UIImageView!
    
    
    @IBOutlet weak var MainView: UIView!
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    @IBOutlet weak var currencyConverterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        cryptoPicker.delegate = self
        cryptoPicker.dataSource = self
        
//        currencyPicker.frame.size.width = (self.view.frame.width / 2)
//        cryptoPicker.frame.size.width = (self.view.frame.width / 2)
        
        
        
        getBitcoinData(url: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD")
       
    }

    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // returns how many items(here it is row) would be there in the picker
        if pickerView == currencyPicker {
            return currencyArray.count
        }
        return cryptoArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //this returns the number of components in the pickerView
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //this basically sets the title of each picker item to the elements in an array.
        // therefor currencyArray[row] means for each item (here is written as a "row") return the value of array
        if pickerView == currencyPicker {
            return currencyArray[row]
        }
        return cryptoArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cryptoPicker {
            
            cryptoValue = String(cryptoArray[row].prefix(3))
            
            switch cryptoValue {
                
            case "ETH":
                MainView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                
            case "BCH":
                MainView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            
            case "XRP":
                MainView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            
            case "LTC":
                MainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
            case "XMR":
                MainView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                
            case "ZEC":
                MainView.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                
            default:
                MainView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
            
            if cryptoValue == "ETH" {
               
            }
            
            // Final Array
            finalURL = "\(baseURL)"+"\(cryptoValue)" + "\(currencyValue)"

            
        } else if pickerView == currencyPicker {
            currencyValue = String(currencyArray[row].prefix(3))
            finalURL = "\(baseURL)"+"\(cryptoValue)" + "\(currencyValue)"
        }
        
       getBitcoinData(url: finalURL)
    }
    
    
    //PICKER VIEW FOR CRYPTO
    
    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    
//    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the weather data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
//
//    
//
    func updateUIWithBitcoinData(data: String) {
        bitcoinPriceLabel.text = data
        currencyConverterLabel.text = currencyValue
        imageCrypto.image = UIImage(named: cryptoValue)
        
    }
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinData(json : JSON!) {
        
        if var tempResult = json["ask"].double {
            tempResult = Double(round(100*tempResult)/100)
            bitcoinPrice = String(tempResult)
            converterLabelValue = json["display_symbol"].stringValue
            
        }
        updateUIWithBitcoinData(data: bitcoinPrice)
    }
//




}

