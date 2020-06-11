//
//  ImageViewController.swift
//  PyRelio
//
//  Created by Daniel dos Santos on 27/05/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var tf_nome: UITextField!
    @IBOutlet weak var tf_descricao: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.abrirCaptura();
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmar(_ sender: Any) {
        self.salvarRegistro()
    }
    
    func abrirCaptura() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //camera
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
//                myImg.contentMode = .scaleToFill
//                myImg.image = pickedImage
//            }
//            picker.dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        myImg.image = image;
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
    func salvarRegistro() {
        
        let r = Registro();
        r.nome = tf_nome.text;
        r.descricao = tf_descricao.text;
        ListImagesViewController.lista.append(r);
        
        let imageData = myImg.image!.pngData()
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        r.imagem = compresedImage;
        
//        let alert = UIAlertController(title: "Ok", message: "Sua image foi salva", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
        
//        DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcb = storyboard.instantiateViewController(withIdentifier: "ListaRegistros") as! UIViewController
        
        DispatchQueue.main.async {
            self.present(vcb, animated: true, completion: nil)
        }
    }
    
}
