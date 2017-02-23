//
//  SVRobot.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

func ==(lhs: SVRobot, rhs: SVRobot) -> Bool {
	return lhs.start == rhs.start
}

class SVRobot: NSObject {
	
	private var activated = false
	
	var isActive : Bool {
		get {
			return self.activated
		}
	}
	
	var start : SVPoint!
	var current : SVPoint!
	
	var target : SVRobot?
	var path : SVPath!
	
	var available : Bool {
		get {
			return isActive && (target == nil)
		}
	}

	init(x: Double, y: Double) {
		super.init()
		
		let point = SVPoint(x: x, y: y)
		
		self.start = point
		self.current = point
		
		self.path = [start]
		
	}
	
	func activate() {
		self.activated = true
	}
	

}
