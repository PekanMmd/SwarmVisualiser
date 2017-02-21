//
//  SVInputReader.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVInputReader: SVIOReader {
    
	class func readInput(inputFilename : String) -> SVInstance {
		
		let input = getTextFromInputFile(filename: inputFilename)
		let objects = separateObjectStringsFromTextFile(text: input)
		
		var swarm = SVSwarm()
		var map = SVMap()
		
		for object in objects {
			if stringRepresentsRobot(rep: object) {
				let robot = createRobotFromString(rep: object)
                print("robot: \(robot.x) \(robot.y)")
				swarm.append(robot)
			} else {
				let obstacle = createObstacleFromString(rep: object)
				map.append(obstacle)
			}
		}
		
		return (swarm,map)
	}

	private class func separateObjectStringsFromTextFile(text: String) -> [String] {
        var hasReachedHashtag = false
        var isWithinParentheses = false
        var stringOfObject = ""
        var arrayOfObjects = [String]()
        for i in text.characters {
            if (!hasReachedHashtag){
                if (i == "("){
                    isWithinParentheses = true
                    stringOfObject.append(i)
                } else if (i == "#"){
                    hasReachedHashtag = true
                } else if (i == ")"){
                    stringOfObject.append(i)
                    arrayOfObjects.append(stringOfObject)
                    stringOfObject = ""
                    isWithinParentheses = false
                } else if (isWithinParentheses){
                    stringOfObject.append(i)
                }
                
            } else {
                if (i != ";"){
                    stringOfObject.append(i)
                } else {
                    arrayOfObjects.append(stringOfObject)
                    stringOfObject = ""
                }
            }
            
        }
		
		return arrayOfObjects
	}
	
	private class func stringRepresentsRobot(rep: String) -> Bool {
        var countComma = 0
        for i in rep.characters {
            if (i == ",") {
                countComma += 1
            }
        }
		
		return countComma == 1
	}
	
	private class func separateObstacleStringIntoCoordinates(rep: String) -> [String] {
		
        return separateCoordinateListString(rep: rep)
	}
	
	private class func createRobotFromString(rep: String) -> SVRobot {
		
		let coordinates = convertStringToCoordinates(rep: rep)
		
		return SVRobot(x:coordinates.x, y:coordinates.y)
	}
	
	private class func createObstacleFromString(rep: String) -> SVObstacle {
		
		let points = separateObstacleStringIntoCoordinates(rep: rep)
		var coords = [(Double,Double)]()
		for point in points {
			coords.append(convertStringToCoordinates(rep: point))
		}
        
		return SVObstacle(coordinates: coords)
	}
	

}
