//
//  ViewController.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

// Algorithm Constants
let kNumberOfClusters				: Int    = 6
let kIntersectionGradation			: Double = 25
let kIntersectionSkip				: Double = 25
let kPrioritiseAdjacentPaths		: Bool	 = true

//  Not used yet
let kStarClusterPrioritiseAdjacent	: Bool	 = false
let kStarClusterNoChill				: Bool	 = false

class ViewController: NSViewController {
	
	var frameRate : SVFramesPerSecond = 100
	var instance : SVInstance!
	
	var frameTimer : Timer!
	
	var display : SVDisplayView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let inputFile = Bundle.main.path(forResource: "input", ofType: "txt") ?? ""
		self.instance = SVInputReader.readInput(inputFilename: inputFile)
		
		let outputFile = Bundle.main.path(forResource: "output", ofType: "txt") ?? ""
		self.instance = SVOutputReader.updateInstanceWithOutput(instance: self.instance, outputFilename: outputFile)
		
		instance.swarm[0].activate()
		
		// Visualiser
		display = SVDisplayView(frame: self.view.frame , svFrame: frameFromInstance())
		
		self.display.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(display)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[d]|", options: [], metrics: nil, views: ["d" : display]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[d]|", options: [], metrics: nil, views: ["d" : display]))
		
		beginVisualisation()
		
		//		// Problem Solver Code
		//		let problemSolver = SVProblemSolver(instance: instance)
		//
		////		problemSolver.runFatBoyRunAlgorithm()
		////		problemSolver.marathonAlgorithm()
		//		problemSolver.solveByStarCluster(numberOfClusters: kNumberOfClusters)
		//
		//		print(problemSolver.outputStringForInstance())
		
	}
	
	func beginVisualisation() {
		frameTimer = Timer.scheduledTimer(timeInterval: 1.0 / frameRate, target: self, selector: #selector(update), userInfo: nil, repeats: true)
	}
	
	func update() {
		
		updateInstance()
		let nextFrame = frameFromInstance()
		display.updateWithFrame(frame: nextFrame)
		
		if instanceIsComplete() {
			frameTimer.invalidate()
		}
		
	}
	
	func instanceIsComplete() -> Bool {
		for robot in instance.swarm {
			if !robot.isActive {
				return false
			}
		}
		return true
	}
	
	func updateInstance() {
		
		for robot in instance.swarm where robot.isActive {
			
			if robot.pathIndex < robot.path.count - 1 {
				
				let target = robot.path![robot.pathIndex + 1]
				
				var dx = (target.x - robot.path[robot.pathIndex].x) / 50
				var dy = (target.y - robot.path[robot.pathIndex].y) / 50
				
//				let m = dy / dx
//				dy = dy / sqrt(pow(dy,2) + pow(dx,2))
//				dx = dx / sqrt(pow(dy,2) + pow(dx,2))
				
				
//				dx = dx * scaleFactor
//				dy = dy * scaleFactor
				
				robot.current = SVPoint(x: robot.current.x + dx, y: robot.current.y + dy)
				
				for rob in instance.swarm where !rob.isActive {
					if robot.current == rob.current {
						rob.activate()
					}
				}
				if robot.current == target {
					robot.pathIndex = robot.pathIndex + 1
				}
			}
		}
		
	}

	
	func frameFromInstance() -> SVFrame {
		
		var lines = [SVEdge]()
		
		var roboPoints = [SVRobotFrame]()
		
		for robot in instance.swarm {
			
			roboPoints.append((robot.current,robot.isActive,robot.index))
		}
		
		
		
//		for robot in instance.swarm {
//			
//			if robot.path.count > 1 {
//				
//				for i in 0 ..< robot.path.count - 1 {
//					
//					lines.append((robot.path[i],robot.path[i+1]))
//					
//				}
//			}
//			
//		}
		
		return (roboPoints,instance.map, lines)
	}
	


}

