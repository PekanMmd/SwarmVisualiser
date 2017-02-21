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
		var hasReachedHashtag = false
		var isWithinParentheses = false
		var stringOfObject = ""
		var arrayOfObjects = [String]()
//		for i in text.characters {
//			if (!hasReachedHashtag){
//				if (i == "("){
//					isWithinParentheses = true
//					stringOfObject.append(i)
//				} else if (i == "#"){
//					hasReachedHashtag = true
//				} else if (i == ")"){
//					stringOfObject.append(i)
//					arrayOfObjects.append(stringOfObject)
//					stringOfObject = ""
//					isWithinParentheses = false
//				} else if (isWithinParentheses){
//					stringOfObject.append(i)
//				}
//				
//			} else {
//				if (i != ";"){
//					stringOfObject.append(i)
//				} else {
//					arrayOfObjects.append(stringOfObject)
//					stringOfObject = ""
//				}
//			}
//			
//		}
		
		return arrayOfObjects
	}
	
	private class func separateBranchStringIntoCoordinates(rep: String) -> [String] {
		
		
		var arrayOfCoordinates = [String]()
		var stringOfSingleCoordinates = ""
		
		var isWithinParentheses = false
		for i in rep.characters {
			if (i == "("){
				isWithinParentheses = true
				stringOfSingleCoordinates.append(i)
			} else if (i == ")"){
				stringOfSingleCoordinates.append(i)
				arrayOfCoordinates.append(stringOfSingleCoordinates)
				stringOfSingleCoordinates = ""
				isWithinParentheses = false
			} else if (isWithinParentheses){
				stringOfSingleCoordinates.append(i)
			}
		}
		
		
		return arrayOfCoordinates
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
