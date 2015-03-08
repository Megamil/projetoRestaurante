//
//  SecondViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 14/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class LanchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    var arrayLanches : NSMutableArray = NSMutableArray()
    
    var myObject : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPath: String = "http://localhost:8888/MysqlJsonLanches.php"
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
                
                var lanche : String = resultado["nome_lanche"] as String
                var preço : Float = NSString(string: resultado["preco_lanche"] as String).floatValue

                var acompanha : String = ""
                var quantidade : Int = 0
                var medida : String =  ""
                
                if resultado["bebida"] as NSString != ""{
                    
                    acompanha = resultado["bebida"] as String
                    quantidade = NSString(string: resultado["quantidade"] as String).integerValue
                    medida = resultado["medida"] as String
                    
                }
                
                //Formatando a string preço.
                var preçoFormatado : String = NSString(format: "%.2f", preço) as String
                
                preçoFormatado = preçoFormatado.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                var titulo : String = "\(lanche) - R$ \(preçoFormatado)"
                
                var descricao : String = ""
                
                if quantidade != 0 {
                    descricao = "Acompanha : \(acompanha) \(quantidade) \(medida)"
                }
                
                var img : String = resultado["descricao_ilustracao"] as String
                var temparray : NSArray = NSArray(objects: titulo, descricao, img)
                self.arrayLanches.addObject(temparray)
                
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayLanches.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var id : String = "lanches"
        
        var celula : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.arrayLanches.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        celula?.detailTextLabel?.text = objeto.objectAtIndex(1) as? String
        
        var imagem : String = objeto.objectAtIndex(2) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        myObject = self.arrayLanches.objectAtIndex(indexPath.row) as NSArray
        
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
        
        var numero = Int(arc4random_uniform(UInt32(arrayLanches.count)))
        sorteio(numero)
        
    }
    
    
    func sorteio(aleatorio: Int)
    {
        myObject = self.arrayLanches.objectAtIndex(aleatorio) as NSArray
        
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

