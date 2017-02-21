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
    
    weak var delegate:ViewController! = nil
    
    var pickerDataSoruce:NSMutableArray? = NSMutableArray()
    var defaultIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let locale = Locale.current commonISOCurrencyCodes isoCurrencyCodes
        for (index, item) in Locale.isoRegionCodes.enumerated() {
            let unwrappedItem = item
            pickerDataSoruce?.add(unwrappedItem)
            print("Found \(item) at position \(index)")
        }
        regionPicker.delegate = self
        regionPicker.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultPercentage.selectedSegmentIndex = defaultIndex
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSoruce!.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: pickerDataSoruce?[row])
    }
    
    @IBAction func changeDefaultPercentage(_ sender: UISegmentedControl) {
        defaultIndex = sender.selectedSegmentIndex
        let defaults = UserDefaults.standard
        defaults.set(defaultIndex, forKey: "defaultPercentage")
        defaults.synchronize()
        delegate.tipControl.selectedSegmentIndex = defaultIndex
    }
}
