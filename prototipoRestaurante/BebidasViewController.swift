//  BebidasViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 22/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.


import UIKit

class BebidasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    var myObject : NSArray = NSArray()
    
    var arrayBebidas : NSMutableArray = NSMutableArray()
    
    var celula : UITableViewCell?
    
     override func viewDidLoad() {
        super.viewDidLoad()

        let urlPath: String = "\(compartilhado.endereço)MysqlJsonBebidas.php?\(compartilhado.key)"
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
                
                var preçoFormatado2 = preçoFormatado.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                var titulo : String = "\(bebida) - \(quantidade) \(medida) R$ \(preçoFormatado2)"
                var descrição : String = resultado["tipo_bebida"] as String
                var img : String = resultado["descricao_ilustracao"] as String
                var id : Int = NSString(string: resultado["id_bebida"] as String).integerValue
                var referencia : String = "bebida"
                var temparray : NSArray = NSArray(objects: titulo,descrição, img, id,preçoFormatado,referencia)
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
        
        var mensagem : String = String(myObject.objectAtIndex(1) as String)
        
        var id : Int = myObject.objectAtIndex(3) as Int
        
        var dias = ""
        
//        let urlPath: String = "\(compartilhado.endereço)diasBebidas.php?id=\(id)&\(compartilhado.key)"
//        var url: NSURL = NSURL(string: urlPath)!
//        var request1: NSURLRequest = NSURLRequest(URL: url)
//        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
//        var error: NSErrorPointer = nil
//        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
//        var err: NSError
//        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
//        
//        var resultados : NSArray = jsonResult["resultados"] as NSArray
//        
//        var i : Int = jsonResult["numResultados"] as Int
//        
//        if (i > 0) {
//            
//            compartilhado.boolPedir = false
//            
//            for x in 0...i-1
//                
//            {
//                var resultado : NSDictionary = resultados[x] as NSDictionary
//                
//                var dia : String = resultado["dia_semana"] as String
//                var id : Int = NSString(string: resultado["id_semana"] as String).integerValue
//                
//                dias = "\(dias) \n \(dia)"
//                
//                if( compartilhado.boolPedir == false) {
//                    
//                    if(id == 10) {
//                        compartilhado.boolPedir = true
//                        
//                    } else if (compartilhado.hoje() == 1 || compartilhado.hoje() == 7) {
//                        
//                        if(id == compartilhado.hoje() || id == 9) {
//                            compartilhado.boolPedir = true
//                        }
//                        
//                        
//                    } else {
//                        
//                        if(id == compartilhado.hoje() || id == 8) {
//                            compartilhado.boolPedir = true
//                        }
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
//        
//        mensagem = "\(mensagem) \n Dias disponíveis: \(dias)"

        
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
        
        var numero = Int(arc4random_uniform(UInt32(arrayBebidas.count)))
        sorteio(numero)
        
    }
    
    
    func sorteio(aleatorio: Int)
    {
        myObject = self.arrayBebidas.objectAtIndex(aleatorio) as NSArray
        
        let title : String = String(myObject.objectAtIndex(0) as String)
        
        var mensagem : String = String(myObject.objectAtIndex(1) as String)
        
        var id : Int = myObject.objectAtIndex(3) as Int
        
        var dias = ""
        
//        let urlPath: String = "\(compartilhado.endereço)diasBebidas.php?id=\(id)&\(compartilhado.key)"
//        var url: NSURL = NSURL(string: urlPath)!
//        var request1: NSURLRequest = NSURLRequest(URL: url)
//        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
//        var error: NSErrorPointer = nil
//        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
//        var err: NSError
//        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
//        
//        var resultados : NSArray = jsonResult["resultados"] as NSArray
//        
//        var i : Int = jsonResult["numResultados"] as Int
//        
//        if (i > 0) {
//            
//            compartilhado.boolPedir = false
//            
//            for x in 0...i-1
//                
//            {
//                var resultado : NSDictionary = resultados[x] as NSDictionary
//                
//                var dia : String = resultado["dia_semana"] as String
//                var id_ : Int = NSString(string: resultado["id_semana"] as String).integerValue
//                
//                dias = "\(dias) \n \(dia)"
//                
//                if(compartilhado.boolPedir == false) {
//                    
//                    if(id_ == 10) {
//                        compartilhado.boolPedir = true
//                        
//                    } else if (compartilhado.hoje() == 1 || compartilhado.hoje() == 7) {
//                        
//                        if(id_ == compartilhado.hoje() || id_ == 9) {
//                            compartilhado.boolPedir = true
//                        }
//                        
//                        
//                    } else {
//                        
//                        if(id_ == compartilhado.hoje() || id_ == 8) {
//                            compartilhado.boolPedir = true
//                        }
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
//        
//        
//        if (compartilhado.boolPedir == false) {
//            
//            self.gerarNumero()
//            
//        } else {
//            
//        mensagem = "\(mensagem) \n Dias disponíveis: \(dias)"
        
        
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
//    }

}
