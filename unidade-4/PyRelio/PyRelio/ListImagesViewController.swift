//
//  FirstViewController.swift
//  PyRelio
//
//  Created by Daniel dos Santos on 27/05/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import CoreData

class tableRegistroClass: UITableViewCell {
    @IBOutlet weak var lb_descricao: UILabel!
    @IBOutlet weak var img: UIImageView!
}

class ListImagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableRegistros: UITableView!
    
    static var lista = [Registro]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadRegistro()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListImagesViewController.lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableRegistroClass
        
        cell.lb_descricao.text = ListImagesViewController.lista[indexPath.row].descricao
        cell.img.image = ListImagesViewController.lista[indexPath.row].imagem
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoModal(id: indexPath.row)
    }
    
    func gotoModal(id: Int) {
        self.loadRegistro()
        Common.Global.IDREGISTROSELECTED = ListImagesViewController.lista[id].id;
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcb = storyboard.instantiateViewController(withIdentifier: "ModalRegistro")

        DispatchQueue.main.async {
            self.present(vcb, animated: false, completion: nil)
        }
    }
    
    func loadRegistro() {
        ListImagesViewController.lista = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegistroModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let id = data.value(forKey: "id") as! String
                let nome = data.value(forKey: "nome") as! String
                let descricao = data.value(forKey: "descricao") as! String
                let image = data.value(forKey: "img") as? Data
                
                let r = Registro();
                r.id = id;
                r.nome = nome;
                r.descricao = descricao;
                if (image != nil) {
                    r.imagem = UIImage(data: image!);
                }
                ListImagesViewController.lista.append(r);
                
            }
        } catch {
            print("Failed")
        }
    }

}

