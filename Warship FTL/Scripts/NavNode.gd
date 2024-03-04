extends Node

export (Array, NodePath) var con_FU = []
var connections = []
onready var from_room = $".."
var NavnodeID = -1

func _ready():
	for i in con_FU.size():
		connections.append(con_FU[i])
	print("NavNode: " + from_room.name + ", " + name + " ready!")

