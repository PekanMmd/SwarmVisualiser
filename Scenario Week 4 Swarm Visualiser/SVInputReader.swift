//
//  SVInputReader.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVInputReader: NSObject {
	
	class func readInput(inputFilename : String) -> SVInstance {
		
		let input = getTextFromInputFile(filename: inputFilename)
		let objects = separateObjectStringsFromTextFile(text: input)
		
		var swarm = SVSwarm()
		var map = SVMap()
		
		for object in objects {
			if stringRepresentsRobot(rep: object) {
				let robot = createRobotFromString(rep: object)
				swarm.append(robot)
			} else {
				let obstacle = createObstacleFromString(rep: object)
				map.append(obstacle)
			}
		}
		
		return (swarm,map)
	}
	
	private class func getTextFromInputFile(filename: String) -> String {
        var contents = ""
		
		do {
			contents = try String(contentsOfFile: filename)
		} catch {
			print("Something went wrong. The input file could not be found!")
		}
	
        return contents
	}

	private class func separateObjectStringsFromTextFile(text: String) -> [String] {
        var countHashtag = 0
        var countComma = 0
        var stringOfObject = ""
        var arrayOfObjects = [String]()
        for i in text.characters {
            if(countHashtag == 0){
                if(i == "("){
                    countComma = 0
                    stringOfObject.append(i)
                } else if (i == "#"){
                    countHashtag = 1
                } else if(i == ")"){
                    stringOfObject.append(i)
                    arrayOfObjects.append(stringOfObject)
                    stringOfObject = ""
                    countComma = 1
                } else if (countComma < 1){
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
            if(i == ",") {
                countComma = countComma + 1
            }
        }
        
        if (countComma == 1){
            return true
        }
        return false
	}
	
	private class func createRobotFromString(rep: String) -> SVRobot {
        
        var xcoordinateString = ""
        var ycoordinateString = ""
        var comma = 0
        
        for i in rep.characters {
            if (i == ","){
                comma = 1
            }
            if (i != "(" && comma == 0){
                xcoordinateString.append(i)
            } else if (i != ")" && comma == 1 && i != "," && i != " "){
                ycoordinateString.append(i)
            }
        }
        
       
		
        let xcoordinate = Double(xcoordinateString)
        let ycoordinate = Double(ycoordinateString)
        
        
		return SVRobot(x:(xcoordinate)!,y:(ycoordinate)!)
	}
	
	private class func createObstacleFromString(rep: String) -> SVObstacle {
        
        var xcoordinate: Double
        var ycoordinate: Double
        var xcoordinateString = ""
        var ycoordinateString = ""
        var comma = 0
        
        for i in rep.characters {
            if (i == ","){
                comma = comma + 1
            }
            if (i != "(" && comma == 0){
                xcoordinateString.append(i)
            }
            if (i == "("){
                comma = 0
            }
            if(i == ")") {
                comma = 1
                xcoordinate = Double(xcoordinateString)!
                ycoordinate = Double(ycoordinateString)!
                print("x:", xcoordinate)
                print("y:", ycoordinate)
                xcoordinateString = ""
                ycoordinateString = ""

                
            }
            if (i != ")" && comma == 1 && i != "," && i != " "){
                ycoordinateString.append(i)
            }
        }
        
		return SVObstacle(coordinates: [(x:0,y:0)])
	}
	

}
