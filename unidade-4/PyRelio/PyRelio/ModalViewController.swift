//
//  ModalViewController.swift
//  PyRelio
//
//  Created by Daniel dos Santos on 21/06/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import CoreData

class ModalViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tf_nome: UILabel!
    @IBOutlet weak var tf_descricao: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func gotoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadRegistro(p_id: String) {
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
                
                if (id == p_id) {
                    self.tf_nome.text = nome;
                    self.tf_descricao.text = descricao;
                    if (image != nil) {
                        self.img.image = UIImage(data: image!);
                    }
                }
                    
                
            }
        } catch {
            print("Failed")
        }
    }
    
}
