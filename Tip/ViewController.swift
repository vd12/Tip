//
//  ViewController.swift
//  Tip
//
//  Created by V on 2/18/17.
//  Copyright © 2017 vova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    var defaultIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        defaultIndex = defaults.integer(forKey: "defaultPercentage")
        tipControl.selectedSegmentIndex = defaultIndex
        let bill = defaults.double(forKey: "defaultBill")
        billField.text = String(format: "%.2f", bill)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSettings"?:
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.defaultIndex = defaultIndex
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateTip(AnyClass.self)
        billField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Optionally initialize the property to a desired starting value
        billField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func percentageChanged(_ sender: Any) {
        calculateTip(AnyClass.self)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipPercentages = [0.18, 0.20, 0.25]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip;
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

