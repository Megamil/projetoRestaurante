//
//  PedidoViewController.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 04/03/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

class PedidoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label_Preço: UILabel!
    @IBOutlet weak var inputDivisao: UITextField!
    @IBOutlet weak var label_pedido: UILabel!
    @IBOutlet weak var botao_cancelar: UIButton!
    
    var compartilhado = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet var appsTableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func claseKeyboard(){
        
        inputDivisao.resignFirstResponder()
        
    }
    
    @IBAction func dividirPor() {
        
        var dividir : Float = NSString(string: inputDivisao.text).floatValue
        
        if(compartilhado.preçoTotal <= 0) {

            var dados : UIAlertView = UIAlertView()
            dados.title = " Dividir conta "
            dados.message = "Você ainda não fez nenhum pedido."
            dados.addButtonWithTitle("OK")
            dados.show()
            
        
        } else if(dividir > 1) {
        
        var valor : Float = compartilhado.preçoTotal / dividir
        
        var valor2 = NSString(format: "%.2f", valor) as String
        
        var valorFormatado = valor2.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var dados : UIAlertView = UIAlertView()
        dados.title = " Dividir conta "
        dados.message = "A conta dividida por \(inputDivisao.text) pessoas sairá por: R$ \(valorFormatado) para cada."
        dados.addButtonWithTitle("OK")
        dados.show()
        
        } else {
            
            var dados : UIAlertView = UIAlertView()
            dados.title = " Dividir conta "
            dados.message = "Digite o número total de pessoas que irão dividir a conta"
            dados.addButtonWithTitle("OK")
            dados.show()
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var preçoFormatando : String = NSString(format: "%.2f", compartilhado.preçoTotal) as String
        
        var preçoFormatado = preçoFormatando.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        label_Preço.text = "Total R$: \(preçoFormatado)"
        
        var id : String = "pedidos"
        
        var celula : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if celula == nil {
            
            celula = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            
        }
        
        var objeto : NSArray = compartilhado.arrayPedidos.objectAtIndex(indexPath.row) as NSArray
        
        celula?.textLabel?.text = objeto.objectAtIndex(0) as? String
        celula?.detailTextLabel?.text = objeto.objectAtIndex(1) as? String
        
        var imagem : String = objeto.objectAtIndex(2) as String
        
        var icone : UIImage? = UIImage(named: imagem)
        
        celula?.imageView?.image = icone
        
        return celula!
    
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return compartilhado.arrayPedidos.count
        
    }
    
    @IBAction func zerar(sender: AnyObject) {
        
        let confirmar : UIAlertView = UIAlertView()
        confirmar.delegate = self
        confirmar.message = "Deseja realmente zerar seu(s) pedido(s)?"
        confirmar.addButtonWithTitle("Não")
        confirmar.addButtonWithTitle("Apagar")
        confirmar.show()

    }
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 1:
            compartilhado.arrayPedidos.removeAllObjects()
            self.dismissViewControllerAnimated(true, completion: nil)
            compartilhado.preçoTotal = 0.00
            label_Preço.text = "Total R$: 0,00"
            tableView.reloadData()
            
            if(botao_cancelar.titleLabel?.text == "FUI ATENDIDO") {
                
                botao_cancelar.setTitle("CANCELAR PEDIDO", forState: UIControlState.Normal)
                label_pedido.text = ""
                compartilhado.travarPedidos = false
            }
            
            break
        default:
            break
            
        }
    }
    
    @IBAction func pedir() {
        
        if (compartilhado.arrayPedidos.count > 0 && compartilhado.travarPedidos == false) {
        
        var pratos : String = String()
        var lanches : String = String()
        var bebidas : String = String()
        var i = 0
        
        for(i; i < compartilhado.arrayPedidos.count; ++i){
        
        var pedido : NSArray = compartilhado.arrayPedidos.objectAtIndex(i) as NSArray
            
        var referencia : String = pedido.objectAtIndex(5) as String
            
        switch referencia {
            
            
        case "prato":
            pratos += "\(pedido.objectAtIndex(3))-"
            break
        case "lanche":
            lanches += "\(pedido.objectAtIndex(3))-"
            break
            
        case "bebida":
           bebidas += "\(pedido.objectAtIndex(3))-"
            break
        default:
            break
            
        }
            
        }
        
        var urlPath: String = "\(compartilhado.endereço)pedir.php?preco=\(compartilhado.preçoTotal)&pratos=\(pratos)&lanches=\(lanches)&bebidas=\(bebidas)"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var resultados : NSArray = jsonResult["resultados"] as NSArray
        
        var resultado : NSDictionary = resultados[0] as NSDictionary
        
        var codPedido : String = resultado["pedidoNum"] as String
        
        label_pedido.text = "Pedido cadastrado com sucesso! \n informe o número \(codPedido) a um atendente"
        
        compartilhado.travarPedidos = true
        botao_cancelar.setTitle("FUI ATENDIDO", forState: UIControlState.Normal)
        
        } else if (compartilhado.arrayPedidos.count <= 0) {
         
            let confirmar : UIAlertView = UIAlertView()
            confirmar.delegate = self
            confirmar.message = "Para realizar um novo pedido tenha certeza de que selecionou ao menos um item."
            confirmar.addButtonWithTitle("OK")
            confirmar.show()
            
        } else {
                
                let confirmar : UIAlertView = UIAlertView()
                confirmar.delegate = self
                confirmar.message = "Para realizar um novo pedido, primeiramente finalize o pedido atual precionando o botão FUI ATENDIDO!"
                confirmar.addButtonWithTitle("OK")
                confirmar.show()
                
            
        }
        
    }
    
}
