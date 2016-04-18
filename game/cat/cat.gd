
extends RigidBody2D

export var move_force = 20.0

onready var cat_sprites = get_node("sprites")
onready var cat_animation = get_node("cat_animation")
onready var move_timer = get_node("move_timer")
onready var cat_player = get_node("cat_player")

var target_vector
var is_alive = true

var rot_temp

# PUBLIC #

func set_die():	
	cat_player.play("deadcat")
	
	globals.cats_count = globals.cats_count - 1
	globals.credits = globals.credits + 1	
	set_linear_velocity(Vector2(0, 0))
	set_gravity_scale(2)
	is_alive = false	
	move_timer.set_autostart(false)		
	

func set_attacked():	
	cat_animation.play("die")


# PRIVATE #

func _ready():	
	if is_alive:
		globals.cats_count = globals.cats_count + 1				
		target_vector = globals.fortress_body.get_global_pos() - get_global_pos()	
	set_process(true)


func _process(delta):
	if is_alive:
		target_vector = globals.fortress_body.get_global_pos() - get_global_pos()
		var rot = atan2(target_vector.x, target_vector.y) - deg2rad(180)
		cat_sprites.set_rot(rot)
		rot_temp = get_rot()
	else:
		if abs(get_global_pos().x - globals.fortress_body.get_global_pos().x) > 100000 or abs(get_global_pos().y - globals.fortress_body.get_global_pos().y) > 100000:
			queue_free()


func _on_move_timer_timeout():		
	if is_alive:
		set_linear_velocity(Vector2(0, 0))
		move_force = rand_range(0, 50) + move_force
		randomize()
		set_applied_force(target_vector.normalized() * move_force)


func _on_cat_area_area_enter( area ):
	if is_alive:
		if area.get_name() == "fenced" or area.get_name() == "water_tray" or area.has_method("_on_swine_mouse_enter") or area.get_name() == "cat_area":
			if get_global_pos().x > globals.fenced.get_node("bound3").get_global_pos().x and get_global_pos().x < globals.fenced.get_node("bound4").get_global_pos().x and get_global_pos().y > globals.fenced.get_node("bound1").get_global_pos().y and get_global_pos().y < globals.fenced.get_node("bound2").get_global_pos().y:
				set_linear_velocity(get_linear_velocity().normalized() * -1000)
		
		if area.has_method("_on_swine_mouse_enter"):
			if area.has_water:
				area.set_to_attack()
			else:
				area.set_to_be_hurt(rand_range(20.0, 25.0))
				cat_sprites.set_scale(Vector2(cat_sprites.get_scale().x + 0.05, cat_sprites.get_scale().y + 0.05))