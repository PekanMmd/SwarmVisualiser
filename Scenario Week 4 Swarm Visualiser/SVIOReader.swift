//
//  SVIOReader.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 21/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVIOReader {
	
	class func getTextFromInputFile(filename: String) -> String {
		var contents = ""
		do {
			contents = try String(contentsOfFile: filename)
		} catch {
			print("Something went wrong. The ouput file could not be found!")
		}
		
		return contents
	}

	class func convertStringToCoordinates(rep: String) -> (x:Double, y:Double) {
		
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
		
		let xcoordinate = Double(xcoordinateString) ?? 0
		let ycoordinate = Double(ycoordinateString) ?? 0
		
		return ((xcoordinate + 10)*50,(ycoordinate + 10) * 50)
	}
	
	class func separateStringBySemiColons(rep: String) -> [String] {
		
        var isWithinParentheses = false
        var stringOfObject = ""
        var arrayOfObjects = [String]()
        for i in rep.characters {
            if(i != ";") {
                if (i == "("){
                    isWithinParentheses = true
                    stringOfObject.append(i)
                } else if (i == ")"){
                    stringOfObject.append(i)
                    arrayOfObjects.append(stringOfObject)
                    stringOfObject = ""
                    isWithinParentheses = false
                } else if (isWithinParentheses){
                    stringOfObject.append(i)
                }
            }
                
            else {
                    arrayOfObjects.append(stringOfObject)
                    stringOfObject = ""
                
            }
            
        }

		print(arrayOfObjects)
		
		return arrayOfObjects
    }
	
}













