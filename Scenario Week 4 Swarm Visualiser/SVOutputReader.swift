//
//  SVOutputReader.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 21/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Foundation

class SVOutputReader: SVIOReader {
	
	class func updateInstanceWithOutput(instance: SVInstance, outputFilename : String) {
		
		let ouput = getTextFromInputFile(filename: outputFilename)
		
	}
	
	private class func separateBranchStringsFromTextFile(text: String) -> [String] {
		return separateStringBySemiColons(rep: text)
	}
	
	private class func separateBranchStringIntoCoordinates(rep: String) -> [String] {
		
		return separateCoordinateListString(rep: rep)
	}
	
	
	
//	private class func createBranchFromString(rep: String) -> SVRobot {
//		
//		let coordinates = convertStringToCoordinates(rep: rep)
//		
//		return SVRobot(x:coordinates.x, y:coordinates.y)
//	}
	
//	private class func createTreeFromBranches(rep: String) -> SVObstacle {
//		
//		let points = separateObstacleStringIntoCoordinates(rep: rep)
//		var coords = [(Double,Double)]()
//		for point in points {
//			coords.append(convertStringToCoordinates(rep: point))
//		}
//		
//		return SVObstacle(coordinates: coords)
//	}

	
	
}
