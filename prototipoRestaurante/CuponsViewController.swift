//
//  CuponsViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 25/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class CuponsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtCodigo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtCodigo.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        let newLength = countElements(txtCodigo.text!) + countElements(string!) - range.length
        return newLength < 6 //Não permite minizar o teclado quando tem Lenght 5
        
    }
    
    @IBAction func textFieldReturn(sender: AnyObject) {
        
        sender.resignFirstResponder()
        
    }
    
    //Não funciona
    @IBAction func minimizarSair() {
        
        txtCodigo.resignFirstResponder()
        
    }
    
}
