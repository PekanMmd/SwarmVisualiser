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
	
	func pointsFromEdge(edge: SVEdge) -> [SVPoint] {
		return [edge.0,edge.1]
	}
	
	func pointsFromEdges(edges: [SVEdge]) -> [SVPoint] {
		var points = [SVPoint]()
		
		for edge in edges {
			points += pointsFromEdge(edge: edge)
		}
		
		return points
	}
	
	func minMaxXForEdge(edge: SVEdge) -> (Double, Double) {
		let minx = min(edge.0.x, edge.1.x)
		let maxx = max(edge.0.x, edge.1.x)
		return (minx,maxx)
	}
	
	func lineIsHorizontal(line: SVEdge) -> Bool {
		return line.0.y == line.1.y
	}
	
	func lineIsVertical(line: SVEdge) -> Bool {
		return line.0.x == line.1.x
	}
	
	
	func checkPointsForLine(edge: SVEdge) -> (SVPoint, SVPoint) {
		
		let checkThreshold : Double = 0.01
		
		let dx : Double = edge.1.x - edge.0.x
		let dy : Double = edge.1.y - edge.0.y
		
		let minX = dx * checkThreshold + edge.0.x
		let minY = dy * checkThreshold + edge.0.y
		
		let maxX = edge.1.x - dx * checkThreshold
		let maxY = edge.1.y - dy * checkThreshold
		
		return (SVPoint(x: minX, y: minY), SVPoint(x: maxX, y: maxY))
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
		
		let checkpoints = checkPointsForLine(edge: line)
		
		let checkpoint = checkpoints.0
		let checkpoint2 = checkpoints.1
		
		let yVal = checkpoint.y
		
		let minMax = minMaxXForPolygon(polygon: polygon)
		let horizon : SVEdge = (SVPoint(x: minMax.0, y: yVal),SVPoint(x: minMax.1, y: yVal))
		let horizon2 : SVEdge = (SVPoint(x: minMax.0, y: checkpoint2.y),SVPoint(x: minMax.1, y: checkpoint2.y))
		
		var intersects = [Double?]()
		var intersects2 = [Double?]()
		
		for edge in edges {
			intersects.append(xCoordWhereLine(line: horizon, IntersectsEdge: edge))
			intersects2.append(xCoordWhereLine(line: horizon2, IntersectsEdge: edge))
		}
		
		intersects = intersects.filter { (p) -> Bool in
			return p != nil
		}
		
		intersects = intersects.sorted { (p1, p2) -> Bool in
			return p1! < p2!
		}
		
		intersects2 = intersects2.filter { (p) -> Bool in
			return p != nil
		}
		
		intersects2 = intersects2.sorted { (p1, p2) -> Bool in
			return p1! < p2!
		}
		
		if (intersects.count == 0) && (intersects2.count == 0) {
			return false
		}
		
		var leftNodesCount = 0
		var leftNodesCount2 = 0
		
		for p in intersects {
			if p! < checkpoint.x {
				leftNodesCount += 1
			}
		}
		
		for p in intersects2 {
			if p! < checkpoint2.x {
				leftNodesCount2 += 1
			}
		}
		
		return (leftNodesCount % 2 != 0) || (leftNodesCount2 % 2 != 0)
		
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
			
			if (Xa == edge.0.x) || (Xa == edge.0.x) {
				return nil
			}
			
			return Xa
			
		} else if A2 == nil {
			Xa = edge.0.x
			
			if (Xa == line.0.x) || (Xa == line.1.x) {
				return nil
			}
			
			return Xa
			
		} else {
			
			b1 = line.0.y - (A1 * line.0.x)
			b2 = edge.0.y - (A2 * edge.0.x)
			
			Xa = (b2 - b1) / (A1 - A2)
			
			if compareDoubles(d1: Xa, d2: line.0.x) || compareDoubles(d1: Xa, d2: line.1.x) || compareDoubles(d1: Xa, d2: edge.0.x) || compareDoubles(d1: Xa, d2: edge.1.x) {
				return nil
			}
			
		}
		
		return ((Ia.0 < Xa) && (Xa < Ia.1)) ? Xa : nil
		
	}
	
	func doesLine(line: SVEdge, intersectEdge edge: SVEdge) -> Bool {
		
		return xCoordWhereLine(line: line, IntersectsEdge: edge) != nil
		
	}
	
	
	func edgesIntersectedByLine(line: SVEdge) -> [SVEdge] {
		var edges = [SVEdge]()
		
		for edge in allEdges {
			if doesLine(line: line, intersectEdge: edge) {
				edges.append(edge)
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
	
	func point(p1: SVPoint, isVisibleFromPoint p2: SVPoint) -> Bool {
		
		if  pointIsACorner(p: p1) && pointIsACorner(p: p2) {
			for polygon in instance.map {
				
				if polygon.contains(p1) && polygon.contains(p2) {
					if doesLine(line: (p1,p2), PassThroughPolygon: polygon) {
						return false
					}
				}
			}
		}
		
		for edge in allEdges {
			if doesLine(line: (p1,p2), intersectEdge: edge) {
				return false
			}
		}
		
		return true
		
	}
	
	func lineBetweenPointsClosestPointFromIntersectedPolygonsDirty(p1: SVPoint, p2: SVPoint) -> SVPoint? {
		
		let line = (p1,p2)
		var edges = edgesIntersectedByLine(line: line)
		
		for polygon in instance.map {
			var edgeList = [SVEdge]()
			
			for p in 0 ..< polygon.count - 1 {
				edgeList.append((polygon[p],polygon[p+1]))
			}
			
			edgeList.append((polygon.last!,polygon.first!))
			
			var polyAdded = false
			
			for edge in edgeList {
				
				if !polyAdded {
					
					for e in edges {
						if e == edge {
							edges += edgeList
							polyAdded = true
						}
					}
				}
			}
			
		}
		
		let points = pointsFromEdges(edges: edges)
		
		if points.count == 0 {
			return nil
		}
		
		for p in points {
			if point(p1: p, isVisibleFromPoint: p1) {
				return p
			}
		}
		
		return nil
	}
	
	func lineBetweenPointsClosestPointFromIntersectedPolygons(p1: SVPoint, p2: SVPoint, visited: [SVPoint]) -> SVPoint? {
		
		let line = (p1,p2)
		var edges = edgesIntersectedByLine(line: line)
		
		for polygon in instance.map {
			var edgeList = [SVEdge]()
			
			for p in 0 ..< polygon.count - 1 {
				edgeList.append((polygon[p],polygon[p+1]))
			}
			
			edgeList.append((polygon.last!,polygon.first!))
			
			var polyAdded = false
			
			for edge in edgeList {
				
				if !polyAdded {
					
					for e in edges {
						if e == edge {
							edges += edgeList
							polyAdded = true
						}
					}
				}
			}
			
		}
		
		var points = pointsFromEdges(edges: edges)
		
		if points.count == 0 {
			return nil
		}
		
		points = points.filter { (p) -> Bool in
			return !visited.contains(p)
		}
		
		points = points.filter({ (p:SVPoint) -> Bool in
			return point(p1: p, isVisibleFromPoint: p1)
		})
		
		if points.count == 0 {
			print("something went wrong...")
			return nil
		}
		
		points = points.sorted(by: { (point1:SVPoint, point2:SVPoint) -> Bool in
			return distanceBetweenPoints(p1: p2, p2: point1) < distanceBetweenPoints(p1: p2, p2: point2)
		})
		
		return points[0]
	}
	
	func pathBetweenPoints(p1: SVPoint, p2: SVPoint, optimised: Bool, visited: [SVPoint]) -> SVPath {
		var closestIntersect : SVPoint!
		
		if optimised {
			closestIntersect = lineBetweenPointsClosestPointFromIntersectedPolygons(p1: p1, p2: p2, visited: visited)
		} else {
			closestIntersect = lineBetweenPointsClosestPointFromIntersectedPolygonsDirty(p1: p1, p2: p2)
		}
		
		var path = [p2]
		
		if closestIntersect != nil {
			path = [closestIntersect!] + pathBetweenPoints(p1: closestIntersect!, p2: p2, optimised: optimised, visited: visited + [closestIntersect!])
		}
		
		pathTable.append((p1,p2,path))
		return path
		
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
					table.append((robot.start,target.start,pathBetweenPoints(p1: robot.start, p2: target.start, optimised: true, visited: [robot.start])))
				}
				
			}
		}
		return table
	}

}
