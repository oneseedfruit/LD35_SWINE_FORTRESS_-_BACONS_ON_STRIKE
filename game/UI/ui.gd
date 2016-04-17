
extends CanvasLayer

onready var credits = get_node("in-game/credits")
onready var main_menu = get_node("main_menu")
onready var main_menu_panel = main_menu.get_node("main_menu_panel")
onready var click_to_go_on_strike = main_menu.get_node("start_button/click_to_go_on_strike")

func _ready():
	if not globals.has_game_started:
		get_tree().set_pause(true)
	
	set_process(true)
	

func _process(delta):
	credits.set_text(str("Credits: ", globals.credits))


func _on_start_button_mouse_enter():
	click_to_go_on_strike.set_hidden(false)


func _on_start_button_mouse_exit():
	click_to_go_on_strike.set_hidden(true)


func _on_start_button_pressed():
	main_menu.set_hidden(true)
	get_tree().set_pause(false)
	globals.has_game_started = true
	
