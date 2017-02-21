//
//  SVJargon.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Foundation

// Input
typealias SVSwarm = [SVRobot]
typealias SVMap = [SVObstacle]
typealias SVInstance = (swarm: SVSwarm, map: SVMap)
typealias SVPolygon = [CGPoint]

// Output
//typealias SVOutputBranch = SVOutputTree

// Drawing
typealias SVFramesPerSecond = Double
typealias SVRobotFrame = CGPoint
//typealias SVRobotFrame = (position:CGPoint,active:Bool)
typealias SVObstacleFrame = SVPolygon
typealias SVFrame = (robots: [SVRobotFrame], obstacles: [SVObstacleFrame])
typealias SVScaleFactor = CGFloat
