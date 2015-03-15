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
            break
        default:
            break
            
        }
    }
    

}
