
extends Node2D

export var move_force = 1000

const IDLE = 0
const LEFT = 1
const RIGHT = 2

const ONE = 1
const TWO = 2
const THREE = 3

onready var fortress_body = get_node("fortress_body")
onready var move_director = get_node("move_director")
onready var left_control_sprite = move_director.get_node("direction_sprite/left_control")
onready var right_control_sprite = move_director.get_node("direction_sprite/right_control")
onready var stop_control_sprite = move_director.get_node("direction_sprite/stop_control")
onready var fortress_formation = get_node("fortress_formation")
onready var formation_button = move_director.get_node("formation_button")

var delta

var direction = IDLE
var formation = ONE

var target_vector
var rot_radians

var pigs_count = 0


# PRIVATE #

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	

func _fixed_process(delta):
	self.delta = delta 	
	
	move_director.set_pos(fortress_body.get_pos())
	
	target_vector = move_director.get_node("direction").get_pos() - fortress_body.get_pos()	
	rot_radians = atan2(target_vector.x, target_vector.y) - deg2rad(180)
	
	if direction == LEFT:
		move_director.set_rot(move_director.get_rot() + 2 * delta)
		
	elif direction == RIGHT:
		move_director.set_rot(move_director.get_rot() - 2 * delta)			
		
		
		
	pigs_count = 0
	for node in fortress_body.get_children():
		if node.has_method("_on_swine_attack_area_enter"):
			if not node.is_dead:
				pigs_count = pigs_count + 1
	
	if pigs_count <= 0:
		globals.is_game_over = true
	
	print(pigs_count)
	

func _input(event):	
	if event.is_action("left"):
		direction = LEFT		
		left_control_sprite.set_modulate(Color(0, 0, 0))
		
		if rot_radians != 0:
			fortress_body.set_angular_velocity(-1.0)
		else:
			fortress_body.set_angular_velocity(0.0)
		
	elif event.is_action("right"):
		direction = RIGHT
		right_control_sprite.set_modulate(Color(0, 0, 0))
		
		if rot_radians != 0:
			fortress_body.set_angular_velocity(1.0)
		else:
			fortress_body.set_angular_velocity(0.0)
			
	elif event.is_action("move"):		
		stop_control_sprite.set_modulate(Color(0, 0, 0))
		
		fortress_body.set_linear_velocity(Vector2(0, 0))
		fortress_body.set_applied_force((move_director.get_node("direction").get_global_pos() - move_director.get_global_pos()).normalized() * move_force * 6)
	else:
		direction = IDLE
		
	if event.is_action_released("left"):
		direction = IDLE
		left_control_sprite.set_modulate(Color(1, 1, 1))
	elif event.is_action_released("right"):
		direction = IDLE
		right_control_sprite.set_modulate(Color(1, 1, 1))
		
	if event.is_action_released("move"):
		stop_control_sprite.set_modulate(Color(1, 1, 1))
		

# SIGNALS #

func _on_rotate_timer_timeout():	
	if fortress_body.get_linear_velocity().x < move_force * 2 and fortress_body.get_linear_velocity().y < move_force * 2:
		fortress_body.set_applied_force((move_director.get_node("direction").get_global_pos() - move_director.get_global_pos()).normalized() * move_force)


func _on_formation_button_pressed():
	formation_button.set_focus_mode(Control.FOCUS_NONE)	

	if not fortress_formation.is_playing():
		if formation < 3:
			formation = formation + 1
		else:
			formation = 1	
		
		if formation == ONE:
			fortress_formation.play("formation_3_to_1")
		elif formation == TWO:
			fortress_formation.play("formation_1_to_2")
		elif formation == THREE:
			fortress_formation.play("formation_2_to_3")
