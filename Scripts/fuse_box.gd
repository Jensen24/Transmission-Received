extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") && body.hasKey == true:
		get_node("AnimationPlayer").play("flap_open")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") && body.hasKey == true:
		get_node("AnimationPlayer").play("flap_close")
