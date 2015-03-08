//
//  BebidasViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 22/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class BebidasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    var myObject : NSArray = NSArray()
    
    var arrayBebidas : NSMutableArray = NSMutableArray()
    
    var celula : UITableViewCell?
    
     override func viewDidLoad() {
        super.viewDidLoad()

        let urlPath: String = "http://localhost:8888/MysqlJsonBebidas.php"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var resultados : NSArray = jsonResult["resultados"] as NSArray
        
        var i : Int = jsonResult["numResultados"] as Int
        
        if (i > 0) {
            
            for x in 0...i-1
                
            {
                var resultado : NSDictionary = resultados[x] as NSDictionary
                
                var bebida : String = resultado["bebida"] as String
                var preço : Float = NSString(string: resultado["preco_bebida"] as String).floatValue
                var quantidade : Int = NSString(string: resultado["quantidade"] as String).integerValue
                var medida : String = resultado["medida"] as String
                
                //Formatando a string preço.
                var preçoFormatado : String = NSString(format: "%.2f", preço) as String
                
                preçoFormatado = preçoFormatado.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                var titulo : String = "\(bebida) - \(quantidade) \(medida) R$ \(preçoFormatado)"
                var descrição : String = resultado["tipo_bebida"] as String
                var img : String = resultado["descricao_ilustracao"] as String
                var temparray : NSArray = NSArray(objects: titulo,descrição, img)
                self.arrayBebidas.addObject(temparray)
                
            }
        }


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayBebidas.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var id : String = "bebidas"
        
        celula = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.arrayBebidas.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        celula?.detailTextLabel?.text = objeto.objectAtIndex(1) as? String
        
        var imagem : String = objeto.objectAtIndex(2) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        myObject = self.arrayBebidas.objectAtIndex(indexPath.row) as NSArray
        
        let title : String = String(myObject.objectAtIndex(0) as String)
        
        let mensagem : String = String(myObject.objectAtIndex(1) as String)
        
        var detalhes : UIAlertView = UIAlertView()
        detalhes.delegate = self
        detalhes.title = title
        detalhes.message = mensagem
        detalhes.addButtonWithTitle("OK")
        detalhes.addButtonWithTitle("Pedir")
        detalhes.show()
        
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 1:
            compartilhado.arrayPedidos.addObject(myObject)
            break
        default:
            break
            
        }
    }
    

    @IBAction func gerarNumero() {
        
        var numero = Int(arc4random_uniform(UInt32(arrayBebidas.count)))
        sorteio(numero)
        
    }
    
    
    func sorteio(aleatorio: Int)
    {
        myObject = self.arrayBebidas.objectAtIndex(aleatorio) as NSArray
        
        let title : String = String(myObject.objectAtIndex(0) as String)
        
        let mensagem : String = String(myObject.objectAtIndex(1) as String)
        
        var detalhes : UIAlertView = UIAlertView()
        detalhes.delegate = self
        detalhes.title = title
        detalhes.message = mensagem
        detalhes.addButtonWithTitle("OK")
        detalhes.addButtonWithTitle("Pedir")
        detalhes.show()
        
    }
    


}
