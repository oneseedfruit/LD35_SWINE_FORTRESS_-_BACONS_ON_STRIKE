
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
	globals.cats_count = globals.cats_count - 1
	globals.credits = globals.credits + 1
	
	if globals.cats_count <= 0:
		globals.set_next_wave()	


func set_attacked():
	cat_animation.play("die")
	set_linear_velocity(Vector2(0, 0))


# PRIVATE #

func _ready():
	globals.cats_count = globals.cats_count + 1
	if is_alive:		
		target_vector = globals.fortress_body.get_global_pos() - get_global_pos()	
	set_process(true)


func _process(delta):
	if is_alive:
		target_vector = globals.fortress_body.get_global_pos() - get_global_pos()
		var rot = atan2(target_vector.x, target_vector.y) - deg2rad(180)
		cat_sprites.set_rot(rot)
		rot_temp = get_rot()
	else:
		if abs(get_global_pos().x - globals.fortress_body.get_global_pos().x) > 10000 or abs(get_global_pos().y - globals.fortress_body.get_global_pos().y) > 10000:
			queue_free()


func _on_move_timer_timeout():		
	if is_alive:
		set_linear_velocity(Vector2(0, 0))
		move_force = rand_range(-50, 50) + move_force
		randomize()
		set_applied_force(target_vector.normalized() * move_force)
	


func _on_cat_area_area_enter( area ):
	if is_alive:
		if area.get_name() == "fenced" or area.get_name() == "water_tray" or area.has_method("_on_swine_mouse_enter") or area.get_name() == "cat_area":
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
				if area.health < 1 and not area.has_water:
					area.swine_animation.play("die")
					area.swine_square.set_scale(Vector2(0, 0))
					area.swine_square.set_hidden(true)
					area.swine_triangle.set_scale(Vector2(0, 0))
					area.swine_triangle.set_hidden(true)
					area.health_bar.set_hidden(true)
					area.set_owner(area.get_parent().get_parent().get_parent())
					area.get_parent().get_parent().dead_pigs_count = area.get_parent().get_parent().dead_pigs_count + 1
					cat_sprites.set_scale(Vector2(cat_sprites.get_scale().x + 0.2, cat_sprites.get_scale().y + 0.2))