extends Node3D

@onready var place_holder = $Placeholder

var rotationSpeed := 0.01

func set_item(scene: PackedScene):
	var obj = scene.instantiate()
	place_holder.add_child(obj)
	
#func _input(event):
	#if event is InputEventMouseMotion:
		#place_holder.rotate_y(-event.relative.x * rotationSpeed)
		#place_holder.rotate_x(-event.relative.y * rotationSpeed)
