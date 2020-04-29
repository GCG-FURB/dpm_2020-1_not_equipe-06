//
//  ViewController.swift
//  HelloWorld
//
//  Created by Bruno Henrique de Borba on 22/04/20.
//  Copyright © 2020 Equipe 6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "Primeira mensagem", message: "Hello World", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }


}

