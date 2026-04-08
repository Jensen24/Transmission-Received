extends Node3D
@export var inspect_object: PackedScene
var player_in_range := false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Interact Pressed")
		get_node("/root/main").start_inspect(inspect_object)


func _on_area_3d_body_entered(body):
	print("Entered: ", body, " | name:", body.name, " | type:", body.get_class())
	if body.name == "player":
		player_in_range = true


func _on_area_3d_body_exited(body):
	print("Exited: ", body.name)
	if body.name == "player":
		player_in_range = false
