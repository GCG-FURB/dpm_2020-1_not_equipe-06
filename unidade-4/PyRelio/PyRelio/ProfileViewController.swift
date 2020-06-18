//
//  ProfileViewController.swift
//  PyRelio
//
//  Created by Bruno Henrique de Borba on 14/06/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import VisionKit
import Vision
import CoreData

class ProfileViewController: UIViewController, VNDocumentCameraViewControllerDelegate {

    @IBOutlet var animalView: UIImageView!
    @IBOutlet var animalDetailsViewText: UITextView!
    
    var animalImage: UIImage!
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.title = "Novo animal"
            animalView.image = animalImage
            
            textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
                if let results = request.results, !results.isEmpty {
                    if let requestResults = request.results as? [VNRecognizedTextObservation] {
                        self.recognizedText = ""
                        for observation in requestResults {
                            guard let candidiate = observation.topCandidates(1).first else { return }
                            self.recognizedText += candidiate.string
                            self.recognizedText += "\n"
                        }
                        self.animalDetailsViewText.text = self.recognizedText
                    }
                }
            })
            textRecognitionRequest.recognitionLevel = .accurate
            textRecognitionRequest.usesLanguageCorrection = false
            textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
        }
    
    
        
        @IBAction func scanDocument(_ sender: Any) {
            // Use VisionKit to scan business cards
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true, completion: nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let image = scan.imageOfPage(at: 0)
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
                print(error)
            }
            controller.dismiss(animated: true)
        }

    @IBAction func salvarRegistro(_ sender: Any) {
        let full = recognizedText.components(separatedBy: ",")
        
        let r = Registro();
        r.nome = full[0];
        r.descricao = full[1];
        ListImagesViewController.lista.append(r);
        
        let imageData = animalImage.pngData()
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        r.imagem = compresedImage;
        
        self.persisteRegistro(nome: r.nome,descricao: r.descricao);
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcb = storyboard.instantiateViewController(withIdentifier: "ListaRegistros")
        
        DispatchQueue.main.async {
            self.present(vcb, animated: true, completion: nil)
        }
    }
    
    func persisteRegistro(nome: String!, descricao: String!) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RegistroModel", in: context)
        let nnewEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        nnewEntity.setValue(nome, forKey: "nome")
        nnewEntity.setValue(descricao, forKey: "descricao")
        nnewEntity.setValue(animalImage.pngData(), forKey: "img")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed")
        }
    }
    
}
