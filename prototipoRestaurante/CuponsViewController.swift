//
//  CuponsViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 25/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class CuponsViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var zerarCupons: UIButton!
    @IBOutlet weak var addCupom: UIButton!
    var arrayCupons : NSMutableArray = NSMutableArray()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtCodigo.delegate = self
        zerarCupons.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func adicionarCupom() {
        
        var temparray : NSArray = NSArray(objects: txtCodigo.text)
        
        self.arrayCupons.addObject(temparray)
        
        tableView.reloadData()
        
    }
    
    @IBAction func minimizar (sender: AnyObject) {

        sender.resignFirstResponder()
        txtCodigo.resignFirstResponder()
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var id : String = "cupons"
        
        var celula = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.arrayCupons.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        
        return celula!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCupons.count
    }

    
}
