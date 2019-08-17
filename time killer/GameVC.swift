//
//  GameVC.swift
//  Get ready for ...
//
//  Created by Anmin on 8/15/19.
//  Copyright © 2019 Hope to. All rights reserved.
//

import UIKit

class GameVC: UIViewController {

    static let widthScreen = Int(UIScreen.main.bounds.size.width)
    static let heightScreen = Int(UIScreen.main.bounds.size.height)
    var leftMove = false
    var rightMove = false
    
    var timer = Timer()
    
    let hero = UIView.init(frame: CGRect(x: (widthScreen / 2) - 25, y: heightScreen - 200 - 50, width:  50, height: 50))
    static var heroX: CGFloat!
    static var heroMaxX: CGFloat!
    static var heroY: CGFloat!
    static var heroMaxY: CGFloat!
    static var score: Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var gameOverBtn: UIButton!
    @IBOutlet weak var gameOver: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.backgroundColor = .red
        GameVC.heroMaxY = self.hero.frame.maxY
        GameVC.heroY = self.hero.frame.origin.y
        self.view.addSubview(hero)
        self.gameOver.isHidden = true
        self.gameOverBtn.isHidden = true
        self.playGame()

        self.scoreLabel.text = "0"
    }
    
    func playGame(){
        DispatchQueue.main.async {
            self.timer = Timer.init(timeInterval: 0.03, target: self, selector: #selector(self.game), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer,forMode: .common)
        }
    }
    
    @objc func game(){
        heroMoveing()
        createDanger()
    }
    
    func createDanger(){
        
        if self.view.subviews.count == 3{
            print("делаем опастность")
            let randomX = Int.random(in: 0...Int(self.view.frame.size.width))
            let danger = UIView.init(frame: CGRect(x: randomX, y: -40, width: 5, height: 10))
            danger.backgroundColor = .black
            self.view.addSubview(danger)
        }
        
        let lastView = self.view.subviews.last
        
        if let y = lastView?.frame.origin.y,
        y > 0{
            
            print("делаем опастность")
            
            let randomX = Int.random(in: 0...Int(self.view.frame.size.width))
            let danger = UIView.init(frame: CGRect(x: randomX, y: -40, width: 5, height: 10))
            danger.backgroundColor = .black
            self.view.addSubview(danger)
        }
        let heroRange = GameVC.heroX...GameVC.heroMaxX
        let heroRangeY = GameVC.heroY...GameVC.heroMaxY
        for danger in self.view.subviews{
            if danger.frame.size.width == 5{
                print("двигаем", danger.frame.origin.y)
                if danger.frame.origin.y >= self.view.frame.size.height{
                    danger.removeFromSuperview()
                    GameVC.score += 1
                    self.scoreLabel.text = String(GameVC.score)
                }
                
                if heroRange.contains(danger.frame.origin.x) && heroRangeY.contains(danger.frame.maxY){
                   
                    self.gameOverBtn.isHidden = false
                    self.gameOver.isHidden = false
                    self.btnStack.isHidden = true
                    
                    self.timer.invalidate()
                    
                }
                
                danger.frame.origin.y += 5
            }
        }
    }
    
    func heroMoveing(){
        if leftMove == true && self.hero.frame.origin.x > 0 {
            self.hero.frame.origin.x -= 5
        }else if rightMove == true && hero.frame.maxX < self.view.frame.size.width{
            self.hero.frame.origin.x += 5
        }
        GameVC.heroMaxX = self.hero.frame.maxX
        GameVC.heroX = self.hero.frame.origin.x
    }
    

    @IBAction func leftBtn(_ sender: UIButton) {
            self.leftMove = true
            self.rightMove = false
    }

    @IBAction func rightBtn(_ sender: UIButton) {
        print("правый")
        self.rightMove = true
        self.leftMove = false
    }
    @IBAction func startAgain(_ sender: Any) {
        for danger in self.view.subviews{
            if danger.frame.size.width == 5{
                danger.removeFromSuperview()
            }
        }
        self.gameOverBtn.isHidden = true
        self.gameOver.isHidden = true
        self.btnStack.isHidden = false
        self.scoreLabel.text = "0"
        GameVC.score = 0
        playGame()
    }
}
