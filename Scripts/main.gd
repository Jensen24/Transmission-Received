extends Node

@onready var pause_menu: Control = $HUD/PauseMenu
var paused = false

func _ready() -> void:
	pause_menu.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.resume_game.connect(_on_resume_game)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
func _on_resume_game():
	pause_menu.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = false

func pauseMenu():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		pause_menu.show()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	paused = !paused
