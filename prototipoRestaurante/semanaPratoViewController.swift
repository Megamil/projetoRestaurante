//
//  semanaPratoViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 08/03/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class semanaPratoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titulo: UILabel!
    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    var resultados : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titulo.text = compartilhado.tituloDia
        
        let urlPath: String = "\(compartilhado.endereço)MysqlJsonPratos.php?id=\(compartilhado.dia)"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        resultados = jsonResult["resultados"] as NSArray
        
        var i : Int = jsonResult["numResultados"] as Int
        
        if (i > 0) {
            
            for x in 0...i-1
                
            {
                var resultado : NSDictionary = resultados[x] as NSDictionary
                
                var prato : String = resultado["nome_prato"] as String
                var preço : Float = NSString(string: resultado["preco_prato"] as String).floatValue
                
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
                
                var titulo : String = "\(prato) - R$ \(preçoFormatado)"
                var img : String = resultado["descricao_ilustracao"] as String
                
                var descricao : String = ""
                
                if quantidade != 0 {
                    descricao = "Acompanha : \(acompanha) \(quantidade) \(medida)"
                }
                
                var temparray : NSArray = NSArray(objects: titulo, descricao, img)
                self.compartilhado.arrayPratosSemana.addObject(temparray)
                
            }
        }

        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compartilhado.arrayPratosSemana.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var id : String = "semana"
        
        var celula : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.compartilhado.arrayPratosSemana.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        celula?.detailTextLabel?.text = objeto.objectAtIndex(1) as? String
        
        var imagem : String = objeto.objectAtIndex(2) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var resultado : NSDictionary = resultados[indexPath.row] as NSDictionary
        
        compartilhado.indicePrato = indexPath.row
        
        compartilhado.pratoSelecionado = NSString(string: resultado["id_prato"] as String).integerValue
        if compartilhado.dia != compartilhado.hoje() {
         
            compartilhado.boolPedir = false
            
        }
        
        var itens : ItensPratosViewController = ItensPratosViewController(nibName: "ItensPratosViewController", bundle: nil)
        
        self.presentViewController(itens, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sair() {
        compartilhado.arrayPratosSemana.removeAllObjects()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
