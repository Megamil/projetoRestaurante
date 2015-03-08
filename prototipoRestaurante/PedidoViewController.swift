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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
            tableView.reloadData()
            break
        default:
            break
            
        }
    }
    

}
