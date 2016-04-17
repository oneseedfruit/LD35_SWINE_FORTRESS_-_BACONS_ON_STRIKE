
extends RigidBody2D

export var move_force = 200.0

onready var cat_sprites = get_node("sprites")
onready var cat_animation = get_node("cat_animation")
onready var move_timer = get_node("move_timer")

var target_vector
var is_alive = true

var rot_temp

# PUBLIC #

func set_die():
	is_alive = false
	set_linear_velocity(Vector2(0, 0))
	move_timer.set_autostart(false)


func set_attacked():
	cat_animation.play("die")
	set_linear_velocity(Vector2(0, 0))


# PRIVATE #

func _ready():
	if is_alive:
		target_vector = globals.fortress_body.get_global_pos() - get_global_pos()	
	set_process(true)


func _process(delta):
	if is_alive:
		target_vector = globals.fortress_body.get_global_pos() - get_global_pos()
		var rot = atan2(target_vector.x, target_vector.y) - deg2rad(180)
		cat_sprites.set_rot(rot)
		rot_temp = get_rot()

func _on_move_timer_timeout():		
	if is_alive:
		set_linear_velocity(Vector2(0, 0))
		set_applied_force(target_vector.normalized() * move_force)
	


func _on_cat_area_area_enter( area ):
	if is_alive:
		if area.get_name() == "fenced" or area.get_name() == "water_tray" or area.has_method("_on_swine_mouse_enter"):
			if get_global_pos().x > globals.fenced.get_node("bound3").get_global_pos().x and get_global_pos().x < globals.fenced.get_node("bound4").get_global_pos().x and get_global_pos().y > globals.fenced.get_node("bound1").get_global_pos().y and get_global_pos().y < globals.fenced.get_node("bound2").get_global_pos().y:
				set_linear_velocity(get_linear_velocity().normalized() * -1000)
		
		if area.has_method("_on_swine_mouse_enter"):
			if area.has_water:
				area.swine_animation.play("to_triangle")			
				area.swine_saliva.set_emitting(false)
				area.water_gun.set_emitting(true)
				area.splash_particles.set_emitting(true)
				area.has_water = false
			else:
				area.set_hurt(rand_range(20.0, 25.0))
				area.hurt_particles.set_emitting(true)
				if area.health < 1:
					area.swine_animation.play("die")
					area.swine_square.queue_free()
					area.swine_triangle.queue_free()
					area.health_bar.set_hidden(true)
					area.set_owner(area.get_parent().get_parent().get_parent())
					area.get_parent().get_parent().dead_pigs_count = area.get_parent().get_parent().dead_pigs_count + 1