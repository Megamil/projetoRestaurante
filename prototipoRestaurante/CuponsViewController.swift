//
//  CuponsViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 25/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class CuponsViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var zerarCupons: UIButton!
    @IBOutlet weak var addCupom: UIButton!
    var arrayCupons : NSMutableArray = NSMutableArray()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var premioDesc: UILabel!
    @IBOutlet weak var titulo: UILabel!
    
    var limiteCupons : Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(arrayCupons.count == limiteCupons) {
        
            txtCodigo.hidden = true
            addCupom.hidden = true
            zerarCupons.hidden = false
            
        } else {
            
             zerarCupons.hidden = true
            
        }
        
        var urlPath: String = "\(compartilhado.endereço)recompensa.php"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var resultados : NSArray = jsonResult["resultados"] as NSArray
        
        var resultado : NSDictionary = resultados[0] as NSDictionary
        
        var premio : String = resultado["premio"] as String
        
        premioDesc.text = "Acumule cupons para ganhar: \(premio)"
        
        self.txtCodigo.delegate = self
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func adicionarCupom() {
        
        var urlPath: String = "\(compartilhado.endereço)validarCupom.php?cupom=\(txtCodigo.text)"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var resultados : NSArray = jsonResult["resultados"] as NSArray
        
        var resultado : NSDictionary = resultados[0] as NSDictionary
        
        var premio : String = resultado["resultado"] as String
        
        if(premio == "OK") {
        
        var temparray : NSArray = NSArray(objects: txtCodigo.text)
        
        self.arrayCupons.addObject(temparray)
        
        txtCodigo.text = ""
        
        tableView.reloadData()
            
            //Solicita o número da recompensa.
            if(arrayCupons.count == limiteCupons) {
            
                titulo.text = "Resgate com o código: S0001"
            
            }
            
        } else {
            
            var validar : UIAlertView = UIAlertView()
            validar.title = "Desculpe."
            validar.message = "Cupom inválido ou já registrado." as String
            validar.addButtonWithTitle("OK")
            validar.show()
            
        }
            
    }
    
    @IBAction func minimizar (sender: AnyObject) {

        sender.resignFirstResponder()
        txtCodigo.resignFirstResponder()
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(arrayCupons.count == limiteCupons) {
            
            txtCodigo.hidden = true
            addCupom.hidden = true
            zerarCupons.hidden = false
            
        } else {
            
            zerarCupons.hidden = true
            
        }

        
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
