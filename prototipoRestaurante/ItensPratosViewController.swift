//
//  ItensPratosViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 01/03/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class ItensPratosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayItens : NSMutableArray = NSMutableArray()
    
    var objeto : NSArray = NSArray()
    
    @IBOutlet weak var pedir: UIButton!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var imagemSuperior: UIImageView!
    
    let compartilhado = UIApplication.sharedApplication().delegate as AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if compartilhado.boolPedir == false {
            pedir.setTitle("INFORMAÇÕES",  forState: UIControlState.Normal)
            
            objeto = self.compartilhado.arrayPratosSemana.objectAtIndex(compartilhado.indicePrato) as NSArray
            
            titulo?.text = objeto.objectAtIndex(0) as? String
            descricao?.text = objeto.objectAtIndex(1) as? String
            var icone : UIImage? = UIImage(named: objeto.objectAtIndex(2) as String)
            imagemSuperior.image = icone
            
            
            let urlPath: String = "http://localhost:8888/restaurante/json/MysqlJsonItens.php?id=\(compartilhado.pratoSelecionado)"
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
                    
                    var item : String = resultado["descricao"] as String
                    var titulo : String = "\(item)"
                    var img : String = resultado["descricao_ilustracao"] as String
                    
                    var temparray : NSArray = NSArray(objects: titulo, img)
                    self.arrayItens.addObject(temparray)
                    
                }
            }
        } else {

        objeto = self.compartilhado.arrayPratos.objectAtIndex(compartilhado.indicePrato) as NSArray
        
        titulo?.text = objeto.objectAtIndex(0) as? String
        descricao?.text = objeto.objectAtIndex(1) as? String
        var icone : UIImage? = UIImage(named: objeto.objectAtIndex(2) as String)
        imagemSuperior.image = icone
        
        
        let urlPath: String = "http://localhost:8888//restaurante/json/MysqlJsonItens.php?id=\(compartilhado.pratoSelecionado)"
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
                
                var item : String = resultado["descricao"] as String
                var titulo : String = "\(item)"
                var img : String = resultado["descricao_ilustracao"] as String
                
                var temparray : NSArray = NSArray(objects: titulo, img)
                self.arrayItens.addObject(temparray)
                
                }
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItens.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var id : String = "itens"
        
        var celula : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.arrayItens.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        
        var imagem : String = objeto.objectAtIndex(1) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
    }
    
    
    @IBAction func pedir(sender: AnyObject) {
        
        let title : String = String(objeto.objectAtIndex(0) as String)
        
        let mensagem : String = String(objeto.objectAtIndex(1) as String)
        
        var detalhes : UIAlertView = UIAlertView()
        detalhes.delegate = self
        detalhes.title = title
        detalhes.message = mensagem
        detalhes.addButtonWithTitle("OK")
        if compartilhado.boolPedir == true && compartilhado.travarPedidos == false {
            
            detalhes.addButtonWithTitle("Pedir")
        
        }
        
        detalhes.show()
        
        
    }
    //Ao pedir
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 1:
            compartilhado.arrayPedidos.addObject(objeto)
            compartilhado.preçoTotal += objeto.objectAtIndex(4).floatValue
            break
        default:
            break
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sair() {
        
        compartilhado.arrayPratos.removeAllObjects()
        
        compartilhado.boolPedir = true
        
        var reload : PratosViewController = PratosViewController(nibName: "PratosViewController", bundle: nil)
        reload.viewDidLoad()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }


}
