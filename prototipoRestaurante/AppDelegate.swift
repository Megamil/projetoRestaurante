//
//  AppDelegate.swift
//  prototipoRestaurante
//
//  Created by Eduardo dos santos on 14/02/15.
//  Copyright (c) 2015 megamil. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //Variavel compartilhada que contém um array com os pedidos
    var arrayPedidos : NSMutableArray = NSMutableArray()
    //Variavel compartilhada que contém um array com os Pratos do dia
    var arrayPratos : NSMutableArray = NSMutableArray()
    //Variavel compartilhada que contém um array com os Pratos da semana.
    var arrayPratosSemana : NSMutableArray = NSMutableArray()
     //Variavel compartilhada que contém o indice no array acima, usado quando a tela de itens é chamada
    var indicePrato : Int = Int()
    // indica qual dia sa semana o usuário escolheu
    var dia : Int = Int()
    //indica a forma escrita do dia da semana.
    var tituloDia : String = String()
    //indica o id_prato do prato selecionado, usado na tela de itens
    var pratoSelecionado : Int = Int()
    //Registra o preço total do pedido.
    var preçoTotal : Float = 0.00
    
    var window: UIWindow?
    //usado para não permitir que o usuário faça um pedido de um prato em um dia diferênte ao de hoje.
    var boolPedir : Bool = true
    //usado para impedir novos pedidos em caso de um estar em andamento.
    var travarPedidos : Bool = false
    
    var endereço : String = "http://localhost:8888/restaurante/json/"
    
    func hoje() -> Int {
        let today = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let data = formatter.stringFromDate(today)
        let stringData = formatter.dateFromString(data)
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.WeekdayCalendarUnit, fromDate: stringData!)
        var weekDay = myComponents?.weekday
        
        return weekDay!.hashValue
    }
    
    func data() -> String {
        
        let today = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let data = formatter.stringFromDate(today)
        
        return data
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

