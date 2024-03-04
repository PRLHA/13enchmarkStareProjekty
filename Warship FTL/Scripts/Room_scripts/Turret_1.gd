extends ShipRoom

enum shell_type {AP, HE}
var load_shell = shell_type.AP
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	gui_scene = preload("res://Scenes/Rooms/Room Guis/gun_gui.tscn")
	#self.connect("room_selected", g_manager, "testing_ui")

var ap_bar
var he_bar
var progress = 0
var loading_speed = 50

func _process(delta):
	progress += loading_speed * delta
	if progress > 100:
		progress = 100
	
	if displaying_ui:
		display_information_on_gui(delta)

func display_information_on_gui(delta):
	match load_shell:
		shell_type.AP:
			ap_bar.visible = true
			ap_bar.value = progress
			
			he_bar.visible = false
		shell_type.HE:
			he_bar.visible = true
			he_bar.value = progress
			
			ap_bar.visible = false
		_:
			he_bar.visible = false
			ap_bar.visible = false
		
	if progress == 100:
		he_bar.visible = false
		ap_bar.visible = false


func show_ui():
	return true

func connect_navnodes():
	nav_nodes = $Positions.get_children()
	hatch_nodes = $Doors.get_children()

func update_ui(gui_attachment): 
	print("gui up1")
	if gui_scene == null:
		print("resource not loaded")
		return
	print("gui up2")
	if not gui_attachment.get_child_count() == 0:
		gui_attachment.get_child(0).queue_free()
	var spawned_scene = gui_scene.instance()
	
	#REPLACE WITH FUNC
	spawned_scene.get_node(@"Ammo_Type/Load_AP/Load_Progress").value = 50
	spawned_scene.get_node(@"Fire_Trigger").connect("button_down", self, "animate")
	#spawned_scene.get_node(@"Fire_Trigger").connect("button_down", self, "animate")
	
	spawned_scene.get_node(@"Ammo_Type/Load_AP/AP_Button").connect("button_down", self, "change_shell", [shell_type.AP])
	spawned_scene.get_node(@"Ammo_Type/Load_HE/HE_Button").connect("button_down", self, "change_shell", [shell_type.HE])
	ap_bar = spawned_scene.get_node(@"Ammo_Type/Load_AP/Load_Progress")
	he_bar = spawned_scene.get_node(@"Ammo_Type/Load_HE/Load_Progress2")
	#REPLACE WITH FUNC
	
	gui_attachment.add_child(spawned_scene)
	displaying_ui = true

func animate():
	if progress == 100:
		$AnimationPlayer.play("Fire")
		progress = 0
	else:
		print("LOADING IN PROGRESS")

func change_shell(loaded_shell_type):
	match loaded_shell_type:
		shell_type.AP:
			print("LOAD AP")
			load_shell = shell_type.AP
			progress = 0
		shell_type.HE:
			print("LOAD HE")
			load_shell = shell_type.HE
			progress = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _get_navnodes():
	return nav_nodes

func _get_hatchnodes():
	return hatch_nodes
