//
//  ViewController.swift
//  MotionSensors
//
//  Created by Bruno Omella Mainieri on 14/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var vetorImg: [UIImage] = [#imageLiteral(resourceName: "estela"), #imageLiteral(resourceName: "estelaLight"), #imageLiteral(resourceName: "estelaRB")]
    
    @IBOutlet weak var horizon: UIView!
    
    @IBOutlet weak var imageEstela: UIImageView!
    
    let motion = CMMotionManager()
    
    var lastXUpdate = 0
    var lastYUpdate = 0
    var lastZUpdate = 0
    
    //false para a imagem 1 (estela apagada)
    var flagImage:Bool = false
    
    //variavel para controlar o tempo da imagem da estela brilhando
    var timerImg:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            //Frequencia de atualização dos sensores definida em segundos - no caso, 60 vezes por segundo
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            //A partir da chamada desta função, o objeto motion passa a conter valores atualizados dos sensores; o parâmetro representa a referência para cálculo de orientação do dispositivo
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            //Um Timer é configurado para executar um bloco de código 60 vezes por segundo - a mesma frequência das atualizações dos dados de sensores. Neste bloco manipulamos as informações mais recentes para atualizar a interface.
            var timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    print("oi")
                                    let x = data.userAcceleration.x
                                    let y = data.userAcceleration.y
                                    let z = data.userAcceleration.z
                                    
                                    //USAR MODULO
                                    //somar a aceleracao de todos os eixos com modulos
                                    //let aceleracao = abs(x) + abs(y) + abs(z)
                                    //será que posso usar o vetor direto ao inves da flag --> pode mas um booleano dura menos tempo
                                    //mudar a imagem aqui dentro, mas ter certeza que tenha uma flag para que para mudar para a img A, esteja na img B, e vice e versa
                                    
                                    
                                    if x > 1 {
                                        self.imageEstela.image = self.vetorImg[1]
                                        self.flagImage = true
                                    } else {
                                        if self.flagImage == true{
                                            self.timerImg = self.timerImg + 1
                                            if self.timerImg == 100{
                                                self.timerImg = 0
                                                self.imageEstela.image = self.vetorImg[0]
                                                self.flagImage = false
                                            }
                                        }
                                    }
                                    
                                    
                                    if y  > 1 {
                                        self.imageEstela.image = self.vetorImg[2]
                                        self.flagImage = true
                                    } else {
                                        if self.flagImage == true{
                                            self.timerImg = self.timerImg + 1
                                            if self.timerImg == 100{
                                                self.timerImg = 0
                                                self.imageEstela.image = self.vetorImg[0]
                                                self.flagImage = false
                                            }
                                        }
                                    }
                                    //criar uma variavel para o timer para que ela fique contando enquanto esta com a img1, e quando ela ficar com a img2, ele zera e congta 60
                                }
            })
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
}

