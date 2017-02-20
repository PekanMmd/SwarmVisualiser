//
//  SVObstacle.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVObstacle: NSObject {
	
	var coordinates : SVPolygon!
	
	init(coordinates : [(Double,Double)]) {
		super.init()
		let co = coordinates.map { (coords: (x: Double, y: Double)) -> CGPoint in
			return CGPoint(x: coords.x, y: coords.y)
		}
		self.coordinates = co
	}

}
