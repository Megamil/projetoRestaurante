//  SecondViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 14/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.


import UIKit

class LanchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    var arrayLanches : NSMutableArray = NSMutableArray()
    
    var myObject : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPath: String = "\(compartilhado.endereço)MysqlJsonLanches.php"
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
                
                var preçoFormatado2 = preçoFormatado.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                var titulo : String = "\(lanche) - R$ \(preçoFormatado2)"
                
                var descricao : String = ""
                
                if quantidade != 0 {
                    descricao = "Acompanha : \(acompanha) \(quantidade) \(medida)"
                }
                
                var img : String = resultado["descricao_ilustracao"] as String
                var id : Int = NSString(string: resultado["id_lanche"] as String).integerValue
                var referencia : String = "lanche"
                var temparray : NSArray = NSArray(objects: titulo, descricao, img, id, preçoFormatado,referencia)
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
    
        var mensagem : String = String(myObject.objectAtIndex(1) as String)
        
        var id : Int = myObject.objectAtIndex(3) as Int
        
        var dias = ""
        
        let urlPath: String = "\(compartilhado.endereço)diasLanches.php?id=\(id)"
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
            
            compartilhado.boolPedir = false
            
            for x in 0...i-1
                
            {
                var resultado : NSDictionary = resultados[x] as NSDictionary
                
                var dia : String = resultado["dia_semana"] as String
                var id : Int = NSString(string: resultado["id_semana"] as String).integerValue
                
                dias = "\(dias) \n \(dia)"
                
                if( compartilhado.boolPedir == false) {
                
                if(id == 10) {
                    compartilhado.boolPedir = true
                    
                    } else if (compartilhado.hoje() == 1 || compartilhado.hoje() == 7) {
                    
                    if(id == compartilhado.hoje() || id == 9) {
                        compartilhado.boolPedir = true
                    }
                    
                } else {
                    
                    if(id == compartilhado.hoje() || id == 8) {
                        compartilhado.boolPedir = true
                    }
                    
                }
            
            }
                    
        }
        
    }
        
        mensagem = "\(mensagem) \n Dias disponíveis: \(dias)"
        
        var detalhes : UIAlertView = UIAlertView()
        detalhes.delegate = self
        detalhes.title = title
        detalhes.message = mensagem
        
        if compartilhado.travarPedidos == false && compartilhado.boolPedir == true {
         
            detalhes.addButtonWithTitle("Cancelar")
            detalhes.addButtonWithTitle("Pedir")
            
        } else {
            
            detalhes.addButtonWithTitle("OK")
            
        }
        
        detalhes.show()

    }
        //Ao pedir
        func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
            
            switch buttonIndex{
                
            case 1:
                compartilhado.arrayPedidos.addObject(myObject)
            compartilhado.preçoTotal += myObject.objectAtIndex(4).floatValue
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
        
        var mensagem : String = String(myObject.objectAtIndex(1) as String)
        
        var id : Int = myObject.objectAtIndex(3) as Int
        
        var dias = ""
        
        let urlPath: String = "\(compartilhado.endereço)diasLanches.php?id=\(id)"
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
            
            compartilhado.boolPedir = false
            
            for x in 0...i-1
                
            {
                var resultado : NSDictionary = resultados[x] as NSDictionary
                
                var dia : String = resultado["dia_semana"] as String
                var id : Int = NSString(string: resultado["id_semana"] as String).integerValue
                
                dias = "\(dias) \n \(dia)"
                
                if( compartilhado.boolPedir == false) {
                    
                    if(id == 10) {
                        compartilhado.boolPedir = true
                        
                    } else if (compartilhado.hoje() == 1 || compartilhado.hoje() == 7) {
                        
                        if(id == compartilhado.hoje() || id == 9) {
                            compartilhado.boolPedir = true
                        }
                        
                        
                    } else {
                        
                        if(id == compartilhado.hoje() || id == 8) {
                            compartilhado.boolPedir = true
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        if (compartilhado.boolPedir == false) {
         
            self.gerarNumero()
            
        } else {
        
        mensagem = "\(mensagem) \n Dias disponíveis: \(dias)"
        
        var detalhes : UIAlertView = UIAlertView()
        detalhes.delegate = self
        detalhes.title = title
        detalhes.message = mensagem
            
        if compartilhado.travarPedidos == false && compartilhado.boolPedir == true {
            
            detalhes.addButtonWithTitle("Cancelar")
            detalhes.addButtonWithTitle("Pedir")
            
        } else {
            
            detalhes.addButtonWithTitle("OK")
            
        }
        
        detalhes.show()
        
        }
        
    }

    
    

}

