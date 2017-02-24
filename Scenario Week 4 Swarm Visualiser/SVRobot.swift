//
//  SVRobot.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa


var lastIndex = 0
class SVRobot: NSObject {
	
	private var activated = false
	var targeted = false
	
	var isActive : Bool {
		get {
			return self.activated
		}
	}
	
	var index = 0
	
	var start : SVPoint!
	var current : SVPoint!
	
	var target : SVRobot?
	var path : SVPath!
	var pathIndex : Int = 0
	
	var available : Bool {
		get {
			return isActive && (target == nil)
		}
	}
	
	static func ==(lhs: SVRobot, rhs: SVRobot) -> Bool {
		return lhs.start == rhs.start
	}
	
	override public var debugDescription: String {
		get {
			return "Robot: (\(self.start.x), \(self.start.y))"
		}
	}
	
	override var description: String {
		get {
			return "Robot: (\(self.start.x), \(self.start.y))"
		}
	}

	init(x: Double, y: Double) {
		super.init()
		
		let point = SVPoint(x: x, y: y)
		
		self.start = point
		self.current = point
		
		self.path = [start]
		
		self.index = lastIndex
		lastIndex += 1
		
	}
	
	func activate() {
		self.activated = true
	}
	

}
