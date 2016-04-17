
extends Node

onready var fortress = get_node("/root/main_scene/fortress")
onready var fortress_body = fortress.get_node("fortress_body")
onready var fenced = get_node("/root/main_scene/fenced")

var is_game_over = false

func _ready():
	pass


