
extends RigidBody2D

onready var cat_sprites = get_node("sprites")

var target_vector

# PUBLIC #

func set_attacked():
	print("attacking cat!")


# PRIVATE #

func _ready():
	target_vector = globals.fortress_body.get_global_pos() - get_global_pos()
	
	set_process(true)


func _process(delta):
	target_vector = globals.fortress_body.get_global_pos() - get_global_pos()
	var rot = atan2(target_vector.x, target_vector.y) - deg2rad(180)
	cat_sprites.set_rot(rot)


func _on_move_timer_timeout():		
	set_applied_force(target_vector.normalized() * 1000.0)
	


func _on_cat_area_area_enter( area ):
	if area.get_name() == "fenced" or area.get_name() == "water_tray" or area.has_method("_on_swine_mouse_enter"):
		set_linear_velocity(get_linear_velocity().normalized() * -1000)
	
	if area.has_method("_on_swine_mouse_enter"):
		if area.has_water:
			area.swine_animation.play("to_triangle")			
			area.swine_saliva.set_emitting(false)
			area.water_gun.set_emitting(true)
			area.splash_particles.set_emitting(true)
			area.has_water = false