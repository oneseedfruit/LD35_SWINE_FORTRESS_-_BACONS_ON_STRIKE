
extends Node

export var resurrect_credits = 2

const CAT_SCN = preload("res://cat/cat.tscn")

onready var spawn_points = get_node("/root/main_scene/spawn_points")
onready var fortress = get_node("/root/main_scene/fortress")
onready var fortress_body = fortress.get_node("fortress_body")
onready var fenced = get_node("/root/main_scene/fenced")

var has_game_started = false
var is_game_over = false

var wave = 0
var has_wave_started = false
var wave_cats_count = 0

var init_cats_count = 5
var cats_count = 0

var credits = 0

func set_next_wave():
	has_wave_started = false
	

func _ready():
	set_process(true)


func _process(delta):
	if has_game_started and not is_game_over:
		if not has_wave_started:
			wave = wave + 1
			has_wave_started = true
			
			if wave == 1:
				wave_cats_count = init_cats_count
			else:
				wave_cats_count = wave_cats_count + 1
				
			for i in range(0, wave_cats_count):			
				var cat = CAT_SCN.instance()
				get_node("/root/main_scene").add_child(cat)
				cat.set_global_pos(spawn_cats_pos())
			
	print(cats_count)

	
func spawn_cats_pos():
	var spawn_pos
	
	for point in spawn_points.get_children():
		if rand_range(0, 1) < 0.2:
			spawn_pos = spawn_points.get_node("spawn1").get_global_pos()
		elif rand_range(0, 1) > 0.4:
			spawn_pos = spawn_points.get_node("spawn2").get_global_pos()
		elif rand_range(0, 1) < 0.6:
			spawn_pos = spawn_points.get_node("spawn3").get_global_pos()
		elif rand_range(0, 1) > 0.8:
			spawn_pos = spawn_points.get_node("spawn4").get_global_pos()
	randomize()
	
	return spawn_pos
