extends Node3D


var signature := ""
@onready var tag = $Label3D

func _ready():
	await get_tree().create_timer(0.2).timeout
	tag.text = signature
