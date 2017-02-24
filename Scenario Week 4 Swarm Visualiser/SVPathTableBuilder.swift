//
//  SVPathTableBuilder.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 22/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

func compareDoubles(d1: Double, d2: Double) -> Bool {
	let kThreshold : Double = 0.000000001
	return (abs(d1 - d2) < kThreshold)
}

func ==(lhs: SVEdge, rhs: SVEdge) -> Bool {
	
	return ((lhs.0 == rhs.0) && (lhs.1 == rhs.1)) || ((lhs.1 == rhs.0) && (lhs.0 == rhs.1))
}

class SVPathTableBuilder: NSObject {
	
	var instance : SVInstance!
	var allEdges : [SVEdge]!
	var corners : [SVPoint]!
	
	var pathTable = SVPathTable()
	
	func pointIsACorner(p: SVPoint) -> Bool {
		for c in corners {
			if p == c {
				return true
			}
		}
		return false
	}
	
	func edgesFromPolygon(polygon: SVPolygon) -> [SVEdge] {
		var edges = [SVEdge]()
		for i in 0 ..< polygon.count - 1 {
			edges.append((polygon[i],polygon[i+1]))
		}
		edges.append((polygon.last!,polygon.first!))
		return edges
	}
	
	func edgesFromMap(map: SVMap) -> [SVEdge] {
		var edges = [SVEdge]()
		
		for obstacle in map {
			edges += edgesFromPolygon(polygon: obstacle)
		}
		
		return edges
	}
	
//	func pointsFromEdge(edge: SVEdge) -> [SVPoint] {
//		return [edge.0,edge.1]
//	}
	
	func pointsFromEdges(edges: [SVEdge]) -> [SVPoint] {
		var points = [SVPoint]()
		
		for edge in edges {
//			points += pointsFromEdge(edge: edge)
			points += [edge.0]
		}
		
		return points
	}
	
	func minMaxXForEdge(edge: SVEdge) -> (Double, Double) {
		let minx = min(edge.0.x, edge.1.x)
		let maxx = max(edge.0.x, edge.1.x)
		return (minx,maxx)
	}
	
	func minMaxYForEdge(edge: SVEdge) -> (Double, Double) {
		let miny = min(edge.0.y, edge.1.y)
		let maxy = max(edge.0.y, edge.1.y)
		return (miny,maxy)
	}
	
	func lineIsHorizontal(line: SVEdge) -> Bool {
		return line.0.y == line.1.y
	}
	
	func lineIsVertical(line: SVEdge) -> Bool {
		return line.0.x == line.1.x
	}
	
	
	func checkPointsForLine(edge: SVEdge, number: Double) -> [SVPoint] {
		
		let checkThreshold : Double = 1.0 / number
		
		let dx : Double = edge.1.x - edge.0.x
		let dy : Double = edge.1.y - edge.0.y
		var points = [SVPoint]()
		
		for i in Int(number/kIntersectionSkip) ..< (Int(number) - Int(number/kIntersectionSkip)) {
			
			let midX = dx * checkThreshold * Double(i) + edge.0.x
			let midY = dy * checkThreshold * Double(i) + edge.0.y
			
			points.append(SVPoint(x: midX, y: midY))
		}
		
		return points
	}

	func minMaxXForPolygon(polygon: SVPolygon) -> (Double, Double) {
		
		var minx = polygon[0].x
		var maxx = polygon[0].x
		
		for p in polygon {
			if p.x < minx {
				minx = p.x
			}
			if p.x > maxx {
				maxx = p.x
			}
		}
		return (minx - 0.000001, maxx + 0.000001)
	}
	
	func point(point p: SVPoint, isInPolygon polygon: (SVPolygon,[SVEdge])) -> Bool {
		
		let yVal = p.y
		
		let minMax = minMaxXForPolygon(polygon: polygon.0)
		let horizon : SVEdge = (SVPoint(x: minMax.0, y: yVal),SVPoint(x: minMax.1, y: yVal))
		
		var intersects = [Double?]()
		
		for edge in polygon.1 {
			intersects.append(xCoordWhereLine(line: horizon, IntersectsEdge: edge))
		}
		
		intersects = intersects.filter { (p) -> Bool in
			return p != nil
		}
		
		intersects = intersects.sorted { (p1, p2) -> Bool in
			return p1! < p2!
		}
		
		if intersects.count == 0 {
			return false
		}
		
		var leftNodesCount = 0
		
		for point in intersects {
			if point! == p.x {
				return false
			}
			if point! < p.x {
				leftNodesCount += 1
			}
		}
		
		return (leftNodesCount % 2) != 0
	}
	
	func doesLine(line: SVEdge, PassThroughPolygon polygon: SVPolygon) -> Bool {
		
		var edges = [SVEdge]()
		
		for p in 0 ..< polygon.count - 1 {
			edges.append((polygon[p],polygon[p+1]))
		}
		
		edges.append((polygon.last!,polygon.first!))
		
		for edge in edges {
			if line == edge {
				return false
			}
		}
		
		for edge in edges {
			if doesLine(line: line, intersectEdge: edge) {
				return true
			}
		}
		
		let checkpoints = checkPointsForLine(edge: line, number: kIntersectionGradation)
		
		for checkpoint in checkpoints {
			
			if point(point: checkpoint, isInPolygon: (polygon,edges)) {
				return true
			}
			
		}
		
		return false
		
	}
	
	func xCoordWhereLine(line: SVEdge, IntersectsEdge edge: SVEdge) -> Double? {
		
		if (line.0 == edge.0) || (line.1 == edge.0) || (line.0 == edge.1) || (line.1 == edge.1) {
			return nil
		}
		
		if max(line.0.x, line.1.x) < min(edge.0.x, edge.1.x) {
			return nil
		}
		
		if max(edge.0.x, edge.1.x) < min(line.0.x, line.1.x) {
			return nil
		}
		
		if max(line.0.y, line.1.y) < min(edge.0.y, edge.1.y) {
			return nil
		}
		
		if max(edge.0.y, edge.1.y) < min(line.0.y, line.1.y) {
			return nil
		}
		
		let I1 = minMaxXForEdge(edge: line)
		let I2 = minMaxXForEdge(edge: edge)
		
		let Ia = ( max(I1.0, I2.0), min(I1.1, I2.1) )
		
		var A1 : Double!
		var A2 : Double!
		var b1 : Double = 0
		var b2 : Double = 0
		
		if !lineIsVertical(line: line) {
			A1 = (line.0.y - line.1.y) / (line.0.x - line.1.x)
		}
		
		if !lineIsVertical(line: edge) {
			A2 = (edge.0.y - edge.1.y) / (edge.0.x - edge.1.x)
		}
		
		if  A1 == A2 {
			return nil
		}
		
		var Xa : Double!
		
		if A1 == nil {
			Xa = line.0.x
			
			if (compareDoubles(d1: Xa, d2: edge.0.x)) || (compareDoubles(d1: Xa, d2: edge.1.x)) {
				return nil
			}
			
			b2 = edge.0.y - (A2 * edge.0.x)
			let y = A2 * Xa + b2
			let Iy = minMaxYForEdge(edge: line)
			
			return (Iy.0 < y) && (y < Iy.1) ? Xa : nil
			
		} else if A2 == nil {
			Xa = edge.0.x
			
			if (compareDoubles(d1: Xa, d2: line.0.x)) || (compareDoubles(d1: Xa, d2: line.1.x)) {
				return nil
			}
			
			b1 = line.0.y - (A1 * line.0.x)
			let y = A1 * Xa + b1
			let Iy = minMaxYForEdge(edge: edge)
			
			return (Iy.0 < y) && (y < Iy.1) ? Xa : nil
			
		} else {
			
			b1 = line.0.y - (A1 * line.0.x)
			b2 = edge.0.y - (A2 * edge.0.x)
			
			Xa = (b2 - b1) / (A1 - A2)
			
		}
		
		if (compareDoubles(d1: Xa, d2: line.0.x)) || (compareDoubles(d1: Xa, d2: line.1.x)) || (compareDoubles(d1: Xa, d2: edge.0.x)) || (compareDoubles(d1: Xa, d2: edge.1.x)) {
			return nil
		}
		
		
		return ((Ia.0 < Xa) && (Xa < Ia.1)) ? Xa : nil
		
	}
	
	func doesLine(line: SVEdge, intersectEdge edge: SVEdge) -> Bool {
		
		let xcoord = xCoordWhereLine(line: line, IntersectsEdge: edge)
		
		return xcoord != nil
		
	}
	
	
	func edgesIntersectedByLine(line: SVEdge) -> [SVEdge] {
		var edges = [SVEdge]()
		
		for edge in allEdges {
			if doesLine(line: line, intersectEdge: edge) {
				edges.append(edge)
			}
		}
		
		for polygon in instance.map {
			if doesLine(line: line, PassThroughPolygon: polygon) {
				for edge in edgesFromPolygon(polygon: polygon) {
					edges.append(edge)
				}
			}
		}
		
		return edges
	}
	
	func distanceBetweenPoints(p1: SVPoint, p2: SVPoint) -> Double {
		
		let maxx = max(p1.x,p2.x)
		let minx = min(p1.x,p2.x)
		let maxy = max(p1.y,p2.y)
		let miny = min(p1.y,p2.y)
		
		let dx = Double(maxx - minx)
		let dy = Double(maxy - miny)
		
		let dx2 = pow(dx,2)
		let dy2 = pow(dy,2)
		
		return sqrt(dx2 + dy2)
	}
	
	func pointsAreOnSamePolygon(p1: SVPoint, p2: SVPoint) -> Bool {
		
		for polygon in instance.map {
			
			var edges = [SVEdge]()
			
			for p in 0 ..< polygon.count - 1 {
				edges.append((polygon[p],polygon[p+1]))
			}
			
			edges.append((polygon.last!,polygon.first!))
			
			var m1 = false
			var m2 = false
			
			for edge in edges {
				if point(point: p1, impingesOnEdge: edge) {
					m1 = true
				}
				if point(point: p2, impingesOnEdge: edge) {
					m2 = true
				}
				
			}
			return m1 && m2
		}
		return false
		
	}
	
	func cornersAreOnSamePolygon(p1: SVPoint, p2: SVPoint) -> Bool {
		
		for obstacle in instance.map {
			var match1 = false
			var match2 = false
			
			for p in obstacle {
				if p == p1 {
					match1 = true
				}
				if p == p2 {
					match2 = true
				}
			}
			if match1 && match2 {
				return true
			}
		}
		return false
		
	}
	
	func pointsAreOnSameEdge(p1: SVPoint, p2: SVPoint) -> Bool {
		
		for edge in allEdges {
			
			if point(point: p1, impingesOnEdge: edge) && point(point: p2, impingesOnEdge: edge) {
				return true
			}
			
		}
		return false
		
	}
	
	func point(point: SVPoint, impingesOnEdge edge: SVEdge) -> Bool {
		
		if (point == edge.0) || (point == edge.1) {
			return true
		}
		
		if compareDoubles(d1: point.x, d2: min(edge.0.x, edge.1.x)) {
			return false
		}
		
		if compareDoubles(d1: point.x, d2: max(edge.0.x, edge.1.x)) {
			return false
		}
		
		if compareDoubles(d1: point.y, d2: min(edge.0.y, edge.1.y)) {
			return false
		}
		
		if compareDoubles(d1: point.y, d2: max(edge.0.y, edge.1.y)) {
			return false
		}
		
		if point.x < min(edge.0.x, edge.1.x) {
			return false
		}
		
		if max(edge.0.x, edge.1.x) < point.x {
			return false
		}
		
		if point.y < min(edge.0.y, edge.1.y) {
			return false
		}
		
		if max(edge.0.y, edge.1.y) < point.y {
			return false
		}
		
		var A1 : Double!
		
		if !lineIsVertical(line: edge) {
			A1 = (edge.0.y - edge.1.y) / (edge.0.x - edge.1.x)
		}
		
		var Xa : Double!
		
		if A1 == nil {
			Xa = edge.0.x
			
			if !compareDoubles(d1: point.x, d2: Xa) {
				return false
			}
			
			let y = point.y
			let Iy = minMaxYForEdge(edge: edge)
			
			if compareDoubles(d1: point.y, d2: Iy.0) || compareDoubles(d1: point.y, d2: Iy.1) {
				return true
			}
			
			return (Iy.0 <= y) && (y <= Iy.1)
			
		} else {
			
			let x = point.x
			let y = point.y
			
			let m = A1!
			let c = edge.0.y - (m * edge.0.x)
			
			//y = mx + c
			return compareDoubles(d1: y, d2: (m * x + c))
			
		}
		
	}
	
	func point(p1: SVPoint, isVisibleFromPoint p2: SVPoint, prioritiseAdjacents adj: Bool) -> Bool {
		
		if adj {
			if pointsAreOnSamePolygon(p1: p1, p2: p2) {
				return pointsAreOnSameEdge(p1: p1, p2: p2)
			}
		} else if corners.contains(p1) && corners.contains(p2) {
			if pointsAreOnSameEdge(p1: p1, p2: p2) {
				return true
			}
		}
		
		for polygon in instance.map {
			if doesLine(line: (p1,p2), PassThroughPolygon: polygon) {
				return false
			}
		}
		
		for edge in allEdges {
			if doesLine(line: (p1,p2), intersectEdge: edge) {
				return false
			}
		}
		
		return true
		
	}
	
	func edgesFromObstacle(obstacle: SVObstacle) -> [SVEdge] {
		
		var edges = [SVEdge]()
		
		for p in 0 ..< obstacle.count - 1 {
			edges.append((obstacle[p],obstacle[p+1]))
		}
		
		edges.append((obstacle.last!,obstacle.first!))
		
		return edges
		
	}
	
	
	func lineBetweenPointsClosestPointsFromIntersectedPolygons(p1: SVPoint, p2: SVPoint, visited: [SVPoint]) -> [SVPoint]? {
		
		let line = (p1,p2)
		var edges = edgesIntersectedByLine(line: line)
		var polyedges = [SVEdge]()
		
		for ob in instance.map {
			
			let edgeList = edgesFromObstacle(obstacle: ob)
			
			for edge in edgeList {
				if point(point: p2, impingesOnEdge: edge) {
					edges = edges + [edge]
				}
				if point(point: p1, impingesOnEdge: edge) {
					edges = edges + [edge]
				}
			}
			
		}
	
		for polygon in instance.map {
			var edgeList = [SVEdge]()
			
			for p in 0 ..< polygon.count - 1 {
				edgeList.append((polygon[p],polygon[p+1]))
			}
			
			edgeList.append((polygon.last!,polygon.first!))
			
			var polyAdded = false
			
			if !polyAdded {
				for edge in edgeList {
					if !polyAdded {
						for e in edges {
							if !polyAdded {
								if e == edge {
									polyedges += edgeList
									polyAdded = true
								}
							}
						}
					}
				}
			}
		}
		edges = polyedges
		
		var points = pointsFromEdges(edges: edges)
		
		if points.count == 0 {
			print("something went wrong. back tracking...")
			return nil
		}
		
		points = points.filter { (p) -> Bool in
			return !visited.contains(p)
		}
		
		points = points.filter({ (p:SVPoint) -> Bool in
			return point(p1: p, isVisibleFromPoint: p1, prioritiseAdjacents: kPrioritiseAdjacentPaths)
		})
		
		if points.count == 0 {
			points = pointsFromEdges(edges: edges)
			
			points = points.filter { (p) -> Bool in
				return !visited.contains(p)
			}
			
			points = points.filter({ (p:SVPoint) -> Bool in
				return point(p1: p, isVisibleFromPoint: p2, prioritiseAdjacents: kPrioritiseAdjacentPaths)
			})
				
			points = points.sorted(by: { (point1:SVPoint, point2:SVPoint) -> Bool in
				return distanceBetweenPoints(p1: p2, p2: point1) < distanceBetweenPoints(p1: p2, p2: point2)
			})
			
		} else {
			points = points.sorted(by: { (point1:SVPoint, point2:SVPoint) -> Bool in
				return distanceBetweenPoints(p1: p2, p2: point1) < distanceBetweenPoints(p1: p2, p2: point2)
			})
		}
		
		return points
	}
	
	func onePointPathBetweenPoints(pointA : SVPoint, pointB: SVPoint, visited: [SVPoint]) -> SVPath! {
		var pathToIntersect : SVPath!
		
		for p in pointsFromEdges(edges: allEdges) {
			if visited.contains(p) {
				continue
			}
			if point(p1: pointA, isVisibleFromPoint: p, prioritiseAdjacents: false) {
				if point(p1: pointB, isVisibleFromPoint: p, prioritiseAdjacents: false) {
					pathToIntersect = [p,pointB]
					break
				}
			}
		}
		
		return pathToIntersect
	}
	
	
//	func nPointPathBetweenPoints(pointA : SVPoint, pointB: SVPoint) -> SVPath! {
//		var pathToIntersect : SVPath!
//		
//		for p in pointsFromEdges(edges: allEdges) {
//			if point(p1: pointA, isVisibleFromPoint: p, prioritiseAdjacents: false) {
//				if point(p1: pointB, isVisibleFromPoint: p, prioritiseAdjacents: false) {
//					pathToIntersect = [p,pointB]
//					break
//				}
//			}
//		}
//		
//		return pathToIntersect
//	}
	
	
	func pathBetweenPoints(p1: SVPoint, p2: SVPoint, optimised: Bool, visited: [SVPoint]) -> SVPath? {
		var closestIntersects : [SVPoint]!
		var path = [p2]
		
		for (pa,pb,path) in pathTable {
			if (p1 == pa) && (p2 == pb) {
				return path
			}
		}
		
		if pointsAreOnSameEdge(p1: p1, p2: p2) {
			path = [p2]
			pathTable.append((p1,p2,path))
			return path
		}
		
		if point(p1: p2, isVisibleFromPoint: p1, prioritiseAdjacents: kPrioritiseAdjacentPaths) {
			path = [p2]
			pathTable.append((p1,p2,path))
			return path
		}
		
		closestIntersects = lineBetweenPointsClosestPointsFromIntersectedPolygons(p1: p1, p2: p2, visited: visited)
		
		if closestIntersects == nil {
			print("uh oh...")
			return [p2]
		}
		
		for intersect in closestIntersects! {
			
			var pathToIntersect : SVPath!
			if point(p1: p1, isVisibleFromPoint: intersect, prioritiseAdjacents: false) {
				pathToIntersect = [intersect]
			} else {
				// find one step path to intersect
				let oneStop = onePointPathBetweenPoints(pointA: p1, pointB: intersect, visited: [])
				if oneStop != nil {
					pathToIntersect = oneStop!
				} else {
					for p in pointsFromEdges(edges: allEdges) {
						if pathToIntersect == nil {
							if !visited.contains(p) {
								let oneStop = onePointPathBetweenPoints(pointA: p1, pointB: intersect, visited: visited)
								if oneStop != nil {	pathToIntersect = pathBetweenPoints(p1: p1, p2: p, optimised: optimised, visited: visited + oneStop! + [p])
									if pathToIntersect != nil {
										pathToIntersect = pathToIntersect! + oneStop!
									}
								}
							}
						}
					}
				}
			}
			
			if pathToIntersect == nil {
				continue
			}
			
			var pathToAdd = pathBetweenPoints(p1: intersect, p2: p2, optimised: optimised, visited: visited + pathToIntersect!)
			
			if pathToAdd == nil {
				continue
			}
			
			pathToAdd = pathToIntersect! + pathToAdd!
			
			var furthestVisible = 0
			
			for p in 0 ..< pathToAdd!.count {
				if point(p1: pathToAdd![p], isVisibleFromPoint: p1, prioritiseAdjacents: false) {
					furthestVisible = p
				}
			}
			
			var optimisedPath = SVPath()
			for i in furthestVisible ..< pathToAdd!.count {
				optimisedPath.append(pathToAdd![i])
			}
			
			path = optimisedPath
			
			pathTable.append((p1,p2,path))
			return path
			
		}
		
		
		print("this is not the end of the world")
		return [p2]
		
	}
	
	init(instance: SVInstance) {
		super.init()
		
		self.instance = instance
		self.allEdges = edgesFromMap(map: instance.map)
		self.corners = pointsFromEdges(edges: allEdges)
	}
	
	func createTable(instance: SVInstance) -> SVPathTable {
		
		var table = SVPathTable()
		
		self.instance = instance
		self.allEdges = edgesFromMap(map: instance.map)
		self.corners = pointsFromEdges(edges: allEdges)
		
		for robot in instance.swarm {
			for target in instance.swarm {
				
				if robot.start != target.start {
					table.append((robot.start,target.start,pathBetweenPoints(p1: robot.start, p2: target.start, optimised: true, visited: [robot.start])!))
				}
				
			}
		}
		return table
	}

}
