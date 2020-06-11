//
//  FirstViewController.swift
//  PyRelio
//
//  Created by Daniel dos Santos on 27/05/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit

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

}

