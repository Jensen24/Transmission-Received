extends CanvasLayer

@onready var ray = $Neck/Camera3D/RayCast3D
@onready var reticle = $CenterContainer/reticle

var tween
var is_hovering := false

func _process(_delta: float) -> void:
	if ray.is_colliding():
		var obj = ray.get_collider()
		
		if obj.is_in_group("pickup"):
			if !is_hovering:
				is_hovering = true
				enlarge_reticle()
		else:
			if is_hovering:
				is_hovering = false
				reset_reticle()
	else:
		if is_hovering:
			is_hovering = false
			reset_reticle()
			
func enlarge_reticle():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(reticle, "scale", Vector2(1.2, 1.2), 0.1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func reset_reticle():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(reticle, "scale", Vector2(1, 1), 0.1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
