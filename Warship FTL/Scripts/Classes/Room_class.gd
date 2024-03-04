extends Polygon2D

class_name ShipRoom, "res://room_icon.png"

signal room_selected(my_scene)
var gui_scene = null

var units_inside = []
var nav_nodes = [] setget , _get_navnodes
var hatch_nodes = [] setget , _get_hatchnodes
export (Array, NodePath) var connection_FU = []
var connections = []
onready var g_manager = $"../../.."


var allready_connected_to = [] setget , _get_alcon #hard on memory, easy on CPU

func show_ui():
	return false

func _ready():
	if show_ui():
		connect("room_selected", g_manager, "testing_ui", [self])
	
	for i in connection_FU.size():
		connections.append(connection_FU[i])
	$Area2D/CollisionPolygon2D.polygon = polygon
	$Area2D/CollisionPolygon2D.position = offset #<-- F U OFFSET
	$Area2D.connect("body_entered",self,"_on_Area2D_body_entered")
	$Area2D.connect("body_exited",self,"_on_Area2D_body_exited")
	$Area2D.collision_layer = 4
	connect_navnodes()

func connect_to_hatch(target_room_path : NodePath): #CONNECTING ROOMS (CAUTION MAY REQUIRE AN UPGREADE)
	var target_room = get_node(target_room_path) #double caution - may cause pathfinding mesh bugs
	
	if target_room.allready_connected_to.has(self):
		return
	if allready_connected_to.has(target_room):
		return
	if not target_room.connections.has(self.get_path()):
		print("OMGWTFBBQ")
	
	var distances = []
	for hatch in target_room.hatch_nodes:
		distances.append(global_position.distance_squared_to(hatch.global_position))
	
	
	# STUPID, INEFFICIENT, BUT WORKS! So, get lost
	var minimal = distances.min()
	var closest_hatch_on_target_room = target_room.hatch_nodes[distances.find(minimal)]  #MY EYES HURT PLEASE HELP!!! O.O
	
	distances = []
	for hatch in hatch_nodes:
		distances.append(closest_hatch_on_target_room.global_position.distance_squared_to(hatch.global_position))
		# ^^ MY EYES!!
	
	minimal = distances.min()
	var closest_hatch_on_my_room = hatch_nodes[distances.find(minimal)]
	closest_hatch_on_my_room.connections.append(closest_hatch_on_target_room.get_path())
	closest_hatch_on_target_room.connections.append(closest_hatch_on_my_room.get_path())
	
	if closest_hatch_on_my_room.connections.size() > 2:
		print("")
	
	allready_connected_to.append(target_room)
	target_room.allready_connected_to.append(self)

func connect_navnodes():
	nav_nodes = $Positions.get_children()
	hatch_nodes = $Doors.get_children()

var displaying_ui = false

func select_this_room(you, gui_attachment, deselect := false):
	if deselect:
		if not gui_attachment.get_child_count() == 0:
			gui_attachment.get_child(0).queue_free()
		you.selected_room = null
	if show_ui():
		update_ui(gui_attachment)
	else:
		print("NO GUI")
		if not gui_attachment.get_child_count() == 0:
			gui_attachment.get_child(0).queue_free()
	you.selected_room = self

func deselect_room():
	displaying_ui = false

func update_ui(gui_attachment):
	print("gui up1")
	if gui_scene == null:
		print("resource not loaded")
		if not gui_attachment.get_child_count() == 0:
			gui_attachment.get_child(0).queue_free()
		return
	print("gui up2")
	if not gui_attachment.get_child_count() == 0:
		gui_attachment.get_child(0).queue_free()
	var spawned_scene = gui_scene.instance()

	gui_attachment.add_child(spawned_scene)
	#displaying_ui = true


func _on_Area2D_body_entered(body):
	units_inside.append(body)
	emit_signal("room_selected")
	print(units_inside)


func _on_Area2D_body_exited(body):
	units_inside.erase(body)


func _get_navnodes():
	return nav_nodes

func _get_hatchnodes():
	return hatch_nodes

func _get_alcon():
	return allready_connected_to
