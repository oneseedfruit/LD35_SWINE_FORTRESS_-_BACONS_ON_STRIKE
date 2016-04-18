
extends CanvasLayer

onready var credits = get_node("in-game/credits")
onready var main_menu = get_node("main_menu")
onready var main_menu_panel = main_menu.get_node("main_menu_panel")
onready var click_to_go_on_strike = main_menu.get_node("start_button/click_to_go_on_strike")
onready var wave_label = get_node("in-game/wave")

func _ready():
	if not globals.has_game_started:
		get_tree().set_pause(true)
	
	set_process(true)
	set_process_input(true)
	

func _process(delta):
	credits.set_text(str("Credits: ", globals.credits))
	if globals.is_game_over:
		main_menu.set_hidden(false)
		get_tree().set_pause(true)
		click_to_go_on_strike.set_text("GAME OVER! CLICK TO RESTART")


func _input(event):
	if event.is_action("ui_cancel"):
		if globals.has_game_started:
			main_menu.set_hidden(false)
			get_tree().set_pause(true)
			click_to_go_on_strike.set_text("GAME PAUSED! CLICK TO CONTINUE")
		

func _on_start_button_mouse_enter():
	click_to_go_on_strike.set_hidden(false)


func _on_start_button_mouse_exit():
	click_to_go_on_strike.set_hidden(true)


func _on_start_button_pressed():
	if globals.is_game_over:
		globals.is_game_over = false
		globals.credits = 0
		get_tree().reload_current_scene()
		
	main_menu.set_hidden(true)
	get_tree().set_pause(false)
	globals.has_game_started = true	


func _on_wave_timer_timeout():
	wave_label.set_hidden(true)


func _on_restart_button_pressed():
	globals.is_game_over = false
	globals.credits = 0
	globals.has_wave_started = false
	get_tree().reload_current_scene()
