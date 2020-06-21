//
//  CameraViewController.swift
//  PyRelio
//
//  Created by Bruno Henrique de Borba on 14/06/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import ARKit
import Vision

class CameraViewController: UIViewController {
    
    
    @IBOutlet weak var previewView: ARSCNView!
    var timer: Timer?
    var rectangleView = UIView()
    var emojiLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.setNavigationBarHidden(true, animated: true)
        previewView.delegate = self
    }
    
    // funcao que garante o scan da imagem a cada 0.5 segundos
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        previewView.session.run(configuration)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.detectAnimal), userInfo: nil, repeats: true)
    }
    
    @objc func detectAnimal() {
        // garante que o retangulo anterior seja removido
        self.rectangleView.removeFromSuperview()
        guard let currentFrameBuffer = self.previewView.session.currentFrame?.capturedImage else { return }
        let image = CIImage(cvPixelBuffer: currentFrameBuffer)
        // faz o request para reconhecimento de animais
        let detectAnimalRequest = VNRecognizeAnimalsRequest { (request, error) in
            DispatchQueue.main.async {
                
                if let results = request.results?.first as? VNRecognizedObjectObservation {
                    // atribui os animais detectados
                    let animals = results.labels
                    // passa por cada animal detectado
                    for animal in animals {
                        // define a area detectada
                        self.rectangleView = UIView(frame: CGRect(x: results.boundingBox.minX * self.previewView.frame.width, y: results.boundingBox.minY * self.previewView.frame.height, width: results.boundingBox.width * self.previewView.frame.width, height: results.boundingBox.height * self.previewView.frame.height))
                        
                            // valida qual o animal identificado
                            if animal.confidence > 0.8 {
                                if animal.identifier == "Cat" {
                                    self.emojiLabel.text = "😸 " + String(animal.confidence * 100) + "%"
                                } else {
                                    self.emojiLabel.text = "🐶 " + String(animal.confidence * 100) + "%"
                                }
                            }
                            
                            // definições do emoji
                           self.emojiLabel.font = UIFont.systemFont(ofSize: 40)
                           self.emojiLabel.frame = CGRect(x: 0, y: 0, width: self.rectangleView.frame.width, height: self.rectangleView.frame.height)
                        
                           self.rectangleView.addSubview(self.emojiLabel)
                       
                          // definições do retangulo
                          self.rectangleView.backgroundColor = .clear
                          self.rectangleView.layer.borderColor = UIColor.red.cgColor
                          self.rectangleView.layer.borderWidth = 3
                          self.previewView.insertSubview(self.rectangleView, at: 0)
                    }
                }
            }
        }

        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image).perform([detectAnimalRequest])
        }
    }
    
    @IBAction func capture(_ sender: Any) {
        let currentFrame = previewView.snapshot()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcb = storyboard.instantiateViewController(withIdentifier: "Profile")
        (vcb as! ProfileViewController).animalImage = currentFrame
        
        DispatchQueue.main.async {
            self.present(vcb, animated: true, completion: nil)
        }
        
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * previewView.bounds.width, y: (1 - boundingBox.maxY) * previewView.bounds.height)
        let size = CGSize(width: boundingBox.width * previewView.bounds.width, height: boundingBox.height * previewView.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    
}

extension CameraViewController: ARSCNViewDelegate {
    
}
