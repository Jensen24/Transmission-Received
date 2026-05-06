extends Node3D


var signature := ""
@onready var tag = $Label3D

func _ready() -> void:
	tag.text = signature
