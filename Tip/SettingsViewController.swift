//
//  SettingsViewController.swift
//  Tip
//
//  Created by V on 2/18/17.
//  Copyright © 2017 vova. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var defaultPercentage: UISegmentedControl!
    weak var delegate:ViewController! = nil
    var defaultIndex = 0
    var changed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultPercentage.selectedSegmentIndex = defaultIndex
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if changed {
            delegate.tipControl.selectedSegmentIndex = defaultIndex
        }
        
        // Optionally initialize the property to a desired starting value
        delegate.view.alpha = 0
        self.view.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            // This causes first view to fade in and second view to fade out
            self.delegate.view.alpha = 1
            self.view.alpha = 0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func changeDefaultPercentage(_ sender: UISegmentedControl) {
        defaultIndex = sender.selectedSegmentIndex
        let defaults = UserDefaults.standard
        defaults.set(defaultIndex, forKey: "defaultPercentage")
        defaults.synchronize()
        changed = true
    }
}
