//
//  SVProblemSolver.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 21/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

class SVProblemSolver: NSObject {

	var instance : SVInstance!
	
	var pathTable = SVPathTable()
	
	init(instance: SVInstance) {
		super.init()
		self.instance = instance
	}
	
	func createPathTable() {
//		for robot in instance.swarm {
//			
//			var pathArray = [SVPath]()
//			for target in instance.swarm {
//				let path = getShortestPathBetweenTwoRobots(r1: robot, r2: target)
//				pathArray.append(path)
//			}
//			
//			pathTable.append(pathArray)
//			
//		}
		
	}
	
	func calculateShortestPathBetweenTwoCoordinates(co1: CGPoint, co2: CGPoint) -> SVPath {
		//TODO: implement with obstacles
		return [co2]
	}
	
	func getShortestPathBetweenTwoCoordinatesFromTable(co1: CGPoint, co2: CGPoint) -> SVPath {
		
//		var index1 : Int!
//		var index2 : Int!
//		
//		for i in 0 ..< instance.swarm.count {
//			
//			if instance.swarm[i].start == co1 {
//				index1 = i
//			}
//			
//			if instance.swarm[i].start == co2 {
//				index2 = i
//			}
//			
//		}
//		
//		if (index1 == nil) || (index2 == nil) {
//			return []
//		}
//		
//		return pathTable[index1!][index2!]
		return []
	}
	
	func getShortestPathBetweenTwoRobots(r1: SVRobot, r2: SVRobot) -> SVPath {
		return getShortestPathBetweenTwoCoordinatesFromTable(co1: r1.current, co2: r2.current)
	}
	
	
	/* k-cluster algorithm
	
	let k be the number of clusters
	let n be the number of robots
	
	Gives a sub-optimal solution in O(n^2) time

	1. calculate shortest path from each robot's coordinates to each of the other robots' coordinates in a n x n table
	2. divide map into k x k clusters
	3. starting robot adds closest robot to its path, moves to it and makes it active
	4. for each active robot:
		- if no active robot in its cluster is targeting a robot in a different cluster then target a robot in a different cluster
		- else if there are no inactive or untargeted robots in this cluster and another cluster is untargeted then target closest robot in closest untargeted cluster
		- else if there is an inactive and untargeted robot in this cluster then target the closest one
		- else if it is the closest (active or targeted) robot to an inactive robot in any cluster then target it
	5. for each robot targeting another, add the path to that target to its path, move to the target's position and activate the target.
	6. untarget all robots
	7. repeat until all robots are active
	8. for each robot with a path longer than 1, add its path to the solution
	
	*/
	
	var clusters = [SVCluster]()
	
	func divideIntoKClusters(k: Int) {
		//TODO: implement
	}
	
	func minXForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func minYForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func maxXForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func maxYForCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func robot(robot r: SVRobot, isInCluster cluster: SVCluster) {
		//TODO: implement
	}
	
	func robotsInCluster(cluster: SVCluster) {
		//TODO: implement
	}
	
	func clusterHasBeenTargeted(cluster: SVCluster) {
		//TODO: implement
	}
	
	func robotHasBeenTargeted(robot: SVRobot) {
		//TODO: implement
	}
	
	func clusterHasBeenCompleted(cluster: SVCluster) {
		//TODO: implement
	}
	
	func robot(robot: SVRobot, closestUntargetedRobotInCluster cluster: SVCluster) {
		//TODO: implement
	}
	
	
	
	
	func solveByKCluster(k: Int) {
		//TODO: implement
	}
	
	
	
	
}
