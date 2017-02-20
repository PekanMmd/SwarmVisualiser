//
//  SVInputReader.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVInputReader: NSObject {
	
	class func readInput(inputFilename : String) -> ([SVRobot],[SVObstacle]) {
		
		let input = getTextFromInputFile(filename: inputFilename)
		let objects = separateObjectStringsFromTextFile(text: input)
		
		var robots = [SVRobot]()
		var obstacles = [SVObstacle]()
		
		for object in objects {
			if stringRepresentsRobot(rep: object) {
				let rob = createRobotFromString(rep: object)
				robots.append(rob)
			} else {
				let obs = createObstacleFromString(rep: object)
				obstacles.append(obs)
			}
		}
		
		return (robots,obstacles)
	}
	
	private class func getTextFromInputFile(filename: String) -> String {
		
		return ""
	}
	
	private class func separateObjectStringsFromTextFile(text: String) -> [String] {
		
		return [String]()
	}
	
	private class func stringRepresentsRobot(rep: String) -> Bool {
		
		return true
	}
	
	private class func createRobotFromString(rep: String) -> SVRobot {
		
		return SVRobot(x:0,y:0)
	}
	
	private class func createObstacleFromString(rep: String) -> SVObstacle {
		
		return SVObstacle(coordinates: [(x:0,y:0)])
	}
	

}
