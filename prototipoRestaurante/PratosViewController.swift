//
//  FirstViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 14/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class PratosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var jsonPratos : NSMutableData = NSMutableData()
    
    var arrayPratos : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        return Int(UIInterfaceOrientationMask.All.rawValue)
        
    }    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!)
    {
        println("Falha na conexão: \(error.localizedDescription)")
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        self.jsonPratos = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        self.jsonPratos.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var jsonData : NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonPratos, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var i : Int = jsonData["numResultados"] as Int
        
        var resultados : NSArray = jsonData["resultados"] as NSArray
        
        if (i > 0) {
            
            for x in 0...i-1
                
            {

            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPratos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var id : String = "id"
        
        var celula : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.arrayPratos.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        celula?.detailTextLabel?.text = objeto.objectAtIndex(1) as? String
        
        var imagem : String = objeto.objectAtIndex(2) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
    }
    
    @IBAction func informacoes () {
        
        var dados : UIAlertView = UIAlertView()
        
        dados.title = " Sobre o APP "
        dados.message = "Restaurante: NOME \n Endereço: Rua tal, Número x \n Telefone (11) 12345-6789 \n\n\n Desenvolvido por: app.megamil.net \n Contato: Eduardo \n Telefone: (11) 96278-2329 "
        dados.addButtonWithTitle("Voltar")
        dados.show()
        
        
    }

}

