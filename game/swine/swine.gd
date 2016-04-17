
extends Area2D

const SQUARE = 0
const TRIANGLE = 1

export var current_shape = SQUARE
export var health = 100.0

onready var fortress = get_parent().get_parent()
onready var fortress_body = get_parent()
onready var swine_square = get_node("swine_square")
onready var swine_triangle = get_node("swine_triangle")
onready var swine_sprite = get_node("swine_sprite")
onready var swine_saliva = swine_sprite.get_node("saliva_particles")
onready var splash_particles = swine_sprite.get_node("splash_particles")
onready var health_bar = swine_sprite.get_node("health_bar")
onready var hurt_particles = swine_sprite.get_node("hurt_particles")
onready var water_gun = get_node("swine_attack").get_node("water_gun")
onready var swine_animation = get_node("swine_morph_animation")
onready var swine_move_animation = get_node("swine_move_animation")

var is_selected = false
var has_water = false
var has_food = false

# PUBLIC #

func set_dead():
	health_bar.set_hidden(true)
	set_owner(get_parent().get_parent().get_parent())


func set_hurt(hurt_val):
	health = health - hurt_val


# call from swine_animation node
func set_shape(shape):
	current_shape = shape


# PRIVATE #

func _ready():
	swine_animation.set_speed(1)
	swine_move_animation.set_speed(1)	
	swine_move_animation.play("moving")
	
	if current_shape == SQUARE:
		swine_animation.play("to_square")
	elif current_shape == TRIANGLE:
		swine_animation.play("to_triangle")
	
	if has_water or has_food:
		swine_animation.play("to_square")
		swine_saliva.set_emitting(true)
	else:
		swine_animation.play("to_triangle")
		swine_saliva.set_emitting(false)
		
	set_process(true)


func _process(delta):
	health_bar.set_value(health)


func _on_swine_mouse_enter():	
	if health > 0:
		swine_sprite.set_modulate(Color(1.0, 0.54, 0.77))
		is_selected = true


func _on_swine_mouse_exit():
	if health > 0:
		swine_sprite.set_modulate(Color(1.0, 1.0, 1.0))
		is_selected = false


func _on_swine_input_event( viewport, event, shape_idx ):
	if health > 0:
		if is_selected:		
			if event.type == InputEvent.MOUSE_BUTTON:
				if has_water:
					swine_sprite.set_modulate(Color(0.4, 0.8, 1))
					swine_animation.set_speed(1)
					if current_shape == SQUARE:
						swine_animation.play("to_triangle")
						has_water = false
						swine_saliva.set_emitting(false)
						water_gun.set_emitting(true)
						splash_particles.set_emitting(true)


func _on_mouth_area_area_enter( area ):	
	if health > 0:
		if area.has_method("get_water_tray") and not has_water:
			has_water = true
			swine_saliva.set_emitting(true)
			swine_animation.play("to_square")
			if health < 100.0:
				health = health + rand_range(10.0, 15.0)
			fortress_body.set_applied_force((fortress_body.get_pos() - get_pos()).normalized() * -1000)


func _on_swine_area_enter( area ):
	if health > 0:
		if area.has_method("get_water_tray") or area.get_name() == "fenced":
			fortress.stopped = true
			fortress_body.set_linear_velocity((fortress_body.get_pos() - get_pos()).normalized() * - 5)
			fortress_body.set_applied_force((fortress_body.get_pos() - get_pos()).normalized() * -1000)


func _on_swine_area_exit( area ):
	if health > 0:
		fortress.stopped = false


func _on_swine_attack_area_enter( area ):
	if health > 0:
		if water_gun.is_emitting():
			if area.get_name() == "cat_area":
				area.get_parent().set_attacked()			


func _on_resurrect_button_pressed():
	if health < 1 and globals.credits >= globals.resurrect_credits:
		globals.credits = globals.credits - globals.resurrect_credits
		swine_square.set_scale(Vector2(1, 1))
		swine_square.set_hidden(false)
		swine_triangle.set_scale(Vector2(1, 1))
		swine_triangle.set_hidden(false)
		health = 100.0
		swine_animation.play("to_triangle")
		health_bar.set_hidden(false)		
		health_bar.set_value(100.0)
		health_bar.set_size(Vector2(157, 11))
		print(health_bar.get_pos())
		get_node("resurrect_button").set_hidden(true)
		set_owner(globals.fortress_body)
