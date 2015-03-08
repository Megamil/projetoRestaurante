//
//  FirstViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 14/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class PratosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    var resultados : NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let data = formatter.stringFromDate(today)
        let stringData = formatter.dateFromString(data)
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.WeekdayCalendarUnit, fromDate: stringData!)
        var weekDay = myComponents?.weekday
        
        
        let urlPath: String = "http://localhost:8888/MysqlJsonPratos.php?id=\(weekDay!.hashValue)"
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
                self.compartilhado.arrayPratos.addObject(temparray)
                
            }
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        return Int(UIInterfaceOrientationMask.All.rawValue)
        
    }    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compartilhado.arrayPratos.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var id : String = "id"
        
        var celula : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = self.compartilhado.arrayPratos.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        celula?.detailTextLabel?.text = objeto.objectAtIndex(1) as? String
        
        var imagem : String = objeto.objectAtIndex(2) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {

        let optionMenu = UIAlertController(title: nil, message: "Selecione um dia da Semana.", preferredStyle: .ActionSheet)
        
        let segunda = UIAlertAction(title: "Segunda-Feira", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 2
            self.compartilhado.tituloDia = "Segunda-Feira"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
            
        })
        let terça = UIAlertAction(title: "Terça-Feira", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 3
            self.compartilhado.tituloDia = "Terça-Feira"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
        })
        
        let quarta = UIAlertAction(title: "Quarta-Feira", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 4
            self.compartilhado.tituloDia = "Quarta-Feira"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
        })
        
        let quinta = UIAlertAction(title: "Quinta-Feira", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 5
            self.compartilhado.tituloDia = "Quinta-Feira"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
        })
        
        let sexta = UIAlertAction(title: "Sexta-Feira", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 6
            self.compartilhado.tituloDia = "Sexta-Feira"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
        })
        
        let sabado = UIAlertAction(title: "Sábado", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 7
            self.compartilhado.tituloDia =  "Sábado"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
        })
        
        let domingo = UIAlertAction(title: "Domingo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.compartilhado.dia = 1
            self.compartilhado.tituloDia = "Domingo"
            
            var itens : semanaPratoViewController = semanaPratoViewController(nibName: "semanaPratoViewController", bundle: nil)
            
            self.presentViewController(itens, animated: true, completion: nil)
        })
        
        let cancelar = UIAlertAction(title: "Voltar", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(domingo)
        optionMenu.addAction(segunda)
        optionMenu.addAction(terça)
        optionMenu.addAction(quarta)
        optionMenu.addAction(quinta)
        optionMenu.addAction(sexta)
        optionMenu.addAction(sabado)
        optionMenu.addAction(cancelar)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func gerarNumero() {
        
        var numero = Int(arc4random_uniform(UInt32(compartilhado.arrayPratos.count)))
        sorteio(numero)
        
    }
    
    func sorteio (numero: Int) {
        
        var resultado : NSDictionary = resultados[numero] as NSDictionary
        
        compartilhado.indicePrato = numero
        
        compartilhado.pratoSelecionado = NSString(string: resultado["id_prato"] as String).integerValue
        
        var itens : ItensPratosViewController = ItensPratosViewController(nibName: "ItensPratosViewController", bundle: nil)
        
        self.presentViewController(itens, animated: true, completion: nil)
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var resultado : NSDictionary = resultados[indexPath.row] as NSDictionary
        
        compartilhado.indicePrato = indexPath.row
        
        compartilhado.pratoSelecionado = NSString(string: resultado["id_prato"] as String).integerValue
        
        var itens : ItensPratosViewController = ItensPratosViewController(nibName: "ItensPratosViewController", bundle: nil)
        
        self.presentViewController(itens, animated: true, completion: nil)
        
    }
    
    @IBAction func informacoes () {
        
        var dados : UIAlertView = UIAlertView()
        
        dados.title = " Sobre o APP "
        dados.message = "Restaurante: NOME \n Endereço: Rua tal, Número x \n Telefone (11) 12345-6789 \n\n\n Desenvolvido por: app.megamil.net \n Contato: Eduardo \n Telefone: (11) 96278-2329 "
        dados.addButtonWithTitle("Voltar")
        dados.show()
        
        
    }

}

