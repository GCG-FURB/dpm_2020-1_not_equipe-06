//
//  ViewController.swift
//  A7
//
//  Created by Daniel dos Santos on 22/04/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tf_usuario: UITextField!
    @IBOutlet weak var tf_senha: UITextField!
    var logado = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.verificaLogin()
        self.atualizaStatus()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bt_logar(_ sender: Any) {
        self.setAutentificacao()
        self.requestPost()
    }
    
    @IBAction func bt_limpaAuth(_ sender: Any) {
        self.deleteAllData("Autentificacao")
    }
    
    func atualizaStatus() {
        if logado {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "UsuarioController") as! UsuarioController
            DispatchQueue.main.async {
                self.present(newViewController, animated: true, completion: nil)
            }
        } else {
            self.getAutentificacao()
        }
    }
    
    func verificaLogin() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Autentificacao")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let tk = data.value(forKey: "usuario")
                if tk != nil && !(tk as! String).isEmpty {
                    logado = true
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    func setAutentificacao() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Autentificacao", in: context)
        let nnewEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        nnewEntity.setValue(tf_usuario.text, forKey: "usuario")
        nnewEntity.setValue(tf_senha.text, forKey: "senha")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed")
        }
    }
    
    func persistToken(token: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Autentificacao", in: context)
        let nnewEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        nnewEntity.setValue(token, forKey: "token")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed")
        }
    }
    
    func getAutentificacao() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Autentificacao")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                tf_usuario.text = ""
                tf_senha.text = ""
                tf_usuario.insertText(data.value(forKey: "usuario") as! String)
                tf_senha.insertText(data.value(forKey: "senha") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
    func requestPost() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        //requisita web
        let url = URL(string: "http://localhost:3333/sessions")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //transforma global int em string
        let usuario = String(tf_usuario.text!)
        let senha = String(tf_senha.text!)
        let postString = "{\"email\":\""+usuario+"\",\"password\":\""+senha+"\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //let returnData = String(data: data!, encoding: .utf8)
            if error != nil
            {
                print("Error")
            }
            else
            {
                if let content = data {
                    do
                    {
                        //mostra json
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        self.persistToken(token: myJson["token"] as! String)
                        self.verificaLogin()
                        self.atualizaStatus()
                    }
                    catch
                    {
                        let alert = UIAlertController(title: "Não foi possivel fazer login", message: "Verifique sua conexão com a rede", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
            
        }
        task.resume()
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            let results = try context.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
}

