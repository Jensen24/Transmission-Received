extends Node

@onready var angel = $LPAngel
@onready var beam = $SpotLight3D
@onready var fade = $CanvasLayer/ColorRect
@onready var choir = $Angelic
@onready var worldenv = $"../WorldEnvironment"

func _ready():
	fade.color.a = 0.0
	beam.light_energy = 0.0
	beam.visible = false
	angel.visible = false
	
func begin_finale():
	beam.visible = true
	angel.visible = true
	AudioManager.ambi.volume_db = -13
	AudioManager.puzzleLoop.volume_db = -26
	choir.play()
	var lightTween = create_tween()
	lightTween.parallel().tween_property(beam, "light_energy", 3.0, 5.0)
	
	var fogTween = create_tween()
	fogTween.tween_property(worldenv.environment, "fog_light_energy", 0.1, 5.0)
	
	await get_tree().create_timer(4.0).timeout
	
	var angelTween = create_tween()
	angelTween.parallel().tween_property(angel, "position:y", angel.position.y - 15.0, 11.0)
	angelTween.parallel().tween_property(angel, "position:z", angel.position.z + 25.0, 11.0)
	angelTween.parallel().tween_property(angel, "scale", angel.scale * 5, 11.0)
	await get_tree().create_timer(3.0).timeout
	fade_to_black()
	
func fade_to_black():
	var fadeTween = create_tween()
	fadeTween.tween_property(fade, "color:a", 1.0, 7.0)
	await fadeTween.finished
	get_tree().quit()
