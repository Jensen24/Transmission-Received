extends Node3D

var transition := false
@export var teleportPoint : Marker3D
@onready var fade = $"../FinaleManager/CanvasLayer/ColorRect"
@onready var snow = $"../Player/Snowfall"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if transition:
		return
	if body.is_in_group("Player") && body.hasKey == true:
		transition = true
		
		var fadeOut = create_tween()
		fadeOut.tween_property(fade, "color:a", 1.0, 1.0)
		await fadeOut.finished
		
		body.global_position = teleportPoint.global_position
		snow.visible = true
		
		var fadeIn = create_tween()
		fadeIn.tween_property(fade, "color:a", 0.0, 1.0)
		await fadeIn.finished
		
		transition = false
