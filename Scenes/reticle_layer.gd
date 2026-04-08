extends CanvasLayer

@onready var reticle = $CenterContainer/reticle
var ray: RayCast3D

var tween
var is_hovering := false

func _ready():
	reticle.visible = false
	reticle.scale = Vector2(0.5, 0.5)

func _process(_delta: float) -> void:
	if ray.is_colliding():
		var obj = ray.get_collider()
		
		if obj.is_in_group("Pickups"):
			if !is_hovering:
				is_hovering = true
				reveal_reticle()
		else:
			if is_hovering:
				is_hovering = false
				hide_reticle()
	else:
		if is_hovering:
			is_hovering = false
			hide_reticle()
			
func reveal_reticle():
	if tween:
		tween.kill()
		
	reticle.visible = true
	tween = create_tween()
	tween.tween_property(reticle, "scale", Vector2(1, 1), 0.1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func hide_reticle():
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(reticle, "scale", Vector2(0.5, 0.5), 0.1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)\
		.as_callback([reticle], "hide")
