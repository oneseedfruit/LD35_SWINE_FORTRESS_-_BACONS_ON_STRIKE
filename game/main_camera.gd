
extends Camera2D

onready var fortress_body = get_parent().get_node("fortress/fortress_body")

func _ready():
	OS.set_window_maximized(true)
	set_fixed_process(true)


func _fixed_process(delta):	
	set_global_pos(fortress_body.get_global_pos())
	set_rot(5 * delta * fortress_body.get_rot())


