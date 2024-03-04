extends KinematicBody2D

var path : = PoolVector2Array()# setget set_path		#setget = do this func when changed
export (int) var speed : = 50
var current_navmesh
var GManager

func _ready():
	current_navmesh = $"../../Rooms"
	GManager = $"../../.."

func move_order(destination : Vector2):
	path = current_navmesh.find_path(global_position, destination)
	if path.size() == 0:
		return
	if path.size() > 1:
		if abs(path[0].angle_to_point(path[1]) - path[0].angle_to_point(global_position)) < 0.1:
			path.remove(0)
	set_process(true)


func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return
	if path.size() > 1:
		if path[0].angle_to_point(path[1]) == path[0].angle_to_point(global_position):
			path.remove(0)
	set_process(true)

func _process(delta):
	var move_distance = speed * delta
	move_along_path(move_distance)

func move_along_path(distance : float):
	var start_point : = global_position
	for i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance > 0.0:
			global_position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			global_position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		print(path[0])
		path.remove(0)




func _on_Area2D_input_event(viewport, event, shape_idx):
	#print("dropped a2d")
	if not event is InputEventMouseButton:
		return
	if event.button_index == BUTTON_LEFT:
		print("dropped ftw")
		GManager.selected = []
		GManager.selected.push_back(self)
