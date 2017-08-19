//
//  SettingsViewController.swift
//  Tip
//
//  Created by V on 2/18/17.
//  Copyright © 2017 vova. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var defaultPercentage: UISegmentedControl!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    weak var delegate:TipCalcViewController!
    
    var pickerDataSource:[(name: String, locale: Locale)] = []
    var defaultSegmentIndex = 0
    var currentPickerString:String?

    func containsTuple(arr: [(String, Locale)], tup:(String, Locale)) -> Bool {
        let (c1, _) = tup
        for (v1, _) in arr {
            if v1 == c1 {
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let currentLocale = ((delegate.appLocale != nil) ? delegate.appLocale : delegate.systemLocale)!
        let currentIdentifyer =  currentLocale.identifier
        for (_, item) in Locale.availableIdentifiers.enumerated() {
            let locale = NSLocale(localeIdentifier: item)
            if let currencyCode =  locale.object(forKey: NSLocale.Key.currencyCode), let currencySymbol =  locale.object(forKey: NSLocale.Key.currencySymbol),
                let countryCode =  locale.object(forKey: NSLocale.Key.countryCode) {
                if (currencySymbol as! String) != (currencyCode as! String) {
                    let countryName = Locale.current.localizedString(forRegionCode: countryCode as! String)
                    let str = countryName! + " " + (currencyCode as! String) + "/" + (currencySymbol as! String)
                    let tuple = (name:str, locale:locale as Locale)
                    if !containsTuple(arr: pickerDataSource, tup: tuple) { //remove duplicates
                        pickerDataSource.append(tuple)
                    }
                    if currentIdentifyer == item {
                        currentPickerString = str
                    }
                }
            }
        }
        //pickerDataSource = Array(Set(pickerDataSource))
        pickerDataSource = pickerDataSource.sorted { $0.0 < $1.0 }
        regionPicker.delegate = self
        regionPicker.dataSource = self
    }

    //func currentLocaleDidChange(notification: Notification) {
        //delegate.recalcLocaleAndTip() will be called in view willappear
    //}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.currentLocaleDidChange), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
        defaultPercentage.selectedSegmentIndex = defaultSegmentIndex
        for (index, element) in pickerDataSource.enumerated() {
            if currentPickerString == element.name {
                regionPicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self)
        //animation
        delegate.view.alpha = 0
        self.view.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.delegate.view.alpha = 1
            self.view.alpha = 0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.appLocale = pickerDataSource[row].locale
        delegate.billField.keyboardType = .decimalPad
        UserDefaults.standard.set(self.delegate.appLocale?.identifier, forKey: "DefaultAppLocale")
        UserDefaults.standard.synchronize()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: pickerDataSource[row].name)
    }
    
    @IBAction func changeDefaultPercentage(_ sender: UISegmentedControl) {
        defaultSegmentIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(defaultSegmentIndex, forKey: "DefaultPercentage")
        UserDefaults.standard.synchronize()
        delegate.defaultSegmentIndex = defaultSegmentIndex
        delegate.tipControl.selectedSegmentIndex = defaultSegmentIndex
    }
    
//        DispatchQueue.global(qos: .userInitiated).async {
//            DispatchQueue.main.async {
//            }
//        }
}
