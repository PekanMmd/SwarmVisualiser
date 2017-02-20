//
//  SVJargon.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Foundation


typealias SVSwarm = [SVRobot]
typealias SVMap = [SVObstacle]
typealias SVInstance = (swarm: SVSwarm, map: SVMap)
typealias SVPolygon = [CGPoint]
typealias SVFramesPerSecond = Double
typealias SVRobotFrame = CGPoint
typealias SVObstacleFrame = SVPolygon
typealias SVFrame = (robots: [SVRobotFrame], obtacles: [SVObstacleFrame])
