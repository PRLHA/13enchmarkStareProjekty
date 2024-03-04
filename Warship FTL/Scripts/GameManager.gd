extends Node2D

onready var camera : Camera2D = $Camera2D
onready var testSprite : Sprite = $Test
onready var gui_node = $CanvasLayer/GUI/VBoxContainer/NinePatchRect

var selected = []
var selected_room

#onready var gun = $Warship/Rooms/Gun_turret1

func _ready():
	pass # Replace with function body.
	#$Warship/Rooms/Gun_turret2.connect("room_selected", self, "testing_ui")
	

func testing_ui(parameter):
	print("THIS FUCKING THING WORKS! - " + parameter.name)
	parameter.update_ui(gui_node)

func _physics_process(delta):
	var space = get_world_2d().direct_space_state
	var mousePos = get_global_mouse_position()
	var cell
	var ex_array = []
	ex_array.append("Units")
	if space.intersect_point(mousePos, 1, ex_array, 2, false, true):
		cell = space.intersect_point(mousePos, 1, ex_array, 2, false, true)
		print(cell[0].collider.name)
	else:
		cell = null

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index == BUTTON_LEFT:
		return
		#if event.pressed:
		#	selected = []
		#	var querry = Physics2DShapeQueryParameters
	var screen_center = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) #temp
	var click_pos =  event.position + camera.global_position - screen_center
	testSprite.position = click_pos#Vector2(512, 300)
	
	if event.button_index == BUTTON_RIGHT:
		if selected.empty():
			return
		var space = get_world_2d().direct_space_state
		
		#var ex_array = []
		#ex_array.append("Units") #WORK IN PROGRESS, REPLACE WITH COLISION MASK ASAP!!!
		if not selected_room == null:
			selected_room.deselect_room()
		
		var target_room = space.intersect_point(click_pos, 4, ["Units"], 4, false, true)
		if target_room.empty():
			print("empty")
			return #RE-ADD LATER
		else:
			target_room = target_room[0].collider.get_parent()
			target_room.select_this_room(self, gui_node)
			print(target_room.name)
		
		print(event.global_position)
		print(camera.global_position)
		
		for unit in selected:
			unit.move_order(click_pos) #2REMOVE


func _on_Gun_turret2_room_selected(my_scene):
	pass # Replace with function body.
