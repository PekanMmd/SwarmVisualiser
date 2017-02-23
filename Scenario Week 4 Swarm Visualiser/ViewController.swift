//
//  ViewController.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	var frameRate : SVFramesPerSecond = 5
	var instance : SVInstance!
	
	var frameTimer : Timer!
	
	var display : SVDisplayView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let inputFile = Bundle.main.path(forResource: "input", ofType: "txt") ?? ""
		self.instance = SVInputReader.readInput(inputFilename: inputFile)
		
		let problemSolver = SVProblemSolver(instance: instance)
		
		problemSolver.marathonAlgorithm()
		
		print(problemSolver.outputStringForInstance())
		
		display = SVDisplayView(frame: self.view.frame , svFrame: frameFromInstance())
		
		self.display.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(display)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[d]|", options: [], metrics: nil, views: ["d" : display]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[d]|", options: [], metrics: nil, views: ["d" : display]))
		
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
		
		
	}

	
	func frameFromInstance() -> SVFrame {
		
		var roboPoints = [SVPoint]()
		
		for robot in instance.swarm {
//			roboPoints.append(robot.current)
			roboPoints.append(robot.start)
		}
		
		var lines = [SVEdge]()
		
		for robot in instance.swarm {
			
			if robot.path.count > 1 {
				
				for i in 0 ..< robot.path.count - 1 {
					
					lines.append((robot.path[i],robot.path[i+1]))
					
				}
			}
			
		}
		
		return (roboPoints,instance.map, lines)
	}
	


}

