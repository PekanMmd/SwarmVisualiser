//
//  SVRobot.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVRobot: NSObject {
	
	private var activated = false
	
	var isActive : Bool {
		get {
			return self.activated
		}
	}
	
	var x : Double!
	var y : Double!
	
	var coordinate : CGPoint {
		get {
			return CGPoint(x: x, y: y)
		}
	}

	init(x: Double, y: Double) {
		super.init()
		
		self.x = x
		self.y = y
		
	}
	
	func activate() {
		self.activated = true
	}

}
