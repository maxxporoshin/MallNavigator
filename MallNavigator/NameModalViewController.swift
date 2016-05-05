//
//  NameModalViewController.swift
//  MallNavigator
//
//  Created by Max  on 5/4/16.
//  Copyright © 2016 Max. All rights reserved.
//

import UIKit

class NameModalViewController : UIViewController, UITextFieldDelegate {
    
    var delegate: NameModalViewControllerDelegate!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: Actions
    @IBAction func done(sender: UIBarButtonItem) {
        delegate.sendName(nameTextField.text)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITextFieldDeleagte
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}

public protocol NameModalViewControllerDelegate {
    func sendName(name: String?)
}
