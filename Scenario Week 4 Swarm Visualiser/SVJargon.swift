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
typealias SVPolygon = [SVPoint]
typealias SVObstacle = SVPolygon

// Output
//typealias SVOutputBranch = SVOutputTree

// Drawing
typealias SVFramesPerSecond = Double
typealias SVRobotFrame = SVPoint
//typealias SVRobotFrame = (position:SVPoint,active:Bool)
typealias SVObstacleFrame = SVPolygon
typealias SVFrame = (robots: [SVRobotFrame], obstacles: [SVObstacleFrame], lines: [SVEdge])
typealias SVScaleFactor = CGFloat

// Solving
typealias SVCluster = SVPolygon
typealias SVPath = [SVPoint]
typealias SVPathTable = [ (SVPoint, SVPoint, SVPath) ]
typealias SVEdge = (SVPoint, SVPoint)

public struct SVPoint {
	
	public var x: Double
	
	public var y: Double
	
	public var toCGPoint : CGPoint {
		get {
			return CGPoint(x: x, y: y)
		}
	}
	
	public init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}
	
}


extension SVPoint : CustomDebugStringConvertible {
	
	/// A textual representation of this instance, suitable for debugging.
	public var debugDescription: String { get {
			return "(\(self.x), \(self.y))"
		}
	}
}

extension SVPoint : Equatable {
	public static func ==(lhs: SVPoint, rhs: SVPoint) -> Bool {
		return (lhs.x == rhs.x) && (lhs.y == rhs.y)
	}
}





