
extends RigidBody2D

export var move_force = 20.0

onready var cat_sprites = get_node("sprites")
onready var yum = get_node("yum")
onready var cat_animation = get_node("cat_animation")
onready var move_timer = get_node("move_timer")
onready var cat_player = get_node("cat_player")
onready var fortress_body = get_node("/root/main_scene/fortress/fortress_body")
onready var fenced = get_node("/root/main_scene/fenced")

var target_vector
var is_alive = true

var rot_temp

# PUBLIC #

func set_die():	
	cat_player.play("destroyedcat")
	globals.cats_count = globals.cats_count - 1
	globals.credits = globals.credits + 1	
	set_linear_velocity(Vector2(0, 0))
	set_gravity_scale(2)
	is_alive = false	
	move_timer.set_autostart(false)		
	

func set_attacked():	
	cat_animation.play("die")
	cat_player.play("diecat")


# PRIVATE #

func _ready():	
	if is_alive:
		globals.cats_count = globals.cats_count + 1				
	set_process(true)


func _process(delta):	
	if is_alive:
		target_vector = fortress_body.get_global_pos() - get_global_pos()
		var rot = atan2(target_vector.x, target_vector.y) - deg2rad(180)
		cat_sprites.set_rot(rot)
		rot_temp = get_rot()
	else:
		yum.set_hidden(true)
		if abs(get_global_pos().x - fortress_body.get_global_pos().x) > 100000 or abs(get_global_pos().y - fortress_body.get_global_pos().y) > 100000:
			queue_free()			


func _on_move_timer_timeout():		
	if is_alive:
		set_linear_velocity(Vector2(0, 0))
		move_force = rand_range(0, 50) + move_force
		randomize()
		set_applied_force(target_vector.normalized() * move_force)
		if rand_range(0, 1.1) > 0.4:
			cat_player.play("yum", 0)
			yum.set_hidden(false)
			randomize()
		else:
			yum.set_hidden(true)


func _on_cat_area_area_enter( area ):
	if is_alive:
		if area.get_name() == "fenced" or area.get_name() == "water_tray" or area.has_method("_on_swine_mouse_enter") or area.get_name() == "cat_area":
			if get_global_pos().x > fenced.get_node("bound3").get_global_pos().x and get_global_pos().x < fenced.get_node("bound4").get_global_pos().x and get_global_pos().y > fenced.get_node("bound1").get_global_pos().y and get_global_pos().y < fenced.get_node("bound2").get_global_pos().y:
				set_linear_velocity(get_linear_velocity().normalized() * -1000)
		
		if area.has_method("_on_swine_mouse_enter"):
			if area.has_water and not area.is_dead:
				area.set_to_attack()
			elif not area.is_dead:
				area.set_to_be_hurt(rand_range(20.0, 25.0))
				cat_sprites.set_scale(Vector2(cat_sprites.get_scale().x + 0.05, cat_sprites.get_scale().y + 0.05))