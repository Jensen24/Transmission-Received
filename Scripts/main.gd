extends Node

@onready var player = $World/Player
@onready var pause_menu: Control = $HUD/PauseMenu
#var inspect_scene = preload("res://Scenes/inspect_system.tscn")
#var inspecting := false
#var inspect_instance = null
var paused = false

func _ready() -> void:
	pause_menu.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.resume_game.connect(_on_resume_game)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
#func start_inspect(item_scene: PackedScene):
	#if inspecting:
		#return
	#inspecting = true
	#player.set_process(false)
	#
	#inspect_instance = inspect_scene.instantiate()
	#add_child(inspect_instance)
	#inspect_instance.set_item(item_scene)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#
#func stop_inspect():
	#inspecting = false
	#
	#player.set_process(true)
	#inspect_instance.queue_free()
	#inspect_instance = null
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#func _input(event):
	#if Input.is_action_just_pressed("interact"):
		#if inspecting:
			#stop_inspect()

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
