//
//  ViewController.swift
//  Tip
//
//  Created by V on 2/18/17.
//  Copyright © 2017 vova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    var defaultSegmentIndex = 0
    var systemLocale: Locale?
    var appLocale: Locale?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let localeIdentifier = UserDefaults.standard.string(forKey: "DefaultAppLocale") {
            appLocale = NSLocale(localeIdentifier: localeIdentifier) as Locale
        }
        defaultSegmentIndex = UserDefaults.standard.integer(forKey: "DefaultPercentage")
        tipControl.selectedSegmentIndex = defaultSegmentIndex
        let bill = UserDefaults.standard.double(forKey: "DefaultBill")
        if bill != 0.0 {
            billField.text = String(format: "%.2f", bill)
        }
        var motionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motionEffect.minimumRelativeValue = -30
        motionEffect.maximumRelativeValue = 30
        billField.addMotionEffect(motionEffect)
        tipLabel.addMotionEffect(motionEffect)
        totalLabel.addMotionEffect(motionEffect)
        tipControl.addMotionEffect(motionEffect)
        motionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        motionEffect.minimumRelativeValue = -30
        motionEffect.maximumRelativeValue = 30
        billField.addMotionEffect(motionEffect)
        tipLabel.addMotionEffect(motionEffect)
        totalLabel.addMotionEffect(motionEffect)
        tipControl.addMotionEffect(motionEffect)
        
        billField.delegate = self
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.currentLocaleDidChange), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }

//    func currentLocaleDidChange(notification: Notification) {
//        appLocale = nil
//        UserDefaults.standard.removeObject(forKey: "DefaultAppLocale")
//        UserDefaults.standard.synchronize()
//        recalcLocaleAndTip()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSettings"?:
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.defaultSegmentIndex = defaultSegmentIndex
            settingsViewController.delegate = self
            //animation
            settingsViewController.view.alpha = 0
            self.view.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                settingsViewController.view.alpha = 1
                self.view.alpha = 0
            })
        default:
            preconditionFailure("Unexpected seque identifier")
        }
    }

    func recalcLocaleAndTip() {
        if systemLocale != Locale.current {
            if appLocale != nil {
                appLocale = nil
                UserDefaults.standard.removeObject(forKey: "DefaultAppLocale")
                UserDefaults.standard.synchronize()
            }
        }
        systemLocale = Locale.current
        let systemCurrencyCode = systemLocale?.currencyCode
        let systemCurrencySymbol = systemLocale?.currencySymbol
        //try to find good(fancy)symbol
        if systemCurrencySymbol == systemCurrencyCode {
            for (_, item) in Locale.availableIdentifiers.enumerated() {
                let locale = NSLocale(localeIdentifier: item)
                if let currencyCode =  locale.object(forKey: NSLocale.Key.currencyCode), let currencySymbol =  locale.object(forKey: NSLocale.Key.currencySymbol) {
                    if (currencySymbol as! String) != (currencyCode as! String) && (currencyCode as! String) == systemCurrencyCode {
                        systemLocale = locale as Locale
                    }
                }
            }
        }
        let locale = (appLocale != nil) ? appLocale : systemLocale
        let text = billField.text
        billField.placeholder = locale?.currencySymbol
        billField.text = text
        calculateTip(AnyClass.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.currentLocaleDidChange), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
        recalcLocaleAndTip()
        billField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Optionally initialize the property to a desired starting value
        //NotificationCenter.default.removeObserver(self)
        //billField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        billField.becomeFirstResponder()
    }

    @IBAction func percentageChanged(_ sender: Any) {
        calculateTip(AnyClass.self)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipPercentages = [0.15, 0.20, 0.25]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip;
        tipLabel.text = formatCurrency(value: tip)
        if !((tipLabel.text?.isEmpty)!) {
                tipLabel.text = "Tip " + tipLabel.text!
        }
        totalLabel.text = formatCurrency(value: total)
        if !((totalLabel.text?.isEmpty)!) {
            totalLabel.text = "Total " + totalLabel.text!
        }
    }
    
    func formatCurrency(value: Double) -> String {
        if value == 0.0 {
            return ""
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2;
        let locale = (appLocale != nil) ? appLocale : systemLocale
        formatter.locale = locale
        let result = formatter.string(from: value as NSNumber);
        return result!;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let endIndex = textField.text!.endIndex;
        let length = textField.text!.lengthOfBytes(using: String.Encoding.utf8)
        let locale = (appLocale != nil) ? appLocale : systemLocale
        
        let dotsCount = textField.text!.components(separatedBy: (locale?.decimalSeparator!)!).count - 1
        if dotsCount > 0 && string == locale?.decimalSeparator! {
            return false
        }
        if string != "" && length >= 3 && String(textField.text![textField.text!.index(endIndex, offsetBy: -3)]) == locale?.decimalSeparator! { // no more then two digits after point
            return false
        }
        if textField.text! == "0" && length == 1 && string != locale?.decimalSeparator! && String(textField.text![textField.text!.index(endIndex, offsetBy: -1)]) != locale?.decimalSeparator! { // only one leading 0
            textField.text! = string
            return false
        }
        if length == 0 && string == locale?.decimalSeparator! { // add leading 0 if separator
            textField.text! = "0"
        }
        let bill = Double(billField.text! + string) ?? 0
        if bill > 1000000000 { //limit 1 billion
            return false
        }
        return true
    }
}

