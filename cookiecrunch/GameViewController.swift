//
//  GameViewController.swift
//  cookiecrunch
//
//  Created by giaunv on 3/8/15.
//  Copyright (c) 2015 366. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController{
    var scene: GameScene!
    var level: Level!
    var movesLeft = 0
    var score = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBAction func shuffleButtonPressed(AnyObject){
        shuffle()
        decrementMoves()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        level = Level(filename: "Level_3")
        scene.level = level
        scene.addTiles()
        
        scene.swipeHandler = handleSwipe
        
        gameOverPanel.hidden = true
        shuffleButton.hidden = true
        
        // Present the scene
        skView.presentScene(scene)
        beginGame()
    }
    
    func beginGame(){
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        
        level.resetComboMultiplier()
        scene.animateBeginGame(){
            self.shuffleButton.hidden = false
        }
        
        shuffle()
    }
    
    func shuffle(){
        scene.removeAllCookieSprites()
        let newCookies = level.shuffle()
        scene.addSpritesForCookies(newCookies)
    }
    
    func handleSwipe(swap: Swap){
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap){
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches)
        } else{
            scene.animateInvalidSwap(swap){
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    func handleMatches(){
        let chains = level.removeMatches()
        if chains.count == 0{
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(chains){
            for chain in chains{
                self.score += chain.score
            }
            self.updateLabels()
            
            let columns = self.level.fillHoles()
            
            self.scene.animateFallingCookies(columns){
                let columns = self.level.topUpCookies()
                
                self.scene.animateNewCookies(columns){
                    self.handleMatches()
                }
            }
        }
    }
    
    func beginNextTurn(){
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
        
        decrementMoves()
    }
    
    func updateLabels(){
        targetLabel.text = NSString(format: "%ld", level.targetScore)
        movesLabel.text = NSString(format: "%ld", movesLeft)
        scoreLabel.text = NSString(format: "%ld", score)
    }
    
    func decrementMoves(){
        --movesLeft
        updateLabels()
        
        if score >= level.targetScore{
            gameOverPanel.image = UIImage(named: "LevelComplete")
            showGameOver()
        } else if movesLeft == 0{
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver(){
        shuffleButton.hidden = true
        gameOverPanel.hidden = false
        scene.userInteractionEnabled = false
        
        scene.animateGameOver(){
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver(){
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        
        beginGame()
    }
}