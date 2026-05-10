extends Node3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") && body.hasKey == true:
		pass #Scene transition stuff. Add TextureRect that starts transparent then fades to black
		# Also add timer that counts downbefore teleporting player outside. This allows fade to black to occur making it look seamless.
		# https://www.youtube.com/watch?v=3B6PkxE4wNU  
