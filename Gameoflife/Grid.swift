//
//  Grid.swift
//  Gameoflife
//
//  Created by Li Zhang on 6/26/16.
//  Copyright © 2016 Li Zhang. All rights reserved.
//

import Foundation
import SpriteKit

class Grid: SKSpriteNode {
    
    /* Counters */
    var generation = 0
    var population = 0
    
    /* Grid array dimensions */
    let rows = 8
    let columns = 10
    
    /* Individual cell dimension, calculated in setup*/
    var cellWidth = 0
    var cellHeight = 0
    
    /* Creature Array */
    var gridArray = [[Creature]]()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab position of touch relative to the grid */
            let location  = touch.locationInNode(self)
            let gridX = Int(location.x) / cellWidth
            let gridY = Int(location.y) / cellHeight
            gridArray[gridX][gridY].isAlive = true
            population += 1
            
        }
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* Enable own touch implementation for this node */
        userInteractionEnabled = true
        
        /* Calculate individual cell dimensions */
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        
        /* Populate grid with creatures */
        populateGrid()
        
    }
    
    func populateGrid() {
        /* Populate the grid with creatures */
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Initialize empty column */
            gridArray.append([])
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Create a new creature at row / column position */
                addCreatureAtGrid(x:gridX, y:gridY)
            }
        }
    }
    
    func addCreatureAtGrid(x x: Int, y: Int){
        let newCreature = Creature()
        let location = CGPoint(x: x*cellWidth, y: y*cellWidth)
        self.addChild(newCreature)
        newCreature.position = location
        newCreature.isAlive = false
        gridArray[x].append(newCreature)
        
    }
    
    func countNeighbors() {
        /* Process array and update creature neighbor count */
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Grab creature at grid position */
                let currentCreature = gridArray[gridX][gridY]
                
                /* Reset neighbor count */
                currentCreature.neighborCount = 0
                
                /* Loop through all adjacent creatures to current creature */
                for innerGridX in (gridX - 1)...(gridX + 1) {
                    
                    /* Ensure inner grid column is inside array */
                    if innerGridX<0 || innerGridX >= columns { continue }
                    
                    for innerGridY in (gridY - 1)...(gridY + 1) {
                        
                        /* Ensure inner grid row is inside array */
                        if innerGridY<0 || innerGridY >= rows { continue }
                        
                        /* Creature can't count itself as a neighbor */
                        if innerGridX == gridX && innerGridY == gridY { continue }
                        
                        /* Grab adjacent creature reference */
                        let adjacentCreature:Creature = gridArray[innerGridX][innerGridY]
                        
                        /* Only interested in living creatures */
                        if adjacentCreature.isAlive {
                            currentCreature.neighborCount += 1
                        }  
                    }
                }    
            }
        }
    }
    
    func updateCreatures(){
        /* Reset population counter */
        population = 0
        /* Loop through the gird */
        for i in 0..<columns{
            for j in 0..<rows{
                /* Grab current creature */
                let current = gridArray[i][j]
                /* Check against game of life rules */
                switch current.neighborCount {
                case 3:
                    current.isAlive = true
                    break;
                case 0...1, 4...8:
                    current.isAlive = false
                    break;
                default:
                    break;
                }
                /* Count population */
                if current.isAlive == true{population += 1}
            }
        }
    }
    
    func evolve() {
        /* Updated the grid to the next state in the game of life */
        
        /* Update all creature neighbor counts */
        countNeighbors()
        
        /* Calculate all creatures alive or dead */
        updateCreatures()
        
        /* Increment generation counter */
        generation += 1
    }
}















