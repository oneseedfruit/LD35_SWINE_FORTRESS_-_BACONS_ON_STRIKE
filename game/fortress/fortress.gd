
extends Node2D

export var move_force = 300

const IDLE = 0
const LEFT = 1
const RIGHT = 2

const ONE = 1
const TWO = 2
const THREE = 3

onready var fortress_body = get_node("fortress_body")
onready var move_director = get_node("move_director")
onready var fortress_formation = get_node("fortress_formation")
onready var formation_button = move_director.get_node("formation_button")

var delta

var direction = IDLE
var formation = ONE

var stopped = false

var dead_pigs_count = 0

# PRIVATE #

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	

func _fixed_process(delta):
	self.delta = delta 	
	
	move_director.set_pos(fortress_body.get_pos())

	if not stopped:
		if fortress_body.get_transform().get_rotation() < move_director.get_transform().get_rotation() - 0.1:
			fortress_body.set_angular_velocity(-0.5)
		elif fortress_body.get_transform().get_rotation() > move_director.get_transform().get_rotation() + 0.1: 
			fortress_body.set_angular_velocity(0.5)
		else:
			fortress_body.set_angular_velocity(0.0)	
	else:
		fortress_body.set_angular_velocity(0.0)	
	
	if direction == LEFT:
		move_director.set_rot(move_director.get_rot() + 10 * delta)
	elif direction == RIGHT:
		move_director.set_rot(move_director.get_rot() - 10 * delta)	
		
	if dead_pigs_count == 8:
		globals.is_game_over = true


func _input(event):	
	if event.is_action("left"):
		direction = LEFT
	elif event.is_action("right"):
		direction = RIGHT
	else:
		direction = IDLE
		
	if event.is_action_released("left"):
		direction = IDLE
	elif event.is_action_released("right"):
		direction = IDLE


func _on_rotate_timer_timeout():
	if not stopped:		
		fortress_body.set_applied_force((move_director.get_node("direction").get_global_pos() - move_director.get_global_pos()).normalized() * move_force)


func _on_formation_button_pressed():
	formation_button.set_focus_mode(Control.FOCUS_NONE)
	
	if not stopped:
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
