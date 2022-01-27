//
//  ViewController.swift
//  Module13
//
//  Created by username on 26.01.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var prevBackground: UIView!
    @IBOutlet weak var playBackground: UIView!
    @IBOutlet weak var nextBackground: UIView!
    @IBOutlet weak var animationLabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    enum Mode: String, CaseIterable {
        case none = "Без анимации"
        case colorChange = "Изменение цвета"
        case positionChange = "Перемещение"
        case cornerRadiusChange = "Закругление"
        case rotation = "Поворот"
        case fadingOut = "Исчезновение"
        case sizeChange = "Увеличение"
        case repeatRotation = "Бесконечное вращение"
        case complexAnimation = "Комплексная анимация"
    
        mutating func next() {
            let allCases = Self.allCases
            self = allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
        }
        
        mutating func prev() {
            guard self != .none else { return }
            let allCases = Self.allCases
            self = allCases[allCases.firstIndex(of: self)! - 1]
        }
    }
    
    var animationMode = Mode.none  {
        didSet {
            animationLabel.text = String("\(animationMode.rawValue)")
            executeAnimation()
        }
    }
    
    lazy var redSquare: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.frame = CGRect(x: self.view.center.x - 50,
                         y: self.view.center.y - 50,
                         width: 100,
                         height: 100)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(redSquare)
        [prevBackground, playBackground, nextBackground].forEach { view in
            view?.layer.cornerRadius = view!.frame.height / 2
            view?.clipsToBounds = true
            view?.alpha = 0.0
        }
        animationMode = .colorChange
    }
    
    private func executeAnimation() {
        redSquare.layer.removeAllAnimations()
        
        switch animationMode {
            
        case .colorChange:
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
                self.redSquare.backgroundColor = .yellow
            }, completion: { _ in self.redSquare.backgroundColor = .red })
        
        case .positionChange:
            UIView.animate(withDuration: 1.0, animations: {
                self.redSquare.transform = CGAffineTransform(translationX: self.view.frame.width/2 - 75, y: -self.view.frame.height/2 + 100)
            }) { _ in UIView.animate(withDuration: 1.0, animations: { self.redSquare.transform = CGAffineTransform.identity })
            }
        
        case .cornerRadiusChange:
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = NSNumber(value: 0)
            animation.toValue = NSNumber(value: 50)
            animation.duration = 2.0
            redSquare.layer.add(animation, forKey: "cornerRadius")
        
        case .rotation:
            UIView.animate(withDuration: 1.0, animations: {
                self.redSquare.transform = CGAffineTransform(rotationAngle: .pi)
            }) { _ in UIView.animate(withDuration: 1.0, animations: { self.redSquare.transform = CGAffineTransform.identity })
            }
        
        case .fadingOut:
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseOut], animations: {
                self.redSquare.alpha = 0.0
                self.redSquare.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                self.redSquare.alpha = 1.0
                self.redSquare.transform = CGAffineTransform.identity
            })
        
        case .sizeChange:
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.1, options: [], animations: {
                self.redSquare.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }) { _ in UIView.animate(withDuration: 1.0, animations: { self.redSquare.transform = CGAffineTransform.identity })
            }
        
        case .repeatRotation:
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .curveLinear], animations: {
                self.redSquare.transform = CGAffineTransform(rotationAngle: .pi)
            })
        case .complexAnimation:
            UIView.animate(withDuration: 2.0, animations: {
                self.redSquare.backgroundColor = .purple
                let scaleTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                let rotateTransform = CGAffineTransform(rotationAngle: .pi)
                let translateTransform = CGAffineTransform(translationX: self.view.frame.width/2 - 75,
                                                           y: -self.view.frame.height/2 + 100)
                let comboTransform = scaleTransform.concatenating(rotateTransform).concatenating(translateTransform)
                self.redSquare.transform = comboTransform },
                completion: { _ in UIView.animate(withDuration: 2.0, animations: {
                self.redSquare.transform = CGAffineTransform.identity
                self.redSquare.backgroundColor = .red
                })
            })
        
        default:
            break
        }
    }
    
    
    @IBAction func touchedUpInside(_ sender: UIButton) {
        let buttonBackground: UIView
        
        switch sender {
        case prevButton:
            buttonBackground = prevBackground
            animationMode.prev()
        case nextButton:
            buttonBackground = nextBackground
            animationMode.next()
        case playButton:
            buttonBackground = playBackground
            executeAnimation()
        default:
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            buttonBackground.alpha = 0.0
            buttonBackground.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            sender.transform = CGAffineTransform.identity
        }, completion: { _ in
            buttonBackground.transform = CGAffineTransform.identity
        })
    }
    
    @IBAction func touchedDown(_ sender: UIButton) {
        let buttonBackground: UIView
        
        switch sender {
        case prevButton:
            buttonBackground = prevBackground
        case nextButton:
            buttonBackground = nextBackground
        case playButton:
            buttonBackground = playBackground
        default:
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            buttonBackground.alpha = 0.3
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        })
    }
    
}

