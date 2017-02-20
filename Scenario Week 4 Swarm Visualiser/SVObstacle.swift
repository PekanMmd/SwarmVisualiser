//
//  SVObstacle.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVObstacle: NSObject {
	
	var coordinates : [ (x:Double,y:Double) ]!
	
	init(coordinates : [ (x:Double,y:Double) ]) {
		super.init()
		
		self.coordinates = coordinates
	}

}
