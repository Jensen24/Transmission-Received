extends Node

@onready var cue: AudioStreamPlayer3D = $SFXSystem
@onready var ambi = $AmbianceSystem
@onready var music = $MusicSystem
@onready var player

var footstepDelay := 0.6
var footstepTimer := 0.0

var snowFoots = [
	preload("res://Audio/snow1.wav"),
	preload("res://Audio/snow2.wav"),
	preload("res://Audio/snow3.wav"),
	preload("res://Audio/snow4.wav")
]
var stoneFoots = [
	preload("res://Audio/stone1.wav"),
	preload("res://Audio/stone2.wav"),
	preload("res://Audio/stone3.wav")
]
var metalFoots = [
	preload("res://Audio/metal1.wav"),
	preload("res://Audio/metal2.wav"),
	preload("res://Audio/metal3.wav")
]
func _process(delta: float) -> void:
	if footstepTimer > 0:
		footstepTimer -= delta
	
func play_footstep(sound: AudioStream):
	if player == null:
		return
	if footstepTimer > 0:
		return
	footstepTimer = footstepDelay
	cue.stream = sound
	cue.pitch_scale = randf_range(0.8, 1)
	cue.global_position = player.global_position
	cue.play()
