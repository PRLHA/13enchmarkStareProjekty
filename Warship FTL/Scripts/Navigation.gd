extends Node

#aStar
onready var astar_node = AStar2D.new() #MAY CAUSE MEMORY LEAK <-- REMOVE THIS NODE
var NavNodes = []

#testing purposes
var PathPoints = PoolVector2Array() 
onready var line_2d : Line2D = $"../Line2D"

#jednostki
onready var selected_unit : KinematicBody2D = $"../Crew/Crewman"
onready var g_manager = $"../.."



func _ready():
	line_2d.global_position = Vector2.ZERO #global_position + warship offset <- mozliwe ze wymagana poprawka
	
	#Zbieranie poszczegolnych navnodes
	var children = []
	children = get_children()
	var counter = 0
	
	#for child in children:
	#	print("FTW " + child.name)
	
	for child in children:
		var Temp = child.nav_nodes
		for navnode in Temp:
			NavNodes.append(navnode)
			navnode.NavnodeID = counter
			astar_node.add_point(counter, navnode.global_position)
			#navnode.global_position + warship offset <- mozliwe ze wymagana poprawka
			counter += 1
		Temp = child.hatch_nodes
		for navnode in Temp:
			NavNodes.append(navnode)
			navnode.NavnodeID = counter
			astar_node.add_point(counter, navnode.global_position)
			#navnode.global_position + warship offset <- mozliwe ze wymagana poprawka
			counter += 1
		Temp = child.connections
		for connection in Temp:
			print(child.name + " connecting to hatch ")
			child.connect_to_hatch(connection)
	#Laczenie Navnode w siatke nawigacyjna
	
	var cur_node
	for navnode in NavNodes:
		print(navnode.get_parent().get_parent().name + " " + navnode.name)
		if navnode.get_node("../..").name == "Gun_turret2":
			#print("FOUND YA")
			print(navnode.connections)
		
		for i in navnode.connections.size():
			cur_node = navnode.get_node(navnode.connections[i])
			if not astar_node.are_points_connected(navnode.NavnodeID, cur_node.NavnodeID):
				astar_node.connect_points(navnode.NavnodeID, cur_node.NavnodeID)
				
				#print("DRAW LINE " + navnode.get_node("../..").name + " " + cur_node.get_node("../..").name) #BUG TESTING
				#print(navnode.global_position)
				#print(cur_node.global_position)
	
	PathPoints.append_array(astar_node.get_point_path(3, 6))
	line_2d.points = PathPoints

func find_path(from_pos : Vector2, to_pos : Vector2):
	var from_navnode
	var to_navnode
	from_navnode = astar_node.get_closest_point(from_pos)
	to_navnode = astar_node.get_closest_point(to_pos)
	var pathIDs = PoolVector2Array()
	pathIDs = astar_node.get_point_path(from_navnode, to_navnode) #temporary
	return pathIDs
	


#func _process(delta):
#	pass
